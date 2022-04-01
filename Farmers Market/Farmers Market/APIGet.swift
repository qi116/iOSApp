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
        let url = URL(string: "http://128.211.194.217:3000/api/hello")!
        var request = URLRequest(url:url)
        
        let json: [String: Any] = ["message": "hello"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                //let image = UIImage(data: data)
                //print(response)
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonData = jsonData as? [String: Any] {
                    print(jsonData)
                }
            } else if let error = error {
                print("Error \(error)")
            }
            
        }
        task.resume()
        
    }
}



