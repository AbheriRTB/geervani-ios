//
//  SubhashitaRepository.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 09/12/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import Foundation
import UIKit
import KSDeferred

protocol SubhashitaRepositoryObserver {
    func subhashitaRepository(_ subhashitaRepository: SubhashitaRepository, cachedSubhashita: [Subhashita])
}

class SubhashitaRepository {
    
    var observer: SubhashitaRepositoryObserver?
    let sqliteTableStore : SQLiteTableStore?
    let subhashitaStorage : SubhashitaStorage?
    
    init(){
        self.sqliteTableStore = SQLiteTableStore(tableName: "Subhashita")
        self.subhashitaStorage = SubhashitaStorage(sqliteStore:self.sqliteTableStore!)
    }
    
    func addObserver(_ observer: SubhashitaRepositoryObserver) {
        self.observer = observer
    }
    
    func fetchSubhashitas() -> KSPromise<AnyObject>  {
        
        //self.notifyObserver(subhashita)
        
        let deferred = KSDeferred<AnyObject>()
        let url = "http://abheri.pythonanywhere.com/static/geervani/datafiles/topics/subhashitani.txt"
        let requestPromise = URLSessionClient().requestWithURL(url)
        requestPromise.then({ (response) -> AnyObject? in
            let dataString = String(data: response as! Data, encoding: String.Encoding.utf8)
            let subhashitas = SubhashitaDeserializer().deserializeSubhashitaFromContents(dataString! as NSString)
            let subhashitaStorage = SubhashitaStorage(sqliteStore: self.sqliteTableStore!)
            subhashitaStorage.removeAllSubhashitas()
            subhashitaStorage.storeSubhashitas(subhashitas)
            let cachedSubhashitas = subhashitaStorage.fetchAllSubhashitas()
            deferred.resolve(withValue: NSArray(array:cachedSubhashitas, copyItems: true) as AnyObject)
            return nil
        }) { (error) -> AnyObject? in
            deferred.rejectWithError(error)
            return nil
        }
        return deferred.promise
    }
    
    func fetchAllSubhashitas()->[Subhashita]{
        let subhashitaStorage = SubhashitaStorage(sqliteStore: self.sqliteTableStore!)
        let cachedSubhashitas = subhashitaStorage.fetchAllSubhashitas()
        return cachedSubhashitas
    }
    
    fileprivate func notifyObserver(_ subhashita : Subhashita) {
        let cachedSubhashitas = self.subhashitaStorage!.fetchAllSubhashitas()
        observer!.subhashitaRepository(self, cachedSubhashita: cachedSubhashitas)
    }
}
