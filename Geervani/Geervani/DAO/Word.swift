//
//  Word.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 30/03/16.
//  Copyright © 2016 Abheri. All rights reserved.
//


import Foundation

class Word : NSObject, NSCopying{

    var english:String?
    var sanskrit:String?
    
    var topic: Word?
    
    init(english: String,sanskrit: String) {
        self.english = english
        self.sanskrit = sanskrit
        
    }
    
    override func copy() -> Any {
        return self.copy(with: nil)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let englishCopy: String = self.english!.copy() as! String
        let sanskritCopy: String = self.sanskrit!.copy() as! String
        return Word(english: englishCopy,sanskrit: sanskritCopy)
    }
    
    /*
    func copy(with zone: NSZone?) -> Any {
        let englishCopy: String = self.english!.copy() as! String
        let sanskritCopy: String = self.sanskrit!.copy() as! String
        return Word(english: englishCopy,sanskrit: sanskritCopy)
    }
 */
    
    override  var description: String {
        return "<Word>: \n english: \(self.english), \n sanskrit: \(self.sanskrit)"
    }
}

