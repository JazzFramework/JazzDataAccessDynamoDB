import AWSDynamoDB;

import JazzDataAccess;

open class DynamoDBRepositoryDelegate<TResource: Storable> {
    private final let criterionProcessor: CriterionProcessor<TResource>;
    private final let hintProcessor: HintProcessor<TResource>;

    public init(criterionProcessor: CriterionProcessor<TResource>, hintProcessor: HintProcessor<TResource>) {        
        self.criterionProcessor = criterionProcessor;
        self.hintProcessor = hintProcessor;
    }

    open func getCriterionProcessor() -> CriterionProcessor<TResource> {
        return criterionProcessor;
    }

    open func getHintProcessor() -> HintProcessor<TResource> {
        return hintProcessor;
    }

    open func getTableName() -> String {
        return "";
    }

/*
        return [
            "id": DynamoDBClientTypes.AttributeValue.s("keyVal"),
            "key": DynamoDBClientTypes.AttributeValue.s("keyVal"),
            "songTitle": DynamoDBClientTypes.AttributeValue.s("titleOfSong"),
            "albumTitle": DynamoDBClientTypes.AttributeValue.s("titleOfAlbum"),
            "awards": DynamoDBClientTypes.AttributeValue.s("awardVal")
        ];
*/
    open func getItemAttributes(_ model: TResource) -> [String: DynamoDBClientTypes.AttributeValue] {
        return [:];
    }

    open func getResource(_ item: [String: DynamoDBClientTypes.AttributeValue]) -> TResource? {
        return nil;
    }
}