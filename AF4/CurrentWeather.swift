//
//  CurrentWeather.swift
//  AF4
//
//  Created by Pasha Bahadori on 9/11/16.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    // We're going to use data hiding and it limits who can access these variables. Only the download function can access these variables and only in this file they can access it
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    //Here is how we do data hiding/data encapsulation. the var: _cityName and var city cityName are two different variables
    //Below is another way to ensure your code is safe
    var cityName: String {
        //If the API data of cityName doesn't contain anything, we'll set the cityName in our class to an empty string
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        // We're going to give it a date and time style
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _cityName
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    //Function to download weather data from server - We give it a parameter of typealias 'DownloadComplete' so to tell the function to stop downloading the web data after we've retrieved it once
    func downloadWeatherDetails(completed: DownloadComplete) {
        //Here we will initialize the URL to tell Alamofire where to download from
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!   //WE force-unwrap it to prove that the CURRENT_WEATHER_URL is NOT nil
        
        //We want to pass that request into a response by putting it in closure format. We're basically saying that after we request the data, we're going to give it a response then we need to know what the actual result is.
        Alamofire.request(currentWeatherURL, method: .get).responseJSON { response in
            let result = response.result    //Every request has a response and every response has a result. Here we saved the JSON that we want
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                //We'll look for the key for the dictionary we want
                
                //GRABBING CITYNAME from key "name"
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized  //Makes the first letter of the string capitalized
                    print(self._cityName)
                }
                
                //GRABBING WEATHERTYPE from "weather" array
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    //*The [0] is the first dictionary of the 'weather' array */
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                
                //GRABBING CURRENTTEMP from "main" dictionary
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        // The temp comes in Kelvin so we need to conver it to Fahrenheit
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        
                            self._currentTemp = kelvinToFarenheit
                            print(self._currentTemp)
                        }
                    }
                }
            }
            completed() //This is the function we created to tell this function to be done
            //What format we want our results to be in
            
       
        }
        
        
        
        
        
        
    }
