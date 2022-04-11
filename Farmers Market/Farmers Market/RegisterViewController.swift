//
//  RegisterViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/10/22.
//

import UIKit

class RegisterViewController: UIViewController {
    let api = APIGet()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var vendorSelection: UISegmentedControl!
    
    @IBAction func onSubmit(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        let name = nameField.text
        let vendor = true
        
        api.signup(email: username!, pass: password!, name: name!, isVendor: vendor, success: {
            print("signup success")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }, fail: { output in
            print (output)
            print("signup failed")
        })
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
