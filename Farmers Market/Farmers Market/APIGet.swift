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
        
        let json = ["email_address": "test", "password": "test"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        //print(jsonData)
        
        /*var username = "test"
        var password = "test"
        
        let body = "email_address=\(username)&password=\(password)";
        let finalBody = body.data(using: .utf8)*/
        
        request.httpMethod = "POST"
        
        
        
        request.httpBody = jsonData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
    
    func request(link: String, json: [String: Any]) -> [String: Any] {
        let url = URL(string: link)!
        var request = URLRequest(url:url)
        
        //let json = ["email_address": "test", "password": "test"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        //print(jsonData)
        
        /*var username = "test"
        var password = "test"
        
        let body = "email_address=\(username)&password=\(password)";
        let finalBody = body.data(using: .utf8)*/
        
        request.httpMethod = "POST"
        
        
        
        request.httpBody = jsonData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var result = ["empty" : "empty"] as [String: Any]
        let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {sem.signal()}
            if let data = data {
                //let image = UIImage(data: data)
                //print(response)
                let jsonInfo = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonInfo = jsonInfo as? [String: Any] {
                    print(jsonInfo)
                    result = jsonInfo
                }
            } else if let error = error {
                print("Error \(error)")
            }
            
        }
        task.resume()
        sem.wait()
        return result
    }
    
    /*
     * @params user, pass
     * Returns user id if succeeds. Returns "fail" if login failed
     */
    func login(user: String, pass: String) -> String{
        let url = "http://128.211.194.217:3000/api/user/login"
        let json = ["email_address": user, "password": pass]
        let output = request(link: url, json: json)
        if let exists = output["empty"] {
            return "failed to reach server"
        }
        else if let code = output["data"] {
            return (code as! [String:Any])["session_full_code"] as! String
            
        }
        return "login failed with error \(output["errorCode"] ?? "unknown error")" 
        
    
    }
    
    func logout(id: String) -> String{
        let url = "http://128.211.194.217:3000/api/user/logout"
        let json = ["session_full_code": id]
        let output = request(link: url, json: json)
        if let exists = output["empty"] {
            return "failed to reach server"
        }
        if let success = output["success"] {
            if ((success as! Int) == 1) {
                return "Successfully logged out"
            }
            else {
                return "Could not log out with error \(output["errorCode"] ?? "unknown error")"
            }
        }
        return "oops"
        
    }
    
    
}



