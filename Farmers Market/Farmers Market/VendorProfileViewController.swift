//
//  VendorProfileViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/17/22.
//

import UIKit

class VendorProfileViewController: UIViewController {

    let api = APIGet()
    var vendorID = -1
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Profile"
        api.sessionId = UserDefaults.standard.string(forKey: "sessionId")!
        let leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editProfile)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        // Do any additional setup after loading the view.
        let vendorId = UserDefaults.standard.integer(forKey: "vendorId")
        
        api.getVendorInfo(id: vendorId,
                          success: { (vendor) in
            DispatchQueue.main.sync {
                self.nameLabel.text = vendor.name
                self.sloganLabel.text = vendor.slogan
                self.descriptionLabel.text = vendor.description
            }
        }, fail: { (error) in
            print(error)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.title = "Profile"
        api.sessionId = UserDefaults.standard.string(forKey: "sessionId")!
        let leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editProfile)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        // Do any additional setup after loading the view.
        let vendorId = UserDefaults.standard.integer(forKey: "vendorId")
        
        api.getVendorInfo(id: vendorId,
                          success: { (vendor) in
            DispatchQueue.main.sync {
                self.nameLabel.text = vendor.name
                self.sloganLabel.text = vendor.slogan
                self.descriptionLabel.text = vendor.description
            }
        }, fail: { (error) in
            print(error)
        })
    }
    
    @objc private func editProfile(){
        let nextVc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateVendorSettings") as? UpdateVendorSettingsViewController
        self.navigationController?.pushViewController(nextVc!, animated: true)
    }
    
    @objc private func logout(){
        api.logout(success: {
            UserDefaults.standard.set(false, forKey:"userLoggedIn")
            UserDefaults.standard.set("", forKey:"sessionId")
            UserDefaults.standard.set(-1, forKey: "vendorId")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                
            }
            print("logout success")
        }, fail: { output in
            print(output)
            
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
