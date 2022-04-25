//
//  UpdateVendorSettingsViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/25/22.
//

import UIKit

class UpdateVendorSettingsViewController: UIViewController {

    var api = APIGet()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sloganTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Update Settings"
        UserDefaults.standard.set(false, forKey:"userLoggedIn")
        
        api.sessionId = UserDefaults.standard.string(forKey: "sessionId")!
        print("SessionId = " + api.sessionId)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        let vendorId = UserDefaults.standard.integer(forKey: "vendorId")
        var description = descriptionTextField.text!
        var slogan = sloganTextField.text
        var longitude = Float(longitudeTextField.text!)
        var latitude = Float(latitudeTextField.text!)
        
//        description = "I am changed"
//        slogan = "I am refreshed"
//        longitude = 40.42487
//        latitude = -86.91473
//        longitude = 40.42527650418596
//        latitude = -86.91392456010239
        api.updateVendorSettings(id: vendorId, description: description, longitude: longitude!, latitude: latitude!, slogan: slogan!, success: {
            print("Update success")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }, fail: {output in
            print(output)
        })
    }
    
    @objc func handleTap() {
        descriptionTextField.resignFirstResponder() // dismiss keyoard
        sloganTextField.resignFirstResponder()
        longitudeTextField.resignFirstResponder()
        latitudeTextField.resignFirstResponder()
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
