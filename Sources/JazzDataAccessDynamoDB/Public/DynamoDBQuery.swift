import JazzDataAccess;

import AWSDynamoDB;

public final class DynamoDBQuery<TResource: Storable>: Query<TResource> {
    private var expressionStatements: [String];
    private var filterStatements: [String];
    private var expressionValues: [String: String];

    internal init(tableName: String) {
        expressionStatements = [];
        filterStatements = [];
        expressionValues = [:];

        super.init();
    }

    public final func set(expression: String) {
        expressionStatements.append(expression);
    }

    public final func set(filter: String) {
        filterStatements.append(filter);
    }

    public final func set(expression: String, value: String) {
        expressionValues[expression] = value;
    }
}