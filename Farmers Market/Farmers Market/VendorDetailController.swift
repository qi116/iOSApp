//
//  VendorDetailController.swift
//  Farmers Market
//
//  Created by Justin Thai on 4/14/22.
//

import UIKit

class VendorDetailController: UIViewController {

    let api = APIGet()
    var vendor: Vendor!
    
    @IBOutlet weak var vendorBG: UIImageView!
    @IBOutlet weak var vendorProfile: UIImageView!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorSlogan: UILabel!
    @IBOutlet weak var vendorDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorName.text = vendor.name
        vendorSlogan.text = vendor.slogan
        vendorDescription.text = vendor.description
        // Do any additional setup after loading the view.
    }

}
