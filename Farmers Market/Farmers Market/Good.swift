//
//  Good.swift
//  Farmers Market
//
//  Created by Brian Qi on 4/18/22.
//

import Foundation

class Good {
    var good_id = -1;
    var vendor_id = -1;
    var description = "";
    var name = "";
    var stock = -1;
    //var picture = ?;
    var good_type = -1;
    
    init() {
        
    }
    init(g_id: Int, v_id: Int, desc: String, name: String, stock: Int, good_type: Int) {
        self.good_id = g_id;
        self.vendor_id = v_id;
        self.description = desc;
        self.name = name;
        self.stock = stock;
        self.good_type = good_type;
    }
}
