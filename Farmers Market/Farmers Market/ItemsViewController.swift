//
//  ItemsViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/17/22.
//

import UIKit

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let api = APIGet()
    var items : [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        api.getGoods(name: "", success:{ (items: [[String: Any]]) in
            self.items = items
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
            print("HA!")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! ItemCell
        let indexPath = tableView.indexPath(for:cell)!
        let item = items[indexPath.row]
        let vendorID = item["vendor_id"] as! Int
        let detailsViewController = segue.destination as! VendorDetailController
        detailsViewController.vendorID = vendorID
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
