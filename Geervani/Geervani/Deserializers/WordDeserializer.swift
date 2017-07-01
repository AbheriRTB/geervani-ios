//
//  WordDeserializer.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 27/06/16.
//  Copyright © 2016 Geervani. All rights reserved.
//


import Foundation
import Foundation
import UIKit
import PromiseKit
import SwiftyJSON

class WordDeserializer {
    
    func deserializeWordsFromContents(_ contents:NSString)-> [Word]{
        
        var wordText = ""
        var meaningText = ""
        var allWords = [Word]()
        
        let lines = contents.components(separatedBy: "\n")
        for line in lines{
            //print("Line = \(line)")
            if !line.hasPrefix("//") && !line.isEmpty{
                let parts = line.components(separatedBy: "n:")
                //print(parts)
                if line.contains("_en") && parts.count == 2{
                    let subparts = parts[1].components(separatedBy: "<br>");
                    if subparts.count >= 2{
                        wordText = subparts[0].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: CharacterSet.whitespaces)
                        
                        for i in 1...subparts.count-1{
                        meaningText = meaningText +
                                      subparts[i].trimmingCharacters(in: CharacterSet.whitespaces) + "\n\r"
                        }
                    }
                    else if subparts.count == 1{
                        wordText = subparts[0].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: CharacterSet.whitespaces)
                    }
                }
                if line.contains("_sn") && parts.count == 2{
                    
                    let ns = parts[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "<br>", with: "\n\r")

                    meaningText =  meaningText +
                                   ns.trimmingCharacters(in: CharacterSet.whitespaces)
                    
                    let word:Word = Word(english: wordText, sanskrit: meaningText)
                    allWords.append(word)
                    wordText=""
                    meaningText=""
                }
                
            }
        }
        
        return allWords
    }
}
