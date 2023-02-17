import JazzCodec;
import JazzCore;
import JazzConfiguration;

public final class DynamoDBRepositoryInitializer: Initializer {

    public required init() {}

    public override final func initialize(for app: App, with configurationBuilder: ConfigurationBuilder) throws {
        _ = configurationBuilder
            .with(file: "dynamodbconfig.json", for: DynamoDBRepositoryConfigV1JsonCodec.supportedMediaType)
            .with(decoder: DynamoDBRepositoryConfigV1JsonCodec());
    }
}