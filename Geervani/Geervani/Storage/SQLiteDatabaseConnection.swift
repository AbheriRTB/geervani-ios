

import Foundation
import FMDB
import FMDBMigrationManager

class SQLiteDatabaseConnection {

    var database : FMDatabase?
    func openOrCreateDatabase() {
        let documentsDirectory: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseNames: String = "geervani.sqlite"
        let databasePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(databaseNames).absoluteString
        self.database = FMDatabase(path: databasePath)

        let migrationManager: FMDBMigrationManager = FMDBMigrationManager(databaseAtPath: databasePath, migrationsBundle: Bundle.main)
        if migrationManager.needsMigration {
            try! migrationManager.createMigrationsTable()
            try! migrationManager.migrateDatabase(toVersion: UINT64_MAX, progress: nil)
        }
        self.database!.open()
    }

    func executeUpdate(_ updateQuery: String) {
        self.database?.executeUpdate(updateQuery, withArgumentsIn: nil)
    }
    func executeUpdate(_ updateQuery: String, args: [AnyObject]) {
        self.database!.executeUpdate(updateQuery, withArgumentsIn: args)
    }

    func executeQuery(_ updateQuery: String) -> [AnyObject] {
        let resultSet: FMResultSet = self.database!.executeQuery(updateQuery,withArgumentsIn:nil)
        var results: [AnyObject] = [AnyObject]()
        while resultSet.next() {
            results.append(resultSet.resultDictionary() as AnyObject)
        }
        return results
    }
}
