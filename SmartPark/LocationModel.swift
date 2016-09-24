//
//  LocationModel.swift
//  Xcode7 DB Example
//
//  Created by Jose Cordova on 9/18/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import Foundation

class LocationModel: NSObject {
    
    //properties
    
    var id: String?
    var restaurantName: String?
    var qrCode: String?
    var price: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(id: String, restaurantName: String, qrCode: String, price: String) {
        
        self.id = id
        self.restaurantName = restaurantName
        self.qrCode = qrCode
        self.price = price
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "ID: \(id), RestaurantName: \(restaurantName), QRCode: \(qrCode), Price: \(price)"
        
    }
    
    
}
