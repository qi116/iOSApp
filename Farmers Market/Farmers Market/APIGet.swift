//
//  APIGet.swift
//  Farmers Market
//
//  Created by Brian Qi on 3/28/22.
//

//import Foundation
import UIKit

class APIGet {
    
    
    //URLRequest(url: url)
    //var request = URLRequest(url: url)
	
    //request.httpMethod = "POST"
    func test() {
        let url = URL(string: "http://128.211.194.217:3000/api/user/login")!
        var request = URLRequest(url:url)
        
        let json: [String: Any] = ["email": "test", "password": "test"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //print(jsonData	)
        
        /*var username = "test"
        var password = "test"
        
        let body = "email_address=\(username)&password=\(password)";
        let finalBody = body.data(using: .utf8)*/
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                //let image = UIImage(data: data)
                //print(response)
                let jsonInfo = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonInfo = jsonInfo as? [String: Any] {
                    print(jsonInfo)
                }
            } else if let error = error {
                print("Error \(error)")
            }
            
        }
        task.resume()
        
    }
}



