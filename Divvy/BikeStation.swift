//
//  BikeStation.swift
//  Divvy
//
//  Created by Justine Linscott on 6/4/19.
//  Copyright © 2019 Justine Linscott. All rights reserved.
//

import Foundation

class BikeStation {
    var name: String
    var availableBikes: Int
    var lat : Double
    var long : Double
    
    
    init(name: String, availableBikes: Int, lat: Double, long: Double) {
        self.name = name
        self.availableBikes = availableBikes
        self.lat = lat
        self.long = long
    }
}
