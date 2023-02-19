import AWSDynamoDB;

import JazzDataAccess;

open class DynamoDBRepositoryDelegate<TResource: Storable> {
    public init() {}

    open func getTableName() -> String { return ""; }

    open func getItemAttributes(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValue] { return [:]; }

    open func getResource(_ item: [String: DynamoDBClientTypes.AttributeValue]) -> TResource? { return nil; }

    public final func getValue(key: String, _ item: [String: DynamoDBClientTypes.AttributeValue], _ defaultValue: String = "") -> String {
        switch item[key] {
            case let .s(s):
                return s;
            default:
                return defaultValue;
        }
    }
}