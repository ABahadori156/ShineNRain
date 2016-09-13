//
//  WeatherVC.swift
//  AF4
//
//  Created by Michael Teter on 2016-09-11.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    //variable to store our current location
    var currentLocation: CLLocation!
    
    
    var currentWeather = CurrentWeather()
    var forecast: Forecast!
    
    //This will be the array we store the forecasts in from the JSON.
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //LOCATION MANAGER SETUP
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   //Pinpoints your exact location
        locationManager.requestWhenInUseAuthorization()     //Only works when the app is active on the screen and in use
        locationManager.startMonitoringSignificantLocationChanges() //Tracks any significant GPS changes
        
        
        
       
    }
    
    //This will get our location before we run the download our Weather Data
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    //LOCATION MANAGER FUNCTION - Will check if we authorized to check location, if we haven't, it'll send a request to the user for their location
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //get current location and download the coordinates we want
            currentLocation = locationManager.location  //We're going to access this location and save it to our sharedInstance Singleton 'Location'
            
            //Now we set our Singleton 'Location's latitude and longitude to the LocationManager's instance currentLocation.coordinate.latitude & long
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            //This can only run now if we've actually downloaded our location and saved it to our Singleton class. This way we make sure we aren't going to have an nil longitude or latitude 
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization() //When it opens, if not authorized or for the first time, it'll give the request pop up
            locationAuthStatus()
        }
    }
    
    //FUNCTION TO GET FORECAST DATA
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
//        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(FORECAST_URL, method: .get).responseJSON { response in
            // Whatever response we get in JSON, we want to capture the raw data of that and we want to pass that in the dictionary
            let result = response.result
            
            //So whatever the result is equal to or what the value is, we'll cast it as a Swift dictionary object we can use
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    // We'll download the list of data once, then parse through using a For-Loop and it'll set the data individually
                    
                    for obj in list {
                        //Here we create a dictionary that will everytime we parse through and we find a dictionary in the list array, we're going to run this loop and pass in that dictionary into another dictionary - For every forecast we find, we're adding it to another dictionary in here so we can grab the data and manipulate it
                        //After we create a weather object pulling from this array, we put it in our global forecasts array - So this loo
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)    //here we remove today's forecast from our array
                    self.tableView.reloadData()
                    //After we downloaded it all, then we can reload the data and see if it pulls it in our tableView
                }
            }
             completed()
        }
       
    }
    

   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            //We need to tell this function which forecast to pass at which time - We're going to pull out 1 forecast from our forecasts array
            //For each cell that is created, this gets an indexPath - If the first cell is indexPath 0, it's going to pull out the dictionary for indexPath 0.
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
        
    }
    
    //Function to set the data to the UI
    func updateMainUI() {
        //This passes the data to the date
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
        
        
    }


}

