//
//  Vendor.swift
//  Farmers Market
//
//  Created by Brian Qi on 4/11/22.
//

import Foundation

class Vendor {
    var id = -1;
    var slogan = "";
    var name = "";
    var longitude = 0.0;
    var latitude = 0.0;
    var description = "";
    
    init(id: Int, slogan: String, name: String, longitude: Double, latitude: Double) {
        self.id = id;
        self.slogan = slogan
        self.name = name;
        self.longitude = longitude
        self.latitude = latitude
    }
    init(id: Int, slogan: String, name: String, description: String, longitude: Double, latitude: Double) {
        self.id = id;
        self.slogan = slogan
        self.name = name;
        self.description = description;
        self.longitude = longitude
        self.latitude = latitude
    }

}
