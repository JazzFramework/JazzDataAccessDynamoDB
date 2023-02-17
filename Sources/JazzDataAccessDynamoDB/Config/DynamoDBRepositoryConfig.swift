internal final class DynamoDBRepositoryConfig {
    public final let region: String;
    public final let endpoint: String;

    internal init(region: String, endpoint: String) {
        self.region = region;
        self.endpoint = endpoint;
    }
}