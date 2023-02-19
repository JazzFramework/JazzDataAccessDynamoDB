import AWSClientRuntime;
import AWSDynamoDB;

import JazzConfiguration;
import JazzDataAccess;

public final class DynamoDBRepositoryBuilder<TResource: Storable> {
    private var configuration: Configuration?;
    private var delegate: DynamoDBRepositoryDelegate<TResource>?;
    private var criterionHandlers: [CriterionHandler<TResource>] = [
        IdQueryCriterionHandler<TResource>(),
        IdsQueryCriterionHandler<TResource>()
    ];
    private var hintHandlers: [HintHandler<TResource>] = [
        MaxResultsHintHandler<TResource>()
    ];

    public init() {}

    public final func with(configuration: Configuration) -> DynamoDBRepositoryBuilder<TResource> {
        self.configuration = configuration;

        return self;
    }

    public final func with(delegate: DynamoDBRepositoryDelegate<TResource>) -> DynamoDBRepositoryBuilder<TResource> {
        self.delegate = delegate;

        return self;
    }

    public final func with(criterionHandler: CriterionHandler<TResource>) -> DynamoDBRepositoryBuilder<TResource> {
        criterionHandlers.append(criterionHandler);

        return self;
    }

    public final func with(hintHandler: HintHandler<TResource>) -> DynamoDBRepositoryBuilder<TResource> {
        hintHandlers.append(hintHandler);

        return self;
    }

    public final func build() async throws -> Repository<TResource> {
        if let configuration = configuration, let delegate = delegate {
            guard let config: DynamoDBRepositoryConfig = await configuration.fetch() else {
                throw DynamoDBErrors.missingConfig;
            }

            var dynamoDBConfig: DynamoDBClientConfigurationProtocol = try await DynamoDBClient.DynamoDBClientConfiguration();

            dynamoDBConfig.region = config.region;
            dynamoDBConfig.signingRegion = config.signingRegion;
            dynamoDBConfig.endpoint = config.endpoint;
            dynamoDBConfig.useFIPS = config.useFIPS;
            dynamoDBConfig.useDualStack = config.useDualStack;
            dynamoDBConfig.credentialsProvider = try AWSCredentialsProvider.fromStatic(
                AWSCredentialsProviderStaticConfig(
                    accessKey: config.accessKey,
                    secret: config.secret
                )
            );

            return try await DynamoDBRepository<TResource>(
                client: DynamoDBClient(config: dynamoDBConfig),
                delegate: delegate,
                criterionProcessor: CriterionProcessorImpl<TResource>(criterionHandlers: criterionHandlers),
                hintProcessor: HintProcessorImpl<TResource>(hintHandlers: hintHandlers)
            );
        }

        throw DynamoDBErrors.missingDependancy;
    }
}