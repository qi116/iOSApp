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

    @IBAction func GetRequest(_ sender: Any) {
        let api = APIGet()
        userid = api.login(user: "h", pass: "test")
        print(userid)
    }
    
    @IBAction func logout(_ sender: Any) {
        let api = APIGet()
        print(api.logout(id: userid))
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
