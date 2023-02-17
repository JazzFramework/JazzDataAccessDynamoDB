import AWSDynamoDB;

import JazzDataAccess;

//TODO: Error Handling
public final class DynamoDBRepository<TResource: Storable>: Repository<TResource> {
    private final let delegate: DynamoDBRepositoryDelegate<TResource>;

    private final let dynamoDbClient: DynamoDBClientProtocol;

    public init(delegate: DynamoDBRepositoryDelegate<TResource>) {        
        self.delegate = delegate;

        self.dynamoDbClient = try! DynamoDBClient(region: "us-east-1");

        super.init();
    }

    public final override func create(_ models: [TResource], with hints: [QueryHint]) async throws -> [TResource] {
        return try await update(models, with: hints);
    }

    public final override func update(_ models: [TResource], with hints: [QueryHint]) async throws -> [TResource] {
        var resultModels: [TResource] = [];

        for batchModels in models.chunked(into: 25) {
            var items: [DynamoDBClientTypes.WriteRequest] = [];

            for model in batchModels {
                items.append(DynamoDBClientTypes.WriteRequest(putRequest:
                    DynamoDBClientTypes.PutRequest(item: getItemAttributes(model))
                ));
            }

            let result: BatchWriteItemOutputResponse = try await dynamoDbClient.batchWriteItem(input:
                BatchWriteItemInput(requestItems: [getTableName(): items])
            );

            if let itemCollectionMetrics = result.itemCollectionMetrics?[getTableName()] {
                for itemCollection in itemCollectionMetrics {
                    if
                        let itemCollectionKey = itemCollection.itemCollectionKey,
                        let resource = getResource(itemCollectionKey)
                    {
                        resultModels.append(resource);
                    }
                }
            }
        }

        return resultModels;
    }

    public final override func delete(for criteria: [QueryCriterion], with hints: [QueryHint]) async throws {
        let models: [TResource] = try await get(for: criteria, with: hints);

        for batchModels in models.chunked(into: 25) {
            var items: [DynamoDBClientTypes.WriteRequest] = [];

            for model in batchModels {
                items.append(DynamoDBClientTypes.WriteRequest(deleteRequest:
                    DynamoDBClientTypes.DeleteRequest(key: ["id": DynamoDBClientTypes.AttributeValue.s(model.getId())])
                ));
            }

            _ = try await dynamoDbClient.batchWriteItem(input:
                BatchWriteItemInput(requestItems: [getTableName(): items])
            );
        }
    }

    public final override func get(for criteria: [QueryCriterion], with hints: [QueryHint]) async throws -> [TResource] {
        let query: DynamoDBQuery<TResource> = getQuery();

        try getCriterionProcessor().handle(for: query, with: criteria);

        try getHintProcessor().handle(for: query, with: hints);

        let result: QueryOutputResponse = try await dynamoDbClient.query(input: query.toQuery());

        if let items = result.items {
            var results: [TResource] = [];

            for item in items {

                if let resource = getResource(item) {
                    results.append(resource);
                }
            }

            return results;
        }

        //TODO: Update error
        throw DataAccessErrors.notFound(reason: "Could not read updated resource.");
    }

    private final func getItemUpdateAttributes(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValueUpdate] {
        let itemValues: [String: DynamoDBClientTypes.AttributeValue] = getItemAttributes(model);

        var result: [String: DynamoDBClientTypes.AttributeValueUpdate] = [:];

        for (itemKey, itemValue) in itemValues {
            result[itemKey] = DynamoDBClientTypes.AttributeValueUpdate(action: .put, value: itemValue);
        }

        return result;
    }

    private final func getCriterionProcessor() -> CriterionProcessor<TResource> {
        return delegate.getCriterionProcessor();
    }

    private final func getHintProcessor() -> HintProcessor<TResource> {
        return delegate.getHintProcessor();
    }

    private final func getTableName() -> String {
        return delegate.getTableName();
    }

    private final func getItemAttributes(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValue] {
        return delegate.getItemAttributes(model);
    }

    private final func getResource(_ item: [String: DynamoDBClientTypes.AttributeValue]) -> TResource? {
        return delegate.getResource(item);
    }

    private func getQuery() ->  DynamoDBQuery<TResource> {
        return DynamoDBQuery<TResource>();
    }
}