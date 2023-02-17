import JazzDataAccess;

import AWSDynamoDB;

public final class DynamoDBQuery<TResource: Storable>: Query<TResource> {
    public var query: QueryInput;

    internal override init() {
        query = QueryInput();

        super.init();
    }

    internal final func toQuery() -> QueryInput {
        return query;
    }
}