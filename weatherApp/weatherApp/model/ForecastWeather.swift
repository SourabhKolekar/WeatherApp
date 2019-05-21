//
//  ForecastWeather.swift
//  weatherApp
//
//  Created by Sourabh
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ForecastWeather{
    private var _cityName:String!
    private var _date:String!
    private var _temp:Double!
    private var _pressure: Double!
    private var _humidity: Double!
    
    var date:String{
        if _date==nil{
            _date=""
        }
        return _date
    }

    var cityName:String{
        if _cityName==nil{
            _cityName=""
        }
        return _cityName
    }

    
    
    var temp:Double{
        if _temp==nil{
            _temp=0.0
        }
        return _temp
    }

    var pressure:Double{
        if _pressure==nil{
            _pressure=0.0
        }
        return _pressure
    }
    
    var humidity:Double{
        if _humidity==nil{
            _humidity=0.0
        }
        return _humidity
    }
    
    init(weatherDict: Dictionary<String,AnyObject>) {
        if let temp=weatherDict["temp"] as? Dictionary<String,AnyObject>{
            if let dayTemp=temp["day"] as? Double{
                let rawValue=(dayTemp-273.15).rounded(toPlaces: 0)
                self._temp=rawValue
            }
        }
        
        if let pressure=weatherDict["pressure"] as? Double
        {
            let rawValue=(pressure)
            self._pressure=rawValue
        }

        if let humidity=weatherDict["humidity"] as? Double
        {
            let rawValue=(humidity)
            self._humidity=rawValue
        }
        
        if let date=weatherDict["dt"] as? Double{
    
            let rawDate=Date(timeIntervalSince1970: date)
            let dateFormatter=DateFormatter()
            dateFormatter.dateStyle = .medium
            
            self._date="\(rawDate.dayOfTheWeek())"
        }
    }
    
    
}
