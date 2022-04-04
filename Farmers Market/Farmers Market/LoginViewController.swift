//
//  LoginViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/3/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(_ sender: Any) {
        let api = APIGet()
        let jsoninfo = api.test()
        print (jsoninfo)
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
