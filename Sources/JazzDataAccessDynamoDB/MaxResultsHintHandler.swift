import JazzDataAccess;

public final class MaxResultsHintHandler<TResource: Storable>: BaseHintHandler<TResource, DynamoDBQuery<TResource>, MaxResultsHint> {
    public override init() {
        super.init();
    }

    public override final func process(for query: DynamoDBQuery<TResource>, with hint: MaxResultsHint) {
        query.query.limit = hint.getCount();
    }
}