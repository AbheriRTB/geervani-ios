//
//  SubhashitaStorage.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 09/12/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

class SubhashitaStorage {
    
    var sqliteStore : SQLiteTableStore?
    
    init(sqliteStore: SQLiteTableStore) {
        self.sqliteStore = sqliteStore
    }
    
    func fetchAllSubhashitas() -> [Subhashita] {
        var allSubhashitaArray: [NSDictionary] = self.sqliteStore!.readAllRows() as! [NSDictionary]
        var subhashitas: [Subhashita] = [Subhashita]()
        let count = allSubhashitaArray.count
        if (count) > 0 {
            for i in 0...count-1 {
                let subhashitaDictionary : NSDictionary = allSubhashitaArray[i]
                let sanskrit_text: String = subhashitaDictionary.value(forKey: "sanskrit_text") as! String
                let english_meaning: String = subhashitaDictionary.value(forKey: "english_meaning") as! String
                let subhashita = Subhashita(sanskrit_text: sanskrit_text, english_meaning: english_meaning)
                subhashitas.append(subhashita)
            }
        }
        return subhashitas
        
    }
    
    func storeSubhashitas(_ subhashitas: [Subhashita]){
        for subhashita: Subhashita in subhashitas {
            let subhashitaDataDictionary: [String : String] = self.dictionaryWithSubhashita(subhashita)
            self.sqliteStore!.insertRow(subhashitaDataDictionary)
        }
    }
    
    func removeAllSubhashitas() {
        let subhashitas: [Subhashita] = self.fetchAllSubhashitas()
        for subhashita: Subhashita in subhashitas {
            self.sqliteStore!.deleteRowWithArgs(dictionaryWithSubhashita(subhashita))
        }
    }
    
    fileprivate func dictionaryWithSubhashita(_ subhashita: Subhashita) -> [String : String] {
        return ["sanskrit_text": subhashita.sanskrit_text!, "english_meaning": subhashita.english_meaning!]
    }
}

