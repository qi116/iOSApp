//
//  CustomerProfileViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/25/22.
//

import UIKit

class CustomerProfileViewController: UIViewController {

    var api = APIGet()
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        api.sessionId = UserDefaults.standard.string(forKey: "sessionId")!
        let leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        // Do any additional setup after loading the view.
    }
    @objc private func logout(){
        api.logout(success: {
            UserDefaults.standard.set(false, forKey:"userLoggedIn")
            UserDefaults.standard.set("", forKey:"sessionId")
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
