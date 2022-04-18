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
        let name = item["name"] as! String;
        let description = item["description"] as! String;
        cell.itemNameLabel.text = name
        cell.descriptionLabel.text = description
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
