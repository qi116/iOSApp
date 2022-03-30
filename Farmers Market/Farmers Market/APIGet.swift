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
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                let image = UIImage(data: data)
                print(response)
            } else if let error = error {
                print("Error \(error)")
            }
            
        }
        task.resume()
        
    }
}



