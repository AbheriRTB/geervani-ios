//
//  WordRepository.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 27/06/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import KSDeferred

protocol WordRepositoryObserver {
    func wordRepository(_ wordRepository: WordRepository, cachedWords: [Word])
    func wordRepository(_ wordRepository: WordRepository, cachedWords: [Word], letter:String)
}

class WordRepository {
    
    var observer: WordRepositoryObserver?
    let sqliteTableStore : SQLiteTableStore?
    let wordStorage : WordStorage?
    
    init(){
        self.sqliteTableStore = SQLiteTableStore(tableName: "Word")
        self.wordStorage = WordStorage(sqliteStore:self.sqliteTableStore!)
    }
    
    func addObserver(_ observer: WordRepositoryObserver) {
        self.observer = observer
    }
    
    
    func fetchWords() -> KSPromise<AnyObject>  {
        
        let deferred = KSDeferred<AnyObject>()
        let requestPromise = self.fetchAllWordInfo()
        requestPromise.then({ (response) -> AnyObject? in
            let words = WordDeserializer().deserializeWordsFromContents(response as! NSString)
            let wordStorage = WordStorage(sqliteStore: self.sqliteTableStore!)
            wordStorage.removeAllWord()
            wordStorage.storeWords(words)
            let cachedWords = wordStorage.fetchAllWords()
            self.notifyObserver()
            deferred.resolve(withValue: cachedWords as AnyObject)
            return nil
        }) { (error) -> AnyObject? in
            deferred.rejectWithError(error)
            return nil
        }
        
        
        return deferred.promise
    }
    
    func fetchAllWordInfo() -> KSPromise<AnyObject>  {
        let deferred = KSDeferred<AnyObject>()
        
        let wordFiles = [   "LetterA", "LetterB", "LetterC", "LetterD", "LetterE",
                            "LetterF", "LetterG", "LetterH", "LetterI", "LetterJ",
                            "LetterK", "LetterL", "LetterM", "LetterN", "LetterO",
                            "LetterP", "LetterQ", "LetterR", "LetterS", "LetterT",
                            "LetterU", "LetterV", "LetterW", "LetterX", "LetterY",
                            "LetterZ"]
        
        var array = [KSPromise<AnyObject>]();
        for i in 0...wordFiles.count-1 {
            
            let url = "http://abheri.pythonanywhere.com/static/geervani/datafiles/dictionary/" + wordFiles[i] + ".txt"
            let requestPromise = self.fetchWordDetailsFromURL(url);
            print(url)
            array.append(requestPromise)
            
        }
        
        //Use when to wait for all the promises (A-Z) to fulfill
        
        let joinedPromise = KSPromise<AnyObject>.when(array)
        joinedPromise.then({ (response) -> AnyObject? in
            var alldata:String=""
            let responseData = response as! [String]
            for i in 0...responseData.count-1{
                alldata = alldata + responseData[i]
                print(responseData[i])
            }
            deferred.resolve(withValue: alldata as AnyObject)
            return nil
        }) { (error) -> AnyObject? in
            deferred.rejectWithError(error)
            return nil
        }
        return deferred.promise
    }
    
    func fetchWordDetailsFromURL(_ url:String) -> KSPromise<AnyObject> {
        let deferred = KSDeferred<AnyObject>()
        
        let requestPromise = URLSessionClient().requestWithURL(url)
        requestPromise.then({ (response) -> AnyObject? in
            let dataString = String(data: response as! Data, encoding: String.Encoding.utf8)
            //self.notifyObserver(letter: url)
            deferred.resolve(withValue: dataString as AnyObject)
            return nil
        }) { (error) -> AnyObject? in
            deferred.rejectWithError(error)
            return nil
        }
        return deferred.promise
        
    }
    
    func fetchFilteredWords(_ searchString:String)->[Word]{
        let wordStorage = WordStorage(sqliteStore: self.sqliteTableStore!)
        let cachedWords = wordStorage.fetchFilteredWords(searchString)
        return cachedWords
    }
    
    func fetchAllWords()->[Word]{
        let wordStorage = WordStorage(sqliteStore: self.sqliteTableStore!)
        let cachedWords = wordStorage.fetchAllWords()
        return cachedWords
    }
    
    fileprivate func notifyObserver() {
        let cachedWords = self.wordStorage!.fetchAllWords()
        observer!.wordRepository(self, cachedWords:cachedWords)
    }
    fileprivate func notifyObserver(letter:String) {
        let cachedWords = self.wordStorage!.fetchAllWords()
        observer!.wordRepository(self, cachedWords:cachedWords, letter:letter)
    }
}
