import JazzDataAccess;

import AWSDynamoDB;

public final class DynamoDBQuery<TResource: Storable>: Query<TResource> {
    public var input: QueryInput;

    internal override init() {
        input = QueryInput();

        super.init();
    }
}