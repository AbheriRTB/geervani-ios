//
//  SubhashitaDeserializer.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 10/12/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SwiftyJSON

class SubhashitaDeserializer {
    
    func deserializeSubhashitaFromContents(_ contents:NSString)-> [Subhashita]{
        
        var sanskrit = ""
        var meaning = ""
        var allSubhashitas = [Subhashita]()
        let lines = contents.components(separatedBy: "\n")
        for line in lines{
            if !line.hasPrefix("//") {
                if line.contains("<break>") {
                    sanskrit = sanskrit.replacingOccurrences(of: "'", with: "''")
                    let subhashita = Subhashita(sanskrit_text: sanskrit, english_meaning: meaning)
                    allSubhashitas.append(subhashita)
                    sanskrit = ""
                    meaning = ""
                }else{
                    sanskrit = sanskrit + "\n" + line
                }
                
            }
            
        }
        
        return allSubhashitas
    }
}


