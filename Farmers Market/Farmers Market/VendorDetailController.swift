//
//  VendorDetailController.swift
//  Farmers Market
//
//  Created by Justin Thai on 4/14/22.
//

import UIKit

class VendorDetailController: UIViewController {

    let api = APIGet()
    var vendorID = -1
    
    @IBOutlet weak var vendorBG: UIImageView!
    @IBOutlet weak var vendorProfile: UIImageView!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorSlogan: UILabel!
    @IBOutlet weak var vendorDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getVendorInfo(id: vendorID,
            success: { (vendor) in
                DispatchQueue.main.sync {
                    self.vendorName.text = vendor.name
                    self.vendorSlogan.text = vendor.slogan
                    self.vendorDescription.text = vendor.description
                }
            }, fail: { (error) in
                print(error)
            }
        )
    }

}
