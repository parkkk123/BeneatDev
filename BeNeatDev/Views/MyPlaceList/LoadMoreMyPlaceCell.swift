//
//  LoadMoreMyPlaceCell.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/20/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit
class LoadMoreMyPlaceCell: UITableViewCell {
    
    static let identifier = "LoadMoreMyPlaceCell"

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
  
}
