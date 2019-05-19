//
//  DetailsViewController.swift
//  weatherApp
//
//  Created by Sourabh on 20/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    //variables
    var weatherDetails: ForecastWeather?
    
    //outlets
    
    @IBOutlet weak var dayOftheWeekLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dayOftheWeekLabel.text="\((weatherDetails?.date)!)"
        self.temperatureLabel.text="\((weatherDetails?.temp)!)"+"\u{00B0}"+"C"
        self.humidityLabel.text="\((weatherDetails?.humidity)!)"+"%"
        self.pressureLabel.text="\((weatherDetails?.pressure)!)"+"hpa"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
