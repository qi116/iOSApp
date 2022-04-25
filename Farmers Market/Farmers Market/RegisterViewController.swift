//
//  RegisterViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/10/22.
//

import UIKit

class RegisterViewController: UIViewController {
    let api = APIGet()
    var vendor = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        usernameField.becomeFirstResponder()
//        passwordField.becomeFirstResponder()
//        nameField.becomeFirstResponder()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var vendorSegmentedControl: UISegmentedControl!
    @IBAction func vendorStatusChanged(_ sender: Any) {
        switch vendorSegmentedControl.selectedSegmentIndex{
        case 0:
            vendor = true
        case 1:
            vendor = false
        default:
            break
        }
    }
    
    @IBOutlet weak var vendorSelection: UISegmentedControl!
    
    @IBAction func onSubmit(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        let name = nameField.text
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        nameField.resignFirstResponder()
        
        if(username!.isEmpty || password!.isEmpty || name!.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please fill out all required field.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            api.signup(email: username!, pass: password!, name: name!, isVendor: self.vendor, success: {
                print("signup success")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }, fail: { output in
                let alert = UIAlertController(title: "Error", message: "Register failed, please change name or password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print (output)
                print("signup failed")
            })
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        nameField.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    @objc func handleTap() {
        usernameField.resignFirstResponder() // dismiss keyoard
        passwordField.resignFirstResponder()
        nameField.resignFirstResponder()
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
