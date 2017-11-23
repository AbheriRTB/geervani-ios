//
//  Subhashia.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 09/12/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import Foundation

class Subhashita : NSObject, NSCopying{
    
    var sanskrit_text:String?
    var english_meaning:String?
    
    init(sanskrit_text: String, english_meaning: String) {
        self.sanskrit_text = sanskrit_text
        self.english_meaning = english_meaning
    }
    
    override func copy() -> Any {
        return self.copy(with: nil)
    }
    
    func copy(with zone: NSZone?) -> Any {
        let nameCopy: String = self.sanskrit_text!.copy() as! String
        let uriCopy: String = self.english_meaning!.copy() as! String
        return Subhashita(sanskrit_text: nameCopy, english_meaning : uriCopy)
    }
    
    override  var description: String {
        return "<Subhashita>:\n sanskrit_text: \(self.sanskrit_text), \n english_meaning: \(self.english_meaning)"
    }
}

