
import Foundation
import FMDB
import FMDBMigrationManager

class SQLiteTableStore {

    var database : FMDatabase?
    var sqliteDatabaseConnection : SQLiteDatabaseConnection?
    var tableName : String?

    init(tableName: String) {

        self.tableName = tableName
        self.sqliteDatabaseConnection = SQLiteDatabaseConnection()
        self.sqliteDatabaseConnection!.openOrCreateDatabase()
    }

    func insertRow(_ argsDictionary: [AnyHashable: Any]) {
        let query: InsertQuery = QueryStringBuilder().insertQueryForTable(self.tableName!, args: argsDictionary)
        self.sqliteDatabaseConnection!.executeUpdate(query.query!, args: query.valueArguments!)
    }


    func readAllRowsWithArgs(_ argsDictionary: [AnyHashable: Any]) -> [AnyObject] {
        let queryString: String = QueryStringBuilder().selectStatementForTable(self.tableName!, whereClause:  argsDictionary)
        return self.sqliteDatabaseConnection!.executeQuery(queryString)
    }

    func readAllRows() -> [AnyObject] {
        let queryString: String = QueryStringBuilder().selectStatementForTable(self.tableName!)
        return self.sqliteDatabaseConnection!.executeQuery(queryString)
    }

    func deleteRowWithArgs(_ argsDictionary: [AnyHashable: Any]) {
        let queryString: String = QueryStringBuilder().deleteStatementForTable(self.tableName!, whereClause: argsDictionary)
        self.sqliteDatabaseConnection!.executeUpdate(queryString)
    }

    func deleteAllRows() {
        let queryString: String = QueryStringBuilder().deleteStatementForTable(self.tableName!)
        self.sqliteDatabaseConnection!.executeUpdate(queryString)
    }


}
