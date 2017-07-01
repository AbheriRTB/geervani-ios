
import Foundation

class TopicDetail : NSObject, NSCopying{

    var english:String?
    var sanskrit:String?
    var translit:String?

    var topic: Topic?

    init(topic: Topic, english: String,sanskrit: String,translit: String) {
        self.topic = topic
        self.english = english
        self.sanskrit = sanskrit
        self.translit = translit

    }

    override func copy() -> Any {
        return self.copy(with: nil)
    }

    func copy(with zone: NSZone?) -> Any {
        let englishCopy: String = self.english!.copy() as! String
        let sanskritCopy: String = self.sanskrit!.copy() as! String
        let topicCopy: Topic = self.topic!.copy() as! Topic
        let translitCopy: String = self.translit!.copy() as! String
        return TopicDetail(topic: topicCopy, english: englishCopy,sanskrit: sanskritCopy,translit:translitCopy)
    }

    override  var description: String {
        return "<TopicDetail>: \n topic: \(self.topic!.title), \n english: \(self.english), \n sanskrit: \(self.sanskrit),\n translit: \(self.translit)"
    }
}

