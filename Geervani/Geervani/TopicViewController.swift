//
//  TopicViewController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 15/01/16.
//  Copyright © 2016 Abheri. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var TopicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TopicTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
