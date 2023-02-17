import JazzDataAccess;

internal final class IdQueryCriterionHandler<TResource: Storable>: BaseCriterionHandler<TResource, DynamoDBQuery<TResource>, IdQueryCriterion> {
    internal override init() {
        super.init();
    }

    public override final func process(for query: DynamoDBQuery<TResource>, with criterion: IdQueryCriterion) {
        if query.input.filterExpression == nil {
            query.input.filterExpression = "";
        }
    }
}