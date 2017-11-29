
import Foundation
import UIKit
import KSDeferred

protocol TopicDetailsRepositoryObserver {
    func topicDetailsRepository(_ topicDetailsRepository: TopicDetailsRepository, cachedTopicDetails: [TopicDetail])
}

class TopicDetailsRepository {
    
    var observer: TopicDetailsRepositoryObserver?
    let sqliteTableStore : SQLiteTableStore?
    let topicStorage : TopicDetailsStorage?
    
    init(){
        self.sqliteTableStore = SQLiteTableStore(tableName: "TopicDetails")
        self.topicStorage = TopicDetailsStorage(sqliteStore:self.sqliteTableStore!)
    }
    
    func addObserver(_ observer: TopicDetailsRepositoryObserver) {
        self.observer = observer
    }
    
    func fetchDetailsForTopics(_ topic : Topic) -> KSPromise<AnyObject>  {
        let deferred = KSDeferred<AnyObject>()
        //self.notifyObserver(topic)
        let url = "http://abheri.pythonanywhere.com/static/geervani/datafiles/topics/" + topic.fileName!
        let requestPromise = URLSessionClient().requestWithURL(url)
        requestPromise.then({ (response) -> AnyObject? in
            let dataString = String(data: response as! Data, encoding: String.Encoding.utf8)
            let topicDetails = TopicDetailsDeserializer().deserializeTopicDetailsFromContents(topic,contents: dataString! as NSString)
            let topicStorage = TopicDetailsStorage(sqliteStore: self.sqliteTableStore!)
            topicStorage.removeAllTopicDetailsForTopic(topic)
            topicStorage.storeTopicDetails(topicDetails)
            let cachedTopics = topicStorage.fetchAllTopicsDetailsForTopic(topic)
            self.notifyObserver(topic)
            deferred.resolve(withValue: cachedTopics as AnyObject)
            return nil
        }) { (error) -> AnyObject? in
            deferred.rejectWithError(error)
            return nil
        }
        return deferred.promise
    }
    
    func fetchAllTopicsDetailsForTopic(topic:Topic)->[TopicDetail]{
        let cachedTopics = self.topicStorage!.fetchAllTopicsDetailsForTopic(topic)
        return cachedTopics
    }
    
    fileprivate func notifyObserver(_ topic : Topic) {
        let cachedTopics = self.topicStorage!.fetchAllTopicsDetailsForTopic(topic)
        observer!.topicDetailsRepository(self, cachedTopicDetails: cachedTopics)
    }
}
