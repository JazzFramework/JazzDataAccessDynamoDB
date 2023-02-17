import Foundation;

import AWSDynamoDB;
import ClientRuntime;
import AWSClientRuntime;

import JazzDataAccess;

internal extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)]);
        };
    }
}

//TODO: Delegate + Error Handling
public final class DynamoDBRepository<TResource: Storable>: Repository<TResource> {
    private final let criterionProcessor: CriterionProcessor<TResource>;
    private final let hintProcessor: HintProcessor<TResource>;

    private final let dynamoDbClient: DynamoDBClientProtocol;

    public init(criterionProcessor: CriterionProcessor<TResource>, hintProcessor: HintProcessor<TResource>) {        
        self.criterionProcessor = criterionProcessor;
        self.hintProcessor = hintProcessor;

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

    //TODO
    public final override func get(for criteria: [QueryCriterion], with hints: [QueryHint]) async throws -> [TResource] {
        let query: DynamoDBQuery<TResource> = getQuery();

        try criterionProcessor.handle(for: query, with: criteria);

        try hintProcessor.handle(for: query, with: hints);

        let result: QueryOutputResponse = try await dynamoDbClient.query(input: QueryInput());

        if let items = result.items {
            for item in items {
                var results: [TResource] = [];

                if let resource = getResource(item) {
                    results.append(resource);
                }

                return results;
            }
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

    //TODO: Delegate
    private final func getTableName() -> String {
        return "nameOfTable";
    }

    //TODO: Delegate
    private final func getItemAttributes(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValue] {
        return [
            "id": DynamoDBClientTypes.AttributeValue.s("keyVal"),
            "key": DynamoDBClientTypes.AttributeValue.s("keyVal"),
            "songTitle": DynamoDBClientTypes.AttributeValue.s("titleOfSong"),
            "albumTitle": DynamoDBClientTypes.AttributeValue.s("titleOfAlbum"),
            "awards": DynamoDBClientTypes.AttributeValue.s("awardVal")
        ];
    }

    //TODO: Delegate
    private final func getResource(_ item: [String: DynamoDBClientTypes.AttributeValue]) -> TResource? {
        return nil;
    }

    private func getQuery() ->  DynamoDBQuery<TResource> {
        return DynamoDBQuery<TResource>();
    }
}