//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Sourabh on 20/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    //outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var forecastDaysPickerText: UITextField!
    
    
    //constants

    let locationManager=CLLocationManager()
    let pickerViewOptions=["5","7","12","16"]
    
    
    //variables
    var forecastWeather:ForecastWeather!
    var forecastArray = [ForecastWeather]()
    var cityName=""
    var countryName=""
    var currentLocation:CLLocation!
    var selectedDays = "5"        // default value is 5
    
    var location=Location()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        callDelegates()
        setupLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        forecastArray.removeAll()
        createDaysPicker()
        createToolBar()
        locationAuthCheck()
        
    }
    

    func callDelegates(){
        tableview.delegate=self
        tableview.dataSource=self
        locationManager.delegate=self
    }
    
    func createDaysPicker()
    {
        let daysPicker=UIPickerView()
        daysPicker.delegate=self
        
        daysPicker.backgroundColor = .white
        forecastDaysPickerText.inputView = daysPicker
    }
    
    func createToolBar(){
        let toolBar=UIToolbar()
        toolBar.sizeToFit()
        
//        let doneButton=UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WeatherViewController.dismissKeyboard))
        let doneButton=UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction))

        
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled=true
        
        forecastDaysPickerText.inputAccessoryView=toolBar
    }
    
    
    @objc func doneButtonAction()
    {
        view.endEditing(true)
//        self.resignFirstResponder()
        
        self.forecastArray.removeAll()
        self.tableview.reloadData()
        locationAuthCheck()
    }
    
    
    func setupLocation()
    {
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()             // request location permission
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationAuthCheck()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //get the location from the device
            currentLocation=locationManager.location

            // pass location coordinates to API
            // todo uncomment later
//            Location.sharedInstance.latitude=currentLocation.coordinate.latitude
//            Location.sharedInstance.longitude=currentLocation.coordinate.longitude

            
            //todo comment later
            Location.sharedInstance.latitude = -37.814
            Location.sharedInstance.longitude = 144.96332

            
            print ("selected days \(selectedDays)")
            Location.sharedInstance.forecastDays=selectedDays

            print ("forecast days \(Location.sharedInstance.forecastDays)")
            
            
            
//            location.latitude=currentLocation.coordinate.latitude
//            location.longitude=currentLocation.coordinate.longitude
//
//            print ("selected days \(selectedDays)")
//            location.forecastDays=selectedDays
//
//            print ("forecast days \(location.forecastDays)")
            
            //download API Data
            downloadForecastWeatherData {
                print ("Data downloaded")
                self.cityCountryLabel.text=self.cityName + ", " + self.countryName
                
            }
        }
        else{ // user didn't allow
            locationManager.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    

    func downloadForecastWeatherData(completed: @escaping downloadCompletionHandler) {


        let weatherForecast_API_URL_Local="https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=\(selectedDays)&appid=b1c7bd83b1ca43dc4ffea507d5aea544"

        print(weatherForecast_API_URL)
        print("local \(weatherForecast_API_URL_Local)")

        //temporary fix for URL issue... visit later
        Alamofire.request(weatherForecast_API_URL_Local).responseJSON { (response) in

//            Alamofire.request(weatherForecast_API_URL).responseJSON { (response) in

            let result = response.result
//            print (result)
            let json=JSON(result.value)
            self.cityName=json["city"]["name"].stringValue
            self.countryName=json["city"]["country"].stringValue
            
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
    
    
    @IBAction func favoriteBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showFavorites", sender: self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
    
        performSegue(withIdentifier: "showdetails", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="showdetails"){
            if let destination = segue.destination as? DetailsViewController{
                destination.weatherDetails = forecastArray[(tableview.indexPathForSelectedRow?.row)!]
            }
        }
        else if (segue.identifier=="showFavorites")
        {
            var VC2 : FavoritesViewController = (segue.destination as? FavoritesViewController)!
            do {
                // pass data if any
            }
            
        }
        
        
    }
}

extension WeatherViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewOptions.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDays=pickerViewOptions[row]
        forecastDaysPickerText.text=selectedDays+" Days"
        
    }
    
}
