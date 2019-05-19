//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Sourabh on 20/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit
import Alamofire

class WeatherViewController: UIViewController {

    //outlets
    @IBOutlet weak var tableview: UITableView!
    
    
    //variables
    var forecastWeather:ForecastWeather!
    var forecastArray = [ForecastWeather]()
    
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        callDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadForecastWeatherData {
            print("data downloaded")
        }
    }
    

    func callDelegates(){
        tableview.delegate=self
        tableview.dataSource=self
    }
    

    func downloadForecastWeatherData(completed: @escaping downloadCompletionHandler) {
        Alamofire.request(weatherForecast_API_URL).responseJSON { (response) in
            let result = response.result
            if let dictionary=result.value as? Dictionary<String,AnyObject>{
                if let list=dictionary["list"] as? [Dictionary<String,AnyObject>]{
                    for item in list {
                        let forecast = ForecastWeather(weatherDict: item)
                        self.forecastArray.append(forecast)
                    }
                    self.tableview.reloadData()
                }
            }
            completed()
        }
    }
    
}

extension WeatherViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastCell
        cell.configureCell(forecastData: forecastArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
}
