
import Foundation
import UIKit
import SwiftyJSON

class TopicDetailsStorage {

    var sqliteStore : SQLiteTableStore?

    init(sqliteStore: SQLiteTableStore) {
        self.sqliteStore = sqliteStore
    }

    func fetchAllTopicsDetailsForTopic(_ topic : Topic) -> [TopicDetail] {

        var allTopicsArray: [NSDictionary] = self.sqliteStore!.readAllRowsWithArgs(["topic": topic.title!]) as! [NSDictionary]
        var topics: [TopicDetail] = [TopicDetail]()
        let count = allTopicsArray.count
        if (count) > 0 {

            for i in 0...count-1 {
                let topicDictionary : NSDictionary = allTopicsArray[i]
                let english: String = topicDictionary.value(forKey: "english") as! String
                let sanskrit: String = topicDictionary.value(forKey: "sanskrit") as! String
                let translit: String = topicDictionary.value(forKey: "translit") as! String
                let topicDetail = TopicDetail(topic: topic, english: english, sanskrit: sanskrit, translit: translit)
                topics.append(topicDetail)
            }
        }

        return topics

    }

    func storeTopicDetails(_ topics: [TopicDetail]){
        for topic: TopicDetail in topics {
            let topicDataDictionary: [String : String] = self.dictionaryWithTopicDetail(topic)
            self.sqliteStore!.insertRow(topicDataDictionary)
        }
    }

    func removeAllTopicDetailsForTopic(_ topic : Topic) {
        let topics: [TopicDetail] = self.fetchAllTopicsDetailsForTopic(topic)
        for _: TopicDetail in topics {
            self.sqliteStore!.deleteRowWithArgs(["topic": topic.title!])
        }
    }

    fileprivate func dictionaryWithTopicDetail(_ topicDetail: TopicDetail) -> [String : String] {
        return ["english": topicDetail.english!, "sanskrit": topicDetail.sanskrit!, "translit": topicDetail.translit!,"topic": (topicDetail.topic?.title!)!]
    }
}
