//
//  VendorDetailController.swift
//  Farmers Market
//
//  Created by Justin Thai on 4/14/22.
//

import UIKit

class VendorDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let api = APIGet()
    var vendorID = -1
    var items: [[String:Any]] = []
    
    @IBOutlet weak var vendorBG: UIImageView!
    @IBOutlet weak var vendorProfile: UIImageView!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorSlogan: UILabel!
    @IBOutlet weak var vendorDescription: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        api.getVendorInfo(id: vendorID,
            success: { (vendor) in
                DispatchQueue.main.sync {
                    self.vendorName.text = vendor.name
                    self.vendorSlogan.text = vendor.slogan
                    self.vendorDescription.text = vendor.description
                    self.vendorID = vendor.id
                }
            }, fail: { (error) in
                print(error)
            }
        )
        api.getGoods(name: "", success:{ (items: [[String: Any]]) in
            for item in (items as [[String:Any]]) {
                let itemVendorID: Int = item["vendor_id"] as? Int ?? -1
                if itemVendorID == self.vendorID {
                    self.items.append(item)
                }
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
            print(self.items)
        }, fail:{ error in
            print(error)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        api.getVendorInfo(id: vendorID,
            success: { (vendor) in
                DispatchQueue.main.sync {
                    self.vendorName.text = vendor.name
                    self.vendorSlogan.text = vendor.slogan
                    self.vendorDescription.text = vendor.description
                    self.vendorID = vendor.id
                }
            }, fail: { (error) in
                print(error)
            }
        )
        api.getGoods(name: "", success:{ (items: [[String: Any]]) in
            for item in (items as [[String:Any]]) {
                let itemVendorID: Int = item["vendor_id"] as? Int ?? -1
                if itemVendorID == self.vendorID {
                    self.items.append(item)
                }
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
            print(self.items)
        }, fail:{ error in
            print(error)
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        let name = item["name"] as! String
        let description = item["description"] as! String
        var stock: Int = item["stock"] as? Int ?? 0
        if stock < 0 {
            stock = 0
        }
        cell.itemNameLabel.text = name
        cell.descriptionLabel.text = description
        cell.stockLabel.text = String(stock) + " Units"
        
        return cell
    }

}
