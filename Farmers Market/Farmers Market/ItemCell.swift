//
//  ItemCell.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/17/22.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemPhotoView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
