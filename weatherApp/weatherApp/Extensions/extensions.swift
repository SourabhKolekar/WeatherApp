//
//  extensions.swift
//  weatherApp
//
//  Created by Sourabh on 20/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation


extension Double{
    //rounds the double value to the decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor=pow(10.0, Double(places))
        return (self*divisor).rounded()/divisor
    }
}

extension Date{
    func dayOfTheWeek()->String{
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="EEEE"
        return  dateFormatter.string(from: self)
    }
}
