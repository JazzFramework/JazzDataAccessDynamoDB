import JazzCodec;

internal class DynamoDBRepositoryConfigV1JsonCodec: JsonCodec<DynamoDBRepositoryConfig> {
    internal static let supportedMediaType: MediaType =
        MediaType(
            withType: "application",
            withSubtype: "json",
            withParameters: [
                "structure": "dynamodb.config",
                "version": "1"
            ]
        );

    public override func getSupportedMediaType() -> MediaType {
        return DynamoDBRepositoryConfigV1JsonCodec.supportedMediaType;
    }

    public override func encodeJson(data: DynamoDBRepositoryConfig) async -> JsonObject {
        return JsonObjectBuilder().build();
    }

    public override func decodeJson(data: JsonObject) async -> DynamoDBRepositoryConfig? {
        let accessKey: JsonProperty = data["accessKey"] as? JsonProperty ?? JsonProperty.Empty;
        let secret: JsonProperty = data["secret"] as? JsonProperty ?? JsonProperty.Empty;
        let endpoint: JsonProperty = data["endpoint"] as? JsonProperty ?? JsonProperty.Empty;

        return DynamoDBRepositoryConfig(
            accessKey: accessKey.getString(),
            secret: secret.getString(),
            endpoint: endpoint.getString()
        );
    }
}