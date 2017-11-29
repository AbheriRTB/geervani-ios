//
//  DictionaryTableCell.swift
//  Geervani
//
//  Created by Prasanna Ramaswamy on 03/07/16.
//  Copyright © 2016 Geervani. All rights reserved.
//

import UIKit

class DictionaryTableCell: UITableViewCell {
    
    
    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var ExampleText: UILabel!
    @IBOutlet weak var WordMeaningLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //    override func layoutSubviews() {
    //        let f = contentView.frame
    //        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
    //        contentView.frame = fr
    //    }
    
}
