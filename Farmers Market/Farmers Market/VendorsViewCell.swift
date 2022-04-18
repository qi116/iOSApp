//
//  VendorsTableViewCell.swift
//  Farmers Market
//
//  Created by Justin Thai on 4/11/22.
//

import UIKit

class VendorsViewCell: UITableViewCell {
    
    @IBOutlet weak var VendorProfile: UIImageView!
    @IBOutlet weak var VendorName: UILabel!
    @IBOutlet weak var VendorSlogan: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
