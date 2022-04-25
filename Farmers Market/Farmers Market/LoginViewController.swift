//
//  LoginViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/10/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let api = APIGet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.text?.removeAll()
        passwordField.text?.removeAll()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            if UserDefaults.standard.bool(forKey: "isVendor") == true{
                let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorProfile") as? VendorProfileViewController
                self.navigationController?.pushViewController(nextVc!, animated: false)
            }else{
                let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerProfile") as? CustomerProfileViewController
                self.navigationController?.pushViewController(nextVc!, animated: false)
            }
        }
        usernameField.text?.removeAll()
        passwordField.text?.removeAll()
        
    }
    
    @objc func handleTap() {
        usernameField.resignFirstResponder() // dismiss keyoard
        passwordField.resignFirstResponder()
    }
    
    @IBAction func onLogin(_ sender: Any) {
        var email = ""
        var pass = ""
        email = usernameField.text!
        pass = passwordField.text!
        
//        email = "test"
//        pass = "test"
        if (email.isEmpty || pass.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Username or Password could not be empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            api.login(user: email, pass: pass, success: { (userInfo: [String: Any]) in
                UserDefaults.standard.set(true, forKey:"userLoggedIn")
                UserDefaults.standard.set( userInfo["sessionId"], forKey:"sessionId")
                UserDefaults.standard.set( userInfo["userId"], forKey:"userId")
                UserDefaults.standard.set( userInfo["isVendor"], forKey:"isVendor")

                print("successfully get session ID: " + UserDefaults.standard.string(forKey: "sessionId")!)
                
                if (UserDefaults.standard.bool(forKey: "isVendor")){
                    DispatchQueue.main.async {
                        UserDefaults.standard.set( userInfo["vendorId"], forKey:"vendorId")
                        let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "VendorProfile") as? VendorProfileViewController
                        self.navigationController?.pushViewController(nextVc!, animated: true)
                    }
                }
                else{
                    //go to user profile
                    DispatchQueue.main.async {
                        let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerProfile") as? CustomerProfileViewController
                        self.navigationController?.pushViewController(nextVc!, animated: true)
                    }
                }
                print("success")
            }, fail: { output in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Invalid Username or Password.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print(output)
            })
            
        }
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
