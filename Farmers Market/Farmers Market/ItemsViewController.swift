//
//  ItemsViewController.swift
//  Farmers Market
//
//  Created by MacOS on 4/17/22.
//

import UIKit

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let api = APIGet()
    var goods : [[String: Any]] = []
    @IBOutlet var tableViewElem: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewElem.delegate = self
        tableViewElem.dataSource = self
        print("HA21421!")
        /*
        api.getGoods(name: "", success:{ (goods: [[String: Any]]) in
            self.goods = goods
            DispatchQueue.main.sync {
                self.tableViewElem.reloadData()
            }
            print("HA!")
            print(self.goods)
        }, fail:{ error in
            print(error)
        })*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodCell", for: indexPath) as! GoodTableViewCell
        
        let good = goods[indexPath.row]
        let name = good["name"] as! String;
        let description = good["description"] as! String;
        cell.nameLabel.text = name
        cell.descriptionLabel.text = description
        
        return cell
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! VendorsViewCell
        let indexPath = tableViewElem.indexPath(for:cell)!
        let vendorID = goods[indexPath.row]["vendor_id"] as! Int;
        let detailsViewController = segue.destination as! VendorDetailController
        detailsViewController.vendorID = vendorID
        tableViewElem.deselectRow(at: indexPath, animated: true)

    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
