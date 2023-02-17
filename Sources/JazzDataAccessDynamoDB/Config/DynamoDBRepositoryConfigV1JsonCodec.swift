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
        return JsonObjectBuilder()
            .with("region", property: JsonProperty(withData: data.region))
            .build();
    }

    public override func decodeJson(data: JsonObject) async -> DynamoDBRepositoryConfig? {
        let region: JsonProperty = data["region"] as? JsonProperty ?? JsonProperty.Empty;

        return DynamoDBRepositoryConfig(region: region.getString());
    }
}