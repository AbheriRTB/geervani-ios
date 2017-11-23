//
//  WordStorage.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 27/06/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WordStorage {
    
    var sqliteStore : SQLiteTableStore?
    
    init(sqliteStore: SQLiteTableStore) {
        self.sqliteStore = sqliteStore
    }
    
    func fetchAllWords() -> [Word] {
        
        var allWordsArray: [NSDictionary] = self.sqliteStore!.readAllRows() as! [NSDictionary]
        var words: [Word] = [Word]()
        let count = allWordsArray.count
        if (count) > 0 {
            
            for i in 0...count-1 {
                let wordDictionary : NSDictionary = allWordsArray[i]
                let english: String = wordDictionary.value(forKey: "englishword") as! String
                let sanskrit: String = wordDictionary.value(forKey: "sanskritword") as! String
                let word = Word(english: english, sanskrit: sanskrit)
                words.append(word)
            }
        }
        
        return words
        
    }
    
    func fetchFilteredWords(_ searchString:String) -> [Word] {
        
        var allWordsArray: [NSDictionary] = self.sqliteStore!.readAllRowsWithArgs(["englishword":searchString]) as! [NSDictionary]
        var words: [Word] = [Word]()
        let count = allWordsArray.count
        if (count) > 0 {
            
            for i in 0...count-1 {
                let wordDictionary : NSDictionary = allWordsArray[i]
                let english: String = wordDictionary.value(forKey: "englishword") as! String
                let sanskrit: String = wordDictionary.value(forKey: "sanskritword") as! String
                let word = Word(english: english, sanskrit: sanskrit)
                words.append(word)
            }
        }
        
        return words
        
    }

    
    func storeWords(_ words: [Word]){
        for word: Word in words {
            let wordDictionary: [String : String] = self.dictionaryWithWord(word)
            self.sqliteStore!.insertRow(wordDictionary)
        }
    }
    
    func removeAllWord() {
        self.sqliteStore!.deleteAllRows()
    }
    
    /*
    func removeAllWordForLetter(letter : String) {
        let topics: [Word] = self.fetchAllTopicsDetailsForTopic(topic)
        for _: Word in topics {
            self.sqliteStore!.deleteRowWithArgs(["topic": topic.title!])
        }
    }
*/
    
    fileprivate func dictionaryWithWord(_ word: Word) -> [String : String] {
        return ["englishword": word.english!, "sanskritword": word.sanskrit!]
    }
}
