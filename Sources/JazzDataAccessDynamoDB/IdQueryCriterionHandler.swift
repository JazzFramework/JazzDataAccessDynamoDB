import JazzDataAccess;

public final class IdQueryCriterionHandler<TResource: Storable>: BaseCriterionHandler<TResource, DynamoDBQuery<TResource>, IdQueryCriterion> {
    public override init() {
        super.init();
    }

    public override final func process(for query: DynamoDBQuery<TResource>, with criterion: IdQueryCriterion) {
        if query.query.filterExpression == nil {
            query.query.filterExpression = "";
        }
    }
}