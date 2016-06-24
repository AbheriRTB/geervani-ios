//
//  DictionaryTableViewController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 30/03/16.
//  Copyright © 2016 Abheri. All rights reserved.
//

import UIKit

class DictionaryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var DictionaryTableView: UITableView!
    
    
    var dictobj:Dict =  Dict()
    var tmpWord:Word = Word()
    
    let dbInstance:ModelManager = ModelManager.getInstance()
    var fileProcessed:String = "";
    var processedFileCounter:Int = 0;
    var allWordData:NSMutableArray = NSMutableArray()
    var myActivityIndicator:UIActivityIndicatorView =
                    UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    
    var wordlist=["Loading Please Wait..."]
    
    let wordFiles=[ "LetterA", "LetterB", "LetterC", "LetterD", "LetterE",
                    "LetterF", "LetterG", "LetterH", "LetterI", "LetterJ",
                    "LetterK", "LetterL", "LetterM", "LetterN", "LetterO",
                    "LetterP", "LetterQ", "LetterR", "LetterS", "LetterT",
                    "LetterU", "LetterV", "LetterW", "LetterX", "LetterY",
                    "LetterZ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DictionaryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "WordCell")


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let fileHelper = FileReaderHelper()
        //MARK: Move base URL to a plist file
        for var i=0; i<wordFiles.count; ++i{
            fileProcessed = wordFiles[i];
            let url = "http://abheri.pythonanywhere.com/static/geervani/datafiles/dictionary/" + fileProcessed + ".txt"
            fileHelper.readFileFromWeb(url, callback: refreshWordTableWithData)
        }
        //topicobj = ff.readData()
        //sentenceList = topicobj.sentenceEnglish
    }
    
    func refreshWordTableWithData(contents:NSString){
        let fileHelper = FileReaderHelper()
        dictobj = fileHelper.readDictData(contents)
        
        if processedFileCounter == 0{
            dbInstance.deleteAllWordData()
        }
        processedFileCounter++;
        
        for(key, value) in dictobj.wordEnglish{
            //wordlist.append(value)
            tmpWord.wordEnglish = value
            tmpWord.wordSamskrit = dictobj.wordSamskrit[key]!
            
            dbInstance.addWordData(tmpWord)
        }
        
        if processedFileCounter == 25{
            allWordData = dbInstance.getAllWordData()
            if allWordData.count > 0{
                wordlist.removeAll()
                for var i=0; i<allWordData.count; ++i{
                    let tw:Word = (allWordData[i] as? Word)!
                    wordlist.append(tw.wordEnglish)
                }
            }
            dispatch_async(dispatch_get_main_queue(),{
                self.DictionaryTableView.reloadData()
                self.myActivityIndicator.hidden = true
            
            });
        }
    }
    
    
    func createSpinner(){
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wordlist.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WordCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = wordlist[indexPath.row]
        //cell.backgroundColor=UIColor.greenColor()

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
