//
//  APIGet.swift
//  Farmers Market
//
//  Created by Brian Qi on 3/28/22.
//
//import Foundation
import UIKit

class APIGet {
    
    var sessionId = ""
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
    
    func sendRequest() -> Void {
        self.request(
            link: "http://128.211.194.217/api/user/login",
            json: ["email_address": "test", "password": "test"],
            callback: { resData in
            
                print(resData["success"]);
                
        })
    }
    
    func request(link: String, json: [String: Any], callback: @escaping([String: Any]) -> Void) -> Void {
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
        //var result = ["empty" : "empty"] as [String: Any]
        //let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //defer {sem.signal()}
            print(data);
            print(response);
            print(error);
            if let data = data {
                //let image = UIImage(data: data)
                //print(response)
                let jsonInfo = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonInfo = jsonInfo as? [String: Any] {
                    print(jsonInfo)
                    //result = jsonInfo
                    callback(jsonInfo);
                }
            } else if let error = error {
                callback(["errorCode": "Connection fail"])
                print("Error \(error)")
            }
            
        }
        task.resume()
        //sem.wait()
        //return result
    }
    
    /*
     * @params user, pass
     * Returns user id if succeeds. Returns "fail" if login failed
     */
    func login(user: String, pass: String, success:@escaping () -> Void, fail: @escaping(String) -> Void)	{
        self.request(
            link: "http://128.211.194.217:3000/api/user/login",
            json: ["email_address": user, "password": pass],
            callback: { output in
                if let code = output["data"] {
                    self.sessionId = (code as! [String:Any])["session_full_code"] as! String
                    success()
                }
                else {
                    fail(output["errorCode"] as! String)
                }
        })
//        let url = "http://128.211.194.217:3000/api/user/login"
//        let json = ["email_address": user, "password": pass]
        
    }
    
    func logout(success: @escaping() -> Void, fail: @escaping(String) -> Void){
        
        
        let url = "http://128.211.194.217:3000/api/user/logout"
        let json = ["session_full_code": sessionId]
        
        self.request(link: url, json: json, callback: {
            output in
            
            if let val = output["success"] {
                if ((val as! Int) == 1) {
                    success()
                    self.sessionId = ""
                }
                else {
                    fail(output["errorCode"] as! String)
                }
            }
            
        })
        
    }
    
    
}
