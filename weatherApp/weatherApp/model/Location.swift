//
//  Location.swift
//  weatherApp
//
//  Created by Sourabh on 22/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    
    var locationName:String!
    var longitude: Double!
    var latitude:Double!
    var forecastDays = "10"
    var temperature:Double!
    
    
//    var forecastDays:String! = "10"
}
