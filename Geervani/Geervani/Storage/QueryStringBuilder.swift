

import Foundation


class QueryStringBuilder {

    var dateFormatter = DateFormatter()
    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeZone = TimeZone.init(secondsFromGMT:0)
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }

    // MARK: - INSERT
    func insertStatementForTable(_ tableName: String, args argsDictionary: [String:AnyObject]) -> String {
        var keys: [String] = [String]()
        var values: [String] = [String]()

        for (key, _) in argsDictionary {

            keys.append(key)
            let object: AnyObject = argsDictionary[key]!
            if (object is NSString) {
                values.append("'\(object)'")
            }
            else if (object is Date) {
                let dateString: String = "'\(self.dateFormatter.string(from: object as! Date))'"
                values.append(dateString)
            }
            else if (object is Data) {
                values.append(object as! String)
            }
            else {
                values.append(object.description)
            }

        }

        let columnsList : String = keys.joined(separator: ",")
        let valuesList : String = values.joined(separator: ",")
        return "INSERT INTO \(tableName) \(columnsList) VALUES \(valuesList)"
    }

    func insertQueryForTable(_ tableName: String, args argsDictionary: [AnyHashable: Any]) -> InsertQuery {
        var keys: [String] = [String]()
        var values: [String] = [String]()
        var positions: [String] = [String]()
        for (key, _) in argsDictionary  {
            keys.append(key as! String)
            positions.append("?")
            let object: AnyObject = argsDictionary[key]! as AnyObject
            if (object is NSString) {
                values.append(object as! String)
            }
            else if (object is Date) {
                let dateString: String = "\(self.dateFormatter.string(from: object as! Date))"
                values.append(dateString)
            }
            else if (object is Data) {
                values.append(object as! String)
            }
            else {
                values.append(object.description)
            }
        }


        let columnsList : String = keys.joined(separator: ", ")
        let positionsList : String = positions.joined(separator: ", ")
        let query: String = "insert into \(tableName) (\(columnsList)) values (\(positionsList))"
        let insertQuery = InsertQuery(valueArguments: values as [AnyObject], query: query)
        return insertQuery
    }

    // MARK: - SELECT

    func selectStatementForTable(_ tableName: String, whereClause: [AnyHashable: Any]) -> String {
        let whereString: String = self.whereClauseWithDictionary(whereClause)
        return "SELECT * FROM \(tableName) WHERE \(whereString)"
    }

    func selectStatementForTable(_ tableName: String) -> String {
        return "SELECT * FROM \(tableName)"
    }

    // MARK: - DELETE

    func deleteStatementForTable(_ tableName:String, whereClause:[AnyHashable: Any]) -> String {
        let whereString: String = self.whereClauseWithDictionary(whereClause)
        return "DELETE FROM \(tableName) WHERE \(whereString)"
    }

    func deleteStatementForTable(_ tableName: String) -> String {
        return "DELETE FROM \(tableName)"
    }

    // MARK: - PRIVATE

    fileprivate func whereClauseWithDictionary(_ whereClause: [AnyHashable: Any]) -> String {
        var whereClauseComponents: [String] = [String]()
        for (key, _) in whereClause {
            var valueString: String
            let value: AnyObject = whereClause[key]! as AnyObject
            if (whereClause[key] is NSString) {
                valueString = "'\(value)'"
            }
            else if (whereClause[key] is NSDate) {
                let dateString: String = "'\(self.dateFormatter.string(from: value as! Date))'"
                valueString = dateString
            }
            else {
                valueString = ((whereClause[key] as AnyObject).description)!
            }

            if(valueString.contains("%")){
                whereClauseComponents.append("\(key) like \(valueString)")

            }else{
                whereClauseComponents.append("\(key) = \(valueString)")
            }
        }
        whereClauseComponents.sort(){$0 < $1}
        let whereClauseString : String = whereClauseComponents.joined(separator: " AND ")
        return whereClauseString
    }
}


