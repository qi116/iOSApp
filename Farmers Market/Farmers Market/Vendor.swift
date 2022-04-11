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
    
    init(id: Int, slogan: String, name: String, longitude: Double, latitude: Double) {
        self.id = id;
        self.slogan = slogan
        self.name = name;
        self.longitude = longitude
        self.latitude = latitude
    }
}
