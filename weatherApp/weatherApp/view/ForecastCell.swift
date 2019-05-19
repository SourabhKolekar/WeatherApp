//
//  ForecastCell.swift
//  weatherApp
//
//  Created by Sourabh on 20/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    //outlets
    @IBOutlet weak var forecastDay: UILabel!
    @IBOutlet weak var forecastTemperature: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(forecastData: ForecastWeather)
    {
        self.forecastDay.text="\(forecastData.date)"
        
//        NSString(format:""\(Int(forecastData.temp))"%@", "\u{00B0}")
//        self.forecastTemperature.text="\(Int(forecastData.temp))"
        self.forecastTemperature.text="\(Int(forecastData.temp))"
        
    }

}
