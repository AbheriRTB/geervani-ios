
//
//  SubhashitaViewController.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 14/01/16.
//  Copyright (c) 2016 Abheri. All rights reserved.
//

import UIKit

class SubhashitaViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var subhashita_samskrit: UILabel!
    
    @IBOutlet weak var subhashita_english: UITextView!
    var sanskrit_sub = "स्वभावो नोपदेशेन शक्यते कर्तुमन्यथा ।" + "\n" +  "सुतप्तमपि पानीयं पुनर्गच्छति शीतताम् ॥";
    var english_sub = "It is not possible to change a persons habits by advising him. Just like water becomes hot when you heat it... But always turns cold (normal behaviour) in time.";

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.TopicTableView.frame=CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height*0.7))
        
        //let maxWidth = self.view.frame.size.width
        //let maxHeight = self.view.frame.size.height
        
        //SubhashitaScrollView.contentSize = CGSizeMake(maxWidth, maxHeight);
        
        subhashita_samskrit.layoutMargins.right=20;

        subhashita_samskrit.text = sanskrit_sub;
        subhashita_english.text = english_sub;
        
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
