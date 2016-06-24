//
//  FileReaderHelper.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 23/01/16.
//  Copyright © 2016 Abheri. All rights reserved.
//

import Foundation

class FileReaderHelper {
    var firstArray:[String] = []
    var topicobj:Topic = Topic()
    var wordobj:Word = Word()
    var mcontents:NSString=""
    
    func readData()->Topic{
        let bundle = NSBundle.mainBundle()
        //let pathNav = bundle.pathForResource("DataFiles/Topics/Etiquttes", ofType: "txt")
        
        let pathNav = bundle.pathForResource("Topics/Etiquettes", ofType: "txt")
        // File path (change this).
        
        do{
            // Read an entire text file into an NSString.
            let contents = try NSString(contentsOfFile: pathNav!,
                encoding:NSUTF8StringEncoding)
            
            // Print all lines.
            
            contents.enumerateLinesUsingBlock({ (line, stop) -> () in
                print("Line = \(line)")
                if !line.hasPrefix("//") && !line.isEmpty{
                    let parts = line.componentsSeparatedByString(":")
                    print(parts)
                    if line.containsString("_en") && parts.count == 2{
                        let key = parts[0].stringByReplacingOccurrencesOfString("_en", withString: "")
                        self.topicobj.sentenceEnglish.updateValue(parts[1], forKey: key)
                        
                        //Initialize other dictonaries with emptry strings
                        self.topicobj.sentenceSamskrit.updateValue("", forKey: key)
                        self.topicobj.sentenceTranslit.updateValue("", forKey: key)
                    }
                    if line.containsString("_sn") && parts.count == 2{
                        let subparts = parts[1].componentsSeparatedByString("।")
                        
                        if subparts.count == 2{
                            let key = parts[0].stringByReplacingOccurrencesOfString("_sn", withString: "")
                            
                            self.topicobj.sentenceSamskrit.updateValue(subparts[0], forKey: key)
                            self.topicobj.sentenceTranslit.updateValue(subparts[1], forKey: key)
                        }
                    }
                    
                    /*
                    for part in parts{
                    print(part)
                    if !line.containsString("_en") && !part.isEmpty{
                    self.firstArray.append(part)
                    //topicobj.sentenceEnglish[
                    }
                    }*/
                }
            })
            
            //print(self.firstArray)
            print(topicobj)
            
        }catch let error as NSError {
            print("error writing to url \(pathNav)")
            print(error.localizedDescription)
        }
        
        return topicobj
        
    }
    
    func readFileFromBundle(file:String, callback:(NSString)->Void){
        
        var contents:NSString=""
        
        let bundle = NSBundle.mainBundle()
        //let pathNav = bundle.pathForResource("Topics/Etiquttes", ofType: "txt")
        
        let pathNav = bundle.pathForResource(file, ofType: "txt")
        // File path (change this).
        
        do{
            // Read an entire text file into an NSString.
            contents = try NSString(contentsOfFile: pathNav!,
                encoding:NSUTF8StringEncoding)
            print(contents)
            callback(contents)
            
        }catch let error as NSError {
            print("error writing to url \(pathNav)")
            print(error.localizedDescription)
        }
    }
    
    
    func readFileFromWeb(file:String, callback:(NSString)->Void) {
        
        var contents:NSString=""
        
        //let url = "http:///abheri.pythonanywhere.com/static/geervani/datafiles/topics/Etiquettes.txt"
        
        let messageURL = NSURL(string:file)
        
        let sharedSession = NSURLSession.sharedSession()
        print("---------------FROM WEB------------")
        let task = sharedSession.dataTaskWithURL(messageURL!) {(data, response, error) in
            
            contents = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print(contents)
            callback(contents)
            
        }
        task.resume()
    }
    
    
    
    func readWordData(contents:NSString)->Word{
        
        let lines = contents.componentsSeparatedByString("\n")
        for line in lines{
            print("Line = \(line)")
            if !line.hasPrefix("//") && !line.isEmpty{
                let parts = line.componentsSeparatedByString(":")
                print(parts)
                if line.containsString("_en") && parts.count == 2{
                    let key = parts[0].stringByReplacingOccurrencesOfString("_en", withString: "")
                    let ns = parts[1].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
                    self.wordobj.wordEnglish.updateValue(ns, forKey: key)
                    
                    //Initialize other dictonaries with emptry strings
                    self.wordobj.wordSamskrit.updateValue("", forKey: key)
                }
                if line.containsString("_sn") && parts.count == 2{
                    
                    let key = parts[0].stringByReplacingOccurrencesOfString("_sn", withString: "")
                    var ns = parts[1].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
                    self.wordobj.wordSamskrit.updateValue(ns, forKey: key)
                }
                
            }
        }
        
        return wordobj
    }
    
    func readTopicData(contents:NSString)->Topic{
        
        let lines = contents.componentsSeparatedByString("\n")
        for line in lines{
            print("Line = \(line)")
            if !line.hasPrefix("//") && !line.isEmpty{
                let parts = line.componentsSeparatedByString(":")
                print(parts)
                if line.containsString("_en") && parts.count == 2{
                    let key = parts[0].stringByReplacingOccurrencesOfString("_en", withString: "")
                    let ns = parts[1].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
                    self.topicobj.sentenceEnglish.updateValue(ns, forKey: key)
                    
                    //Initialize other dictonaries with emptry strings
                    self.topicobj.sentenceSamskrit.updateValue("", forKey: key)
                    self.topicobj.sentenceTranslit.updateValue("", forKey: key)
                }
                if line.containsString("_sn") && parts.count == 2{
                    let subparts = parts[1].componentsSeparatedByString("<br>")
                    
                    if subparts.count == 2{
                        let key = parts[0].stringByReplacingOccurrencesOfString("_sn", withString: "")
                        var ns = subparts[0].stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
                        self.topicobj.sentenceSamskrit.updateValue(ns, forKey: key)
                        
                        ns = subparts[1].stringByReplacingOccurrencesOfString("\",", withString: "")
                        self.topicobj.sentenceTranslit.updateValue(ns, forKey: key)
                    }
                }
                
            }
        }
        
        return topicobj
    }
}

