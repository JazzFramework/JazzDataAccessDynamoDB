import JazzCodec;

internal final class DynamoDBRepositoryConfigV1JsonCodec: JsonCodec<DynamoDBRepositoryConfig> {
    internal static let supportedMediaType: MediaType =
        MediaType(
            withType: "application",
            withSubtype: "json",
            withParameters: [
                "structure": "dynamodb.config",
                "version": "1"
            ]
        );

    public final override func getSupportedMediaType() -> MediaType {
        return DynamoDBRepositoryConfigV1JsonCodec.supportedMediaType;
    }

    public final override func encodeJson(data: DynamoDBRepositoryConfig) async -> JsonObject {
        return JsonObjectBuilder().build();
    }
    public final override func decodeJson(data: JsonObject) async -> DynamoDBRepositoryConfig? {
        let accessKey: JsonProperty = data["accessKey"] as? JsonProperty ?? JsonProperty.Empty;
        let secret: JsonProperty = data["secret"] as? JsonProperty ?? JsonProperty.Empty;
        let endpoint: JsonProperty = data["endpoint"] as? JsonProperty ?? JsonProperty.Empty;
        let region: JsonProperty = data["region"] as? JsonProperty ?? JsonProperty.Empty;
        let signingRegion: JsonProperty = data["sigingRegion"] as? JsonProperty ?? JsonProperty.Empty;
        let useFIPS: JsonProperty = data["useFIPS"] as? JsonProperty ?? JsonProperty.Empty;
        let useDualStack: JsonProperty = data["useDualStack"] as? JsonProperty ?? JsonProperty.Empty;

        return DynamoDBRepositoryConfig(
            accessKey: accessKey.getString(),
            secret: secret.getString(),
            endpoint: endpoint.getString(),
            region: region.getString(),
            signingRegion: signingRegion.getString(),
            useFIPS: useFIPS.getBool() ?? false,
            useDualStack: useDualStack.getBool() ?? false
        );
    }
}