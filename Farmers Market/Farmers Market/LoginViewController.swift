//
//  LoginViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/10/22.
//

import UIKit

class LoginViewController: UIViewController {
    let api = APIGet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backBarButtonItem = UIBarButtonItem(
//            title: "Logout",
//            style: .plain,
//            target: self,
//            action: #selector(logout)
//        )
//        navigationItem.backBarButtonItem = backBarButtonItem
        // Do any additional setup after loading the view.
    }
    
//    @objc private func logout(){
//        api.logout(success: {
//            UserDefaults.standard.set(false, forKey:"userLoggedIn")
//            UserDefaults.standard.set("", forKey:"sessionId")
//            self.navigationController?.popViewController(animated: true)
//            print("logout success")
//        }, fail: { output in
//            print(output)
//
//        })
//
//    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
//            let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorProfile") as? VendorProfileViewController
//            self.navigationController?.pushViewController(nextVc!, animated: true)
//        }
//    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onLogin(_ sender: Any) {
        var email = ""
        var pass = ""
        email = usernameField.text!
        pass = passwordField.text!
        
        email = "test"
        pass = "test"
        
//        let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorProfile") as? VendorProfileViewController
//        self.navigationController?.pushViewController(nextVc!, animated: true)
        
        api.login(user: email, pass: pass, success: { output in
            UserDefaults.standard.set(true, forKey:"userLoggedIn")
            UserDefaults.standard.set(output, forKey:"sessionId")
            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "loginToProfile", sender: self)
                let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorProfile") as? VendorProfileViewController
                self.navigationController?.pushViewController(nextVc!, animated: true)
            }

            print("success")
        }, fail: { output in
            print(output)
        })
    }
    
    @IBAction func onRegister(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "register", sender: self)
        }
        
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
