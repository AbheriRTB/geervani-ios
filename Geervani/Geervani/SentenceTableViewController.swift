//
//  SentenceTableViewController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 19/01/16.
//  Copyright © 2016 Abheri. All rights reserved.
//

import UIKit


class SentenceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var SentenceTableView: UITableView!
    
    @IBOutlet weak var SentenceSanskritLabel: UILabel!
    @IBOutlet weak var SentenceEnglishLabel: UILabel!
    
    var topicobj:Topic = Topic()
    
    
    var sentenceList = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    let topicListDict:[String:String] =
    [
        "Etiquttes":"Etiquttes.txt",
        "Introduction":"Introduction.txt",
        "Meeting Friends":"MeetingFriends.txt",
        "Journey":"Journey.txt",
        "On Arrival":"OnArrival.txt",
        "Train":"Train.txt",
        "Students":"Students.txt",
        "Examination":"Examination.txt",
        "Films":"Films.txt",
        "Teachers":"Teachers.txt",
        "Telephone":"Telephone.txt",
        "Dress & Jewelry":"DressJewelry.txt",
        "Commerce":"Commerce.txt",
        "Weather":"Weather.txt",
        "Domestic":"Domestic.txt",
        "Food":"Food.txt",
        "Women":"Women.txt",
        "Time":"Time.txt",
        "Greetings":"Greetings.txt"
    ]
    

    var passedValue:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = passedValue
        
        self.SentenceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SentenceCell")
        //self.SentenceTableView.backgroundColor=UIColor.greenColor()
        
        
        let fileHelper = FileReaderHelper()
        //MARK: Move base URL to a plist file
        let url = "http://abheri.pythonanywhere.com/static/geervani/datafiles/topics/" + topicListDict[passedValue]!
        fileHelper.readFileFromWeb(url, callback: refreshSentenceTableWithData)
        //topicobj = ff.readData()
        sentenceList = topicobj.sentenceEnglish
        
    }
    
    func refreshSentenceTableWithData(contents:NSString){
        let fileHelper = FileReaderHelper()
        topicobj = fileHelper.readTopicData(contents)
        sentenceList = topicobj.sentenceEnglish
        
        dispatch_async(dispatch_get_main_queue(),{
            self.SentenceTableView.reloadData()
        });
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
        return sentenceList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentenceCell", forIndexPath: indexPath)
        
        // Configure the cell...
        //var cell = tableView.dequeueReusableCellWithIdentifier("TopicCell") as! UITableViewCell
        
        cell.textLabel?.text = sentenceList[indexPath.row]
        cell.backgroundColor=UIColor.whiteColor()
        
        //let imageName = UIImage(named: "ic_launcher.png")
        //cell.imageView?.image = imageName
        
        return cell
    }
    
    var valueToPass:String!
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!;
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        
        //SentenceSanskritLabel.text = currentCell.textLabel!.text
        valueToPass = currentCell.textLabel!.text
        
        SentenceSanskritLabel.text = topicobj.sentenceSamskrit[indexPath.row]
        SentenceEnglishLabel.text = topicobj.sentenceTranslit[indexPath.row]
        //performSegueWithIdentifier("TopicSelected", sender: self)
        
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "TopicSelected") {
            
            // initialize new view controller and cast it as your view controller
            let viewController:SentenceTableViewController = segue.destinationViewController as! SentenceTableViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue = valueToPass
        }
        
    }*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
