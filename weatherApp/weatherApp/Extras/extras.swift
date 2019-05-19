//
//  extras.swift
//  weatherApp
//
//  Created by Sourabh.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation

let currentWeather_API_URL="https://api.openweathermap.org/data/2.5/weather?lat=-37.81&lon=144.96&appid=b1c7bd83b1ca43dc4ffea507d5aea544"

let weatherForecast_API_URL="https://api.openweathermap.org/data/2.5/forecast/daily?lat=-37.814&lon=144.96332&cnt=10&appid=b1c7bd83b1ca43dc4ffea507d5aea544"


typealias downloadCompletionHandler = ()-> ()
