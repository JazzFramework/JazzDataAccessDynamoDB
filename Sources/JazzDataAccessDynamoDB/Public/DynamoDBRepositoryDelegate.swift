import Foundation;

import AWSDynamoDB;

import JazzDataAccess;

open class DynamoDBRepositoryDelegate<TResource: Storable> {
    public init() {}

    open func getTableName() -> String { return ""; }

    open func toDynamo(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValue] { return [:]; }

    open func fromDynamo(_ item: [String: DynamoDBClientTypes.AttributeValue]) -> TResource? { return nil; }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: Data = Data()
    ) -> Data {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: [Data] = []
    ) -> [Data] {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: String = ""
    ) -> String {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: [String] = []
    ) -> [String] {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: Bool = false
    ) -> Bool {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: Double = 0
    ) -> Double {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: [Double] = []
    ) -> [Double] {
        if let item = item[key] {
            return getValue(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getList(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: [DynamoDBClientTypes.AttributeValue] = []
    ) -> [DynamoDBClientTypes.AttributeValue] {
        if let item = item[key] {
            return getList(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getMap(
        key: String,
        _ item: [String: DynamoDBClientTypes.AttributeValue],
        _ defaultValue: [String: DynamoDBClientTypes.AttributeValue] = [:]
    ) -> [String: DynamoDBClientTypes.AttributeValue] {
        if let item = item[key] {
            return getMap(item, defaultValue);
        }

        return defaultValue;
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: Data = Data()
    ) -> Data {
        switch item {
            case let .b(b):
                return b;
            default:
                return defaultValue;
        }
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: [Data] = []
    ) -> [Data] {
        switch item {
            case let .bs(bs):
                return bs;
            default:
                return defaultValue;
        }
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: String = ""
    ) -> String {
        switch item {
            case let .s(s):
                return s;
            default:
                return defaultValue;
        }
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: [String] = []
    ) -> [String] {
        switch item {
            case let .ss(ss):
                return ss;
            default:
                return defaultValue;
        }
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: Bool = false
    ) -> Bool {
        switch item {
            case let .bool(bool):
                return bool;
            default:
                return defaultValue;
        }
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: Double = 0
    ) -> Double {
        switch item {
            case let .n(n):
                return Double(n) ?? defaultValue;
            default:
                return defaultValue;
        }
    }

    public final func getValue(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: [Double] = []
    ) -> [Double] {
        switch item {
            case let .ns(ns):
                return ns.compactMap(Double.init);
            default:
                return defaultValue;
        }
    }

    public final func getList(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: [DynamoDBClientTypes.AttributeValue] = []
    ) -> [DynamoDBClientTypes.AttributeValue] {
        switch item {
            case let .l(list):
                return list;
            default:
                return defaultValue;
        }
    }

    public final func getMap(
        _ item: DynamoDBClientTypes.AttributeValue,
        _ defaultValue: [String: DynamoDBClientTypes.AttributeValue] = [:]
    ) -> [String: DynamoDBClientTypes.AttributeValue] {
        switch item {
            case let .m(map):
                return map;
            default:
                return defaultValue;
        }
    }
}