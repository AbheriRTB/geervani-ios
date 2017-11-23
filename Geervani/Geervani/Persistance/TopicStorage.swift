

import Foundation
import UIKit
import SwiftyJSON

class TopicStorage {

    var sqliteStore : SQLiteTableStore?

    init(sqliteStore: SQLiteTableStore) {
        self.sqliteStore = sqliteStore
    }

    func fetchAllTopics() -> [Topic] {
        var allTopicsArray: [NSDictionary] = self.sqliteStore!.readAllRows() as! [NSDictionary]
        var topics: [Topic] = [Topic]()
        let count = allTopicsArray.count
        if (count) > 0 {
            for i in 0...count-1 {
                let topicDictionary : NSDictionary = allTopicsArray[i]
                let name: String = topicDictionary.value(forKey: "title") as! String
                let uri: String = topicDictionary.value(forKey: "fileName") as! String
                let breakType = Topic(title: name, fileName: uri)
                topics.append(breakType)
            }
        } 
        return topics

    }

    func storeTopics(_ topics: [Topic]){
        for topic: Topic in topics {
            let topicDataDictionary: [String : String] = self.dictionaryWithTopic(topic)
            self.sqliteStore!.insertRow(topicDataDictionary)
        }
    }

    func removeAllTopics() {
        let topics: [Topic] = self.fetchAllTopics()
        for topic: Topic in topics {
            self.sqliteStore!.deleteRowWithArgs(dictionaryWithTopic(topic))
        }
    }

    fileprivate func dictionaryWithTopic(_ topic: Topic) -> [String : String] {
        return ["title": topic.title!, "fileName": topic.fileName!]
    }
}

