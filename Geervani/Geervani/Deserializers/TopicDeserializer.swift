
import Foundation
import UIKit
import PromiseKit
import SwiftyJSON

class TopicDeserializer {

    func deserializeFromData(_ data: Data) -> [Topic]  {

        var allTopics: [Topic] = [Topic]()
        let specsBundle: Bundle = Bundle.main
        let path: String = specsBundle.path(forResource: "AllTopics", ofType: "json")!
        //let jsonData: Data = try! Data.init(contentsOf: URL(fileURLWithPath: path))
        let jsonData: Data = data
        let topics = JSON(data: jsonData as Data).array
        let count = topics!.count
        for i in 0...count-1 {
            let topic  = topics![i].dictionary
            let title = topic!["title"]!.stringValue
            let filename = topic!["filename"]!.stringValue
            let topicObject = Topic(title: title, fileName: filename)
            allTopics.append(topicObject)
        }
        return NSArray(array:allTopics, copyItems: true) as! [Topic]
    }

}
