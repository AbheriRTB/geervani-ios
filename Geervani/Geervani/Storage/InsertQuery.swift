
import Foundation

class InsertQuery {

    var query : String?
    var valueArguments : [AnyObject]?
    init(valueArguments: [AnyObject], query: String) {
        self.valueArguments = valueArguments
        self.query = query
    }
}