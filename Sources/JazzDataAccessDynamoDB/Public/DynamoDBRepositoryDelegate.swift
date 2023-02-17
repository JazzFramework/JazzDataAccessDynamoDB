import AWSDynamoDB;

import JazzDataAccess;

open class DynamoDBRepositoryDelegate<TResource: Storable> {
    public init() {}

    open func getTableName() -> String { return ""; }

    open func getItemAttributes(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValue] { return [:]; }

    open func getResource(_ item: [String: DynamoDBClientTypes.AttributeValue]) -> TResource? { return nil; }
}