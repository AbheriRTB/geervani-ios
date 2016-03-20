//
//  TopicTableViewController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 14/01/16.
//  Copyright © 2016 Abheri. All rights reserved.
//

import UIKit

class TopicTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TopicTableView: UITableView!
    
    //let topicList = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    let topicList = ["Etiquttes", "Introduction",
        "Meeting Friends", "Journey", "On Arrival", "Train",
        "Students", "Examination", "Films", "Teachers", "Telephone",
        "Dress & Jewelry", "Commerce", "Weather", "Domestic", "Food",
        "Women", "Time", "Greetings"]
    

    
    let topicListSamskrit = ["शिश्ठाचारः", "परिचयः",
        "मित्र मेलनम्", "प्रयाणम्", "प्रवासतः प्रतिनिवर्तनम्", "रेल्यानम्",
        "छात्राः", "परीक्षा", "चलच्चित्रम्", "शिक्षकाः", "दूरभाषा",
        "वेषभूषणानि", "वाणिज्यम्", "वातावर्णम्", "गृहसंभाषणम्", "भोजनम्",
        "स्त्रियः", "समयः", "शुभाशयाः"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TopicTableView.delegate = self
        //TopicTableView.dataSource = self
        
        self.TopicTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TopicCell")
        
        //self.TopicTableView.frame=CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height*0.7))
        self.TopicTableView.backgroundColor=UIColor.whiteColor()
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return topicList.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath)
        
        //cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier: "TopicCell")

        // Configure the cell...
        //var cell = tableView.dequeueReusableCellWithIdentifier("TopicCell") as! UITableViewCell
        
        cell.textLabel?.text = topicList[indexPath.row]
        cell.backgroundColor=UIColor.whiteColor()
        cell.detailTextLabel?.text = topicListSamskrit[indexPath.row]
        
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
        
        valueToPass = currentCell.textLabel!.text
        performSegueWithIdentifier("TopicSelected", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "TopicSelected") {
            
            // initialize new view controller and cast it as your view controller
            let viewController:SentenceTableViewController = segue.destinationViewController as! SentenceTableViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue = valueToPass
        }
        
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
