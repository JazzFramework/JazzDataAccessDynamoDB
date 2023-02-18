import AWSDynamoDB;

import JazzConfiguration;
import JazzDataAccess;

//TODO: Error Handling
internal final class DynamoDBRepository<TResource: Storable>: Repository<TResource> {
    private final let dynamoDbClient: DynamoDBClientProtocol;
    private final let delegate: DynamoDBRepositoryDelegate<TResource>;
    private final let criterionProcessor: CriterionProcessor<TResource>;
    private final let hintProcessor: HintProcessor<TResource>;

    internal init(
        client: DynamoDBClientProtocol,
        delegate: DynamoDBRepositoryDelegate<TResource>,
        criterionProcessor: CriterionProcessor<TResource>,
        hintProcessor: HintProcessor<TResource>
    ) async throws {
        self.dynamoDbClient = client;
        self.delegate = delegate;
        self.criterionProcessor = criterionProcessor;
        self.hintProcessor = hintProcessor;

        super.init();
    }

    public final override func get(for criteria: [QueryCriterion], with hints: [QueryHint]) async throws -> [TResource] {
        let query: DynamoDBQuery<TResource> = DynamoDBQuery<TResource>();

        try criterionProcessor.handle(for: query, with: criteria);

        try hintProcessor.handle(for: query, with: hints);

        let result: QueryOutputResponse = try await dynamoDbClient.query(input: query.input);

        var results: [TResource] = [];

        if let items = result.items {
            for item in items {
                if let resource = delegate.getResource(item) {
                    results.append(resource);
                }
            }
        }

        return results;
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
                    DynamoDBClientTypes.PutRequest(item: delegate.getItemAttributes(model))
                ));
            }

            let result: BatchWriteItemOutputResponse = try await dynamoDbClient.batchWriteItem(input:
                BatchWriteItemInput(requestItems: [delegate.getTableName(): items])
            );

            if let itemCollectionMetrics = result.itemCollectionMetrics?[delegate.getTableName()] {
                for itemCollection in itemCollectionMetrics {
                    if
                        let itemCollectionKey = itemCollection.itemCollectionKey,
                        let resource = delegate.getResource(itemCollectionKey)
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
                BatchWriteItemInput(requestItems: [delegate.getTableName(): items])
            );
        }
    }
}