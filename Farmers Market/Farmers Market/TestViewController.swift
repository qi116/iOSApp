//
//  TestViewController.swift
//  Farmers Market
//
//  Created by Brian Qi on 4/18/22.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func success() {
        print("yay")
    }
    func fail(output: String) {
        print(output)
    }
    let api = APIGet()
    @IBAction func login(_ sender: Any) {
        
        api.login(user: "test", pass: "test", success: success, fail: fail)
    }
    func readGoods(goods: [Good]) {
        print(goods[0].name)
        print(goods[1].stock)
    }
    func readGood(good: Good) {
        print(good.name)
        print(good.stock)
    }
    @IBAction func test(_ sender: Any) {
        
        //api.addGood(name: "one", description: "great", stock: 2, good_type: 5, success: success, fail: fail)
        api.getGoodInfo(id: 3, success: readGood, fail: fail)
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
