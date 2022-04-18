//
//  VendorsViewController.swift
//  Farmers Market
//
//  Created by Justin Thai on 4/11/22.
//

import UIKit

class VendorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let api = APIGet()
    var vendors : [Vendor] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        api.getVendors(name: "", success:{ (vendors: [Vendor]) in
            self.vendors = vendors
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }, fail:{ error in
            print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorCell", for: indexPath) as! VendorsViewCell
        
        let vendor = vendors[indexPath.row]
        let name = vendor.name
        let slogan = vendor.slogan
        cell.VendorName.text = name
        cell.VendorSlogan.text = slogan
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! VendorsViewCell
        let indexPath = tableView.indexPath(for:cell)!
        let vendor = vendors[indexPath.row]
        let detailsViewController = segue.destination as! VendorDetailController
        detailsViewController.vendor = vendor
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
