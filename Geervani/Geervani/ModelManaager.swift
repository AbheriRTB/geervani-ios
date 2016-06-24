//
//  ModelManaager.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 24/06/16.
//  Copyright © 2016 Abheri. All rights reserved.
//


import Foundation
import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath("Geervani.db"))
        }
        return sharedInstance
    }
    
    func addWordData(wordData: Word) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO word_table (englishword, sanskritword) VALUES (?, ?)", withArgumentsInArray: [wordData.wordEnglish, wordData.wordSamskrit])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateWordData(wordData: Word) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE word_table SET englishword=?, sanskritword=? WHERE englishword=?", withArgumentsInArray: [wordData.wordEnglish, wordData.wordSamskrit])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteWordData(wordData: Word) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM word_table WHERE englishword=?", withArgumentsInArray: [wordData.wordEnglish])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func deleteAllWordData() -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeStatements("DELETE FROM word_table")
        sharedInstance.database!.close()
        return isDeleted
    }

    
    func getAllWordData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM word_table order by englishword", withArgumentsInArray: nil)
        let allWordData : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let wordData : Word = Word()
                wordData.wordID = resultSet.intForColumn("_wid")
                wordData.wordEnglish = resultSet.stringForColumn("englishword")
                wordData.wordSamskrit = resultSet.stringForColumn("sanskritword")
                allWordData.addObject(wordData)
            }
        }
        sharedInstance.database!.close()
        return allWordData
    }
}

