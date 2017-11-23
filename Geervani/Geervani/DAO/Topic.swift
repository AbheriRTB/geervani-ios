import Foundation

class Topic : NSObject, NSCopying{
    
    var title:String?
    var fileName:String?
    
    init(title: String, fileName: String) {
        self.title = title
        self.fileName = fileName
    }
    
    override func copy() -> Any {
        return self.copy(with: nil)
    }
    
    func copy(with zone: NSZone?) -> Any {
        let nameCopy: String = self.title!.copy() as! String
        let uriCopy: String = self.fileName!.copy() as! String
        return Topic(title: nameCopy, fileName: uriCopy)
    }
    
    override  var description: String {
        return "<Topic>:\n name: \(self.title), \n uri: \(self.fileName)"
    }
}
