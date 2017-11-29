
import Foundation
import UIKit
import KSDeferred

protocol TopicsRepositoryObserver {
    func topicsRepository(_ punchRepository: TopicsRepository, cachedTopics: [Topic])
}

class TopicsRepository {
    
    var observer: TopicsRepositoryObserver?
    let sqliteTableStore : SQLiteTableStore?
    let topicStorage : TopicStorage?
    
    init(){
        self.sqliteTableStore = SQLiteTableStore(tableName: "Topics")
        self.topicStorage = TopicStorage(sqliteStore:self.sqliteTableStore!)
    }
    
    func addObserver(_ observer: TopicsRepositoryObserver) {
        self.observer = observer
    }
    
    func fetchAllTopics() -> KSPromise<AnyObject>  {
        
        //self.notifyObserver()
        
        let deferred = KSDeferred<AnyObject>()
        //let url = "http://www.learnswiftonline.com/Samples/subway.json"
        let url = "http://abheri.pythonanywhere.com/static/geervani/datafiles/topics/AllTopics.json"
        let requestPromise = URLSessionClient().requestWithURL(url)
        requestPromise.then({ (response) -> AnyObject? in
            print("Response=\(String(describing: response))")
            let allTopics = TopicDeserializer().deserializeFromData(response as! Data)
            let topicStorage = TopicStorage(sqliteStore: self.sqliteTableStore!)
            topicStorage.removeAllTopics()
            topicStorage.storeTopics(allTopics)
            let cachedTopics = topicStorage.fetchAllTopics()
            self.notifyObserver()
            deferred.resolve(withValue: NSArray(array:cachedTopics, copyItems: true) as AnyObject)
            return nil
        }) { (error) -> AnyObject? in
            deferred.rejectWithError(error)
            return nil
        }
        
        return deferred.promise
        
    }
    
    func fetchAllTopicsFromCache()->[Topic]{
        let cachedTopics = self.topicStorage!.fetchAllTopics()
        return cachedTopics
    }
    fileprivate func notifyObserver() {
        let cachedTopics = self.topicStorage!.fetchAllTopics()
        observer!.topicsRepository(self, cachedTopics: cachedTopics)
    }
}

