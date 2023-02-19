import JazzDataAccess;

import AWSDynamoDB;

public final class DynamoDBQuery<TResource: Storable>: Query<TResource> {
    public var input: ScanInput;

    internal init(tableName: String) {
        input = ScanInput();

        input.tableName = tableName;

        super.init();
    }
}