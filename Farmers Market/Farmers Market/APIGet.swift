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
    var isVendor = true
    var userId = 0
    var vendorId = 0
    //URLRequest(url: url)
    //var request = URLRequest(url: url)
    
    //request.httpMethod = "POST"
    func getId() -> String{
        return sessionId;
    }
    func setId(id: String) {
        sessionId = id;
    }
    
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

    func login(user: String, pass: String, success:@escaping ([String: Any]) -> Void, fail: @escaping(String) -> Void){
        self.request(
            link: "http://128.211.194.217:3000/api/user/login",
            json: ["email_address": user, "password": pass],
            callback: { output in
                if let code = output["data"] {
                    var userInfo : [String: Any] = [:]
                    self.sessionId = (code as! [String:Any])["session_full_code"] as! String
                    self.userId = (code as! [String:Any])["user_id"] as! Int
//                    let userType = (code as! [String:Any])["user_id"] as! String
                    self.isVendor = ((code as! [String:Any])["user_type"] as! String == "vendor")
                    if (self.isVendor){
                        self.vendorId = (code as! [String:Any])["vendor_id"] as! Int
                        userInfo["vendorId"] = self.vendorId
                    }
                    else{
                        
                    }
                    print("Session id: " + self.sessionId)
                    print(self.userId)
                    if(self.isVendor){
                        print("Is vendor: TRUE")
                    }else{
                        print("Is vendor: FALSE")
                    }
                    userInfo["sessionId"] = self.sessionId
                    userInfo["userId"] = self.userId
                    userInfo["isVendor"] = self.isVendor
                    print(userInfo)
                    success(userInfo)
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
        let json = ["session_full_code": self.sessionId]
        print(self.sessionId)
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
    
    func signup(email: String, pass: String, name: String, isVendor: Bool, success:@escaping () -> Void, fail: @escaping(String) -> Void)    {
        var type = "customer"
        if (isVendor) {
            type = "vendor"
        }
        self.request(
            link: "http://128.211.194.217:3000/api/user/signup",
            json: ["email_address": email, "name": name, "password": pass, "user_type": type],
            callback: { output in
                if let code = output["success"] {
                    if (code as! Int == 1) {
                        success()
                    } else {
                        fail(output["errorCode"] as! String)
                    }
                    
                }
                else {
                    fail(output["errorCode"] as! String)
                }
        })
//        let url = "http://128.211.194.217:3000/api/user/login"
//        let json = ["email_address": user, "password": pass]
        
    }
    /*
     * gets list of vendors searched by name
     * Accepts callback function that can accept list of dictionaries and one that accepts an error message
     */
    func getVendors(name: String, success:@escaping ([Vendor]) -> Void, fail: @escaping(String) -> Void)    {
        self.request(
            link: "http://128.211.194.217:3000/api/vendors/getvendors",
            json: ["search_name": name],
            callback: { output in
                var vendors : [Vendor] = [];
                if let list = output["data"] {
                    
                    for ven in (list as! [[String: Any]]) {
                        let v = Vendor(id: ven["vendor_id"] as! Int, slogan: ven["slogan"] as! String, name: ven["name"] as! String, longitude: ven["longitude"] as! Double, latitude: ven["latitude"] as! Double);
                        vendors.append(v);
                    }
                    
                    success(vendors) //create a vendor object and make the dicts into them.
                    
                } else {
                    fail(output["error_code"] as! String)
                }
        })
        
    }
    
    func getVendorInfo(id: Int, success:@escaping (Vendor) -> Void, fail: @escaping(String) -> Void) {
        self.request(
            link: "http://128.211.194.217:3000/api/vendors/getvendorinfo",
            json: ["vendor_id": id],
            callback: { output in
                if let list = output["data"] {
                    let ven = list as! [String: Any]
                    let v = Vendor(id: id, slogan: ven["slogan"] as! String, name: ven["name"] as! String, description: ven["description"] as! String, longitude: ven["longitude"] as! Double, latitude: ven["latitude"] as! Double);
                    success(v) //create a vendor object and make the dicts into them.
                    
                } else {
                    fail(output["error_code"] as! String)
                }
        })
        
    }
    
    func getGoods(name: String, success:@escaping ([[String: Any]]) -> Void, fail: @escaping(String) -> Void)    {
        self.request(
            link: "http://128.211.194.217:3000/api/goods/getgoods",
            json: ["search_name": name],
            callback: { output in
                var goods : [[String: Any]] = [];
                if let list = output["data"] {
                    
                    for good in (list as! [[String: Any]]) {
                        goods.append(good);
                    }
                    
                    success(goods) //create a vendor object and make the dicts into them.
                    
                } else {
                    fail(output["error_code"] as! String)
                }
        })
        
    }
    
    func updateVendorSettings(id: Int, description: String, longitude: Float, latitude: Float, slogan: String, success:@escaping () -> Void, fail: @escaping(String) -> Void){
        self.request(
            link: "http://128.211.194.217:3000/api/vendors/updatesettings",
            json: ["vendor_id" : id, "description" : description, "background_picture": nil, "longitude": longitude, "latitude": latitude, "slogan": slogan, "session_full_code": self.sessionId],
            callback: { output in
                if let val = output["success"] {
                    if ((val as! Int) == 1) {
                        success()
                        self.sessionId = ""
                    }
                    else {
                        print("Failed to update")
                        fail(output["errorCode"] as! String)
                    }
                }
                
            })
    }
    
}


//"http://128.211.194.217:3000/api/vendors/updatesettings"
//"http://128.211.194.217:3000/api/user/getuserinfo"
