//
//  TestViewController.swift
//  Farmers Market
//
//  Created by Brian Qi on 3/30/22.
//

import UIKit

class TestViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var userid = ""
    func success() {
        print("yay")
    }
    func lib(output: [String: Any]) {
        print("yay")
    }
    func fail(output: String) {
        print(output)
    }
    func vend(output: [Vendor]) {
        print(output[0].id);
    }
    func vendi(output: Vendor) {
        print(output.description);
    }
    let api = APIGet()
    @IBAction func GetRequest(_ sender: Any) {
        
        //api.login(user: "test", pass: "test", success: success, fail: fail)
        //api.signup(email: "123", pass: "123", name: "hello", isVendor: false, success: success, fail: fail)
        //api.getVendors(name: "", success: vend, fail: fail);
        api.getVendorInfo(id: 1, success: vendi, fail: fail)
        //print(userid)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        api.logout(success: success, fail: fail)
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
