//
//  FavoritesViewController.swift
//  weatherApp
//
//  Created by Sourabh on 23/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var placeTextField: UITextField!
    
    
    //variables
    var locationArray=[Location]()
    
    var temperatureLocationArray=[Location]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callDelegates()
    }
    
    func callDelegates()
    {
        favTableView.delegate=self
        favTableView.dataSource=self
    }
    
    
    // Present the Autocomplete view controller when the textField is tapped.
    @IBAction func textFieldTapped(_ sender: Any) {
        placeTextField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    
    func downloadCurrentTemperatureDataForAll(completed: @escaping downloadCompletionHandler)  {
        
        for item in locationArray{
 
            var city:String!
            var temp:Double!

            let currentWeather_API_URL="https://api.openweathermap.org/data/2.5/weather?lat=-\(item.latitude!)&lon=\(item.longitude!)&appid=b1c7bd83b1ca43dc4ffea507d5aea544"

            
            Alamofire.request(currentWeather_API_URL).responseJSON { (response) in
 
                //clearing array for storing new data
                self.temperatureLocationArray.removeAll()
                
                let result=response.result
                let json=JSON(result.value)
                city=json["name"].stringValue
                let downloadTemp=json["main"]["temp"].double
                temp = (downloadTemp!-273.15).rounded(toPlaces: 0)
                
                let tempLocation=Location()
                tempLocation.locationName=city
                tempLocation.temperature=temp
                
                //adding new information data to array
                self.temperatureLocationArray.append(tempLocation)
            }
        }
        
        self.favTableView.reloadData()
        completed()
    }
    
    
    func downloadCurrentTemperatureData(latInfo:Double!,longInfo:Double!, completed: @escaping downloadCompletionHandler)  {
        
        print ("before downlaod lat: \(latInfo!) long:\(longInfo!)")
            var city:String!
            var temp:Double!
            
            let currentWeather_API_URL_L="https://api.openweathermap.org/data/2.5/weather?lat=\(latInfo!)&lon=\(longInfo!)&appid=b1c7bd83b1ca43dc4ffea507d5aea544"
            
        print(currentWeather_API_URL_L)
        
            Alamofire.request(currentWeather_API_URL_L).responseJSON { (response) in
                
                let result=response.result
                let json=JSON(result.value)
                city=json["name"].stringValue
                let downloadTemp=json["main"]["temp"].double
                temp = (downloadTemp!-273.15).rounded(toPlaces: 0)
                
                let tempLocation=Location()
                tempLocation.locationName=city
                tempLocation.temperature=temp
                self.temperatureLocationArray.append(tempLocation)
            
        
                for item in self.temperatureLocationArray {
                    print ("place: \(item.locationName!)")
                    print ("temperature: \(item.temperature!)")
                }

        
                self.favTableView.reloadData()
        completed()
        }
    }


}

extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource
{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=favTableView.dequeueReusableCell(withIdentifier: "locationCell") as! FavoriteCell
        cell.configureFavCell(locationData:temperatureLocationArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureLocationArray.count
    }
}



extension FavoritesViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        placeTextField.text = place.name
        
        
        let location=Location()

        location.locationName=place.name
        location.latitude=place.coordinate.latitude
        location.longitude=place.coordinate.longitude
        
        self.locationArray.append(location)         //adding new location to the location array
        self.placeTextField.text=""                 //clearing place text field
        
        
        downloadCurrentTemperatureData(latInfo: place.coordinate.latitude,longInfo: place.coordinate.longitude){
            print("data downlaoded")
        }
        
        
//        self.favTableView.reloadData()              // reloading tableview
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
