import JazzDataAccess;

public final class IdsQueryCriterionHandler<TResource: Storable>: BaseCriterionHandler<TResource, DynamoDBQuery<TResource>, IdsQueryCriterion> {
    public override init() {
        super.init();
    }

    public override final func process(for query: DynamoDBQuery<TResource>, with criterion: IdsQueryCriterion) {
        if query.query.filterExpression == nil {
            query.query.filterExpression = "";
        }
    }
}