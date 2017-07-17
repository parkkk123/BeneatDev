//
//  MyPlaceCell.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/4/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit

class MyPlaceCell: UITableViewCell {
    
    static let identifier = "MyPlaceCell"
    @IBOutlet weak var placeNameText: UILabel!
    @IBOutlet weak var addressText: UILabel!

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
    
    public func configureWithItem(item: MyPlaceDataModelItem){
        placeNameText.text = item.place_name
        addressText.text = item.address
    }

}
