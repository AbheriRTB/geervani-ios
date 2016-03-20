//
//  GeervaniController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 14/01/16.
//  Copyright (c) 2016 Abheri. All rights reserved.
//

import UIKit

class GeervaniController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in self.tabBar.items! {
            let unselectedItem = [NSForegroundColorAttributeName: UIColor.blackColor()]
            let selectedItem = [NSForegroundColorAttributeName: UIColor.blueColor()]
            
            item.setTitleTextAttributes(unselectedItem, forState: .Normal)
            item.setTitleTextAttributes(selectedItem, forState: .Selected)
        }

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
