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
import SQLite

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var placeTextField: UITextField!
    
    
    //variables and constants
    var locationArray=[Location]()
    var temperatureLocationArray=[Location]()
    var allTempLocArray=[Location]()

    
    //DB Info
    var db: Connection?

    let tblLocation = Table("location")
    let dbLocationName = Expression<String>("locationName")
    let dbLocationLatitude = Expression<Double>("latitude")
    let dbLocationLongitude = Expression<Double>("longitude")
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callDelegates()

        dbSetup()
        
        reloadDataFromDb()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func reloadDataFromDb()
    {
        let rowCount=dbSelectOperation()
        if(rowCount>0)
        {
            
            print ("data available in the database")
            
            //downloading weather data for the all information in database
            for loc in locationArray{
                downloadCurrentTemperatureData(latInfo: loc.latitude, longInfo: loc.longitude) {
                    print ("loop data download")
                }
            }
            self.favTableView.reloadData()
        }
        else
        {
            print ("database empty")
        }
    }
    
    func dbSelectOperation() -> Int
    {
        var count=0
        do{
        for location in try db!.prepare(tblLocation) {
            print("location: \(location[dbLocationName]), lat: \(location[dbLocationLatitude]), long: \(location[dbLocationLongitude])")
       
            let tempLocation = Location()
            tempLocation.locationName=location[dbLocationName]
            tempLocation.latitude=location[dbLocationLatitude]
            tempLocation.longitude=location[dbLocationLongitude]
            
            locationArray.append(tempLocation)
                count=count+1
            }
        }
        catch {
            print ("selection error: \(error)")
        }
    return count
    }
    
    func dbSetup()
    {
        let databaseFileName = "db.sqlite3"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
        db = try! Connection(databaseFilePath)

        
        try! db!.run(tblLocation.create(ifNotExists: true) { t in
            t.column(dbLocationName)
            t.column(dbLocationLatitude)
            t.column(dbLocationLongitude)
        })
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
    

    // function for downloading data from the api
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            //remove from db
            do {
                let deleteLocation=self.tblLocation.filter(self.dbLocationName==self.temperatureLocationArray[indexPath.row].locationName)
                if try self.db!.run(deleteLocation.delete()) > 0 {
                    print("deleted successfully")
                } else {
                    print("item for delete not found")
                }
            } catch {
                print("delete failed: \(error)")
            }
            
            //remove from index path
            self.temperatureLocationArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.temperatureLocationArray)
        }
        
        return [delete]
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
        
        //inserting data to the sqlite database
        do {
            let rowid = try db!.run(tblLocation.insert(or: .replace, dbLocationName <- place.name!,dbLocationLatitude <- place.coordinate.latitude, dbLocationLongitude <- place.coordinate.longitude))
            print("Row inserted successfully id: \(rowid)")
        } catch {
            print("insertion failed: \(error)")
        }

        
        
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
