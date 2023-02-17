import JazzDataAccess;

public final class DynamoDBQuery<TResource: Storable>: Query<TResource> {
    internal override init() {
        super.init();
    }
}