import JazzDataAccess;

internal final class IdsQueryCriterionHandler<TResource: Storable>: BaseCriterionHandler<TResource, DynamoDBQuery<TResource>, IdsQueryCriterion> {
    internal override init() {
        super.init();
    }

    public override final func process(for query: DynamoDBQuery<TResource>, with criterion: IdsQueryCriterion) {
        if query.input.filterExpression == nil {
            query.input.filterExpression = "";
        }
    }
}