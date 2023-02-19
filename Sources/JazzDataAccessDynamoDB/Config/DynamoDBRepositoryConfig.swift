/**
 A class that'll hold configuration information for a dynamodb repository.
 */
internal final class DynamoDBRepositoryConfig {
    internal final let accessKey: String;
    internal final let secret: String;
    internal final let endpoint: String;
    internal final let region: String;
    internal final let signingRegion: String;
    internal final let useFIPS: Bool;
    internal final let useDualStack: Bool;

    /**
    Constructor.

     - Parameter accessKey: 
     - Parameter secret: 
     - Parameter endpoint: 
     - Parameter region: 
     - Parameter signingRegion: 
     - Parameter useFIPS: 
     - Parameter useDualStack: 
     */
    internal init(
        accessKey: String,
        secret: String,
        endpoint: String,
        region: String,
        signingRegion: String,
        useFIPS: Bool,
        useDualStack: Bool
    ) {
        self.accessKey = accessKey;
        self.secret = secret;
        self.endpoint = endpoint;
        self.region = region;
        self.signingRegion = signingRegion;
        self.useFIPS = useFIPS;
        self.useDualStack = useDualStack;
    }
}