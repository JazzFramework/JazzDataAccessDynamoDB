internal final class DynamoDBRepositoryConfig {
    public final let accessKey: String;
    public final let secret: String;
    public final let endpoint: String;

    internal init(accessKey: String, secret: String, endpoint: String) {
        self.accessKey = accessKey;
        self.secret = secret;
        self.endpoint = endpoint;
    }
}