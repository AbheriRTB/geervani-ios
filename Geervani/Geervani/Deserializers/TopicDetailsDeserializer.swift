
import Foundation
import Foundation
import UIKit
import PromiseKit
import SwiftyJSON

class TopicDetailsDeserializer {

    func deserializeTopicDetailsFromContents(_ topic: Topic ,contents:NSString)-> [TopicDetail]{

        var englishValue = ""
        var sanskritValue = ""
        var translitValue = ""
        var allTopicDetails = [TopicDetail]()
        let lines = contents.components(separatedBy: "\n")
        for line in lines{
            if !line.hasPrefix("//") && !line.isEmpty{
                let parts = line.components(separatedBy: ":")
                if line.contains("_en") && parts.count == 2{
                    englishValue = parts[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ",", with: "")
                    //englishValue = parts[1].replacing("\"", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
                }
                if line.contains("_sn") && parts.count == 2{
                    let subparts = parts[1].components(separatedBy: "<br>")
                    if subparts.count >= 2{
                        sanskritValue = subparts[0].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ",", with: "")
                        translitValue = subparts[1].replacingOccurrences(of: "\"", with: "")
                        
                        //sanskritValue = subparts[0].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
                        //translitValue = subparts[1].stringByReplacingOccurrencesOfString("\",", withString: "")
                    }

                    let topicDetail = TopicDetail(topic: topic, english: englishValue, sanskrit: sanskritValue,translit:translitValue )
                    allTopicDetails.append(topicDetail)
                    englishValue = ""
                    sanskritValue = ""
                    translitValue = ""

                }

            }

        }
        return allTopicDetails
    }
}


