//
//  Forecast.swift
//  AF4
//
//  Created by Pasha Bahadori on 9/12/16.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    //Using data encapsulation to declare the properties
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    //Safety functions so if one of the above properties come as nil, then our app won't crash because of the safety functions
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    // Here we'll create an initializer that will pull the data that we downloaded into our Forecast class and then it's going to run it through and set all those values so that we can set it in our user interface
    // Now we'll parse through just like we did when we downloaded inside of our current weather API request
    init(weatherDict: Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            
            // LOW TEMPERATURE
            if let min = temp["min"] as? Double {
                
                let kelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._lowTemp = "\(kelvinToFarenheit)"
            }
            
            // HIGH TEMPERATURE
            if let max = temp["max"] as? Double {
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._highTemp = "\(kelvinToFarenheit)"
            }
        }
           //Next is Weather which is an array, which is inside List array so we have t access it differently, we do it outside temp
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        //DATE OF THE DAY OF FORECAST
        if let date = weatherDict["dt"] as? Double {
            //We need to conver the Unix TimeStamp from the JSON value of "dt"
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
            
        }
        
    }
   
}

//Extensions are made outside of the class brackets
// DAY OF THE WEEK - We need to create this extension to set the dates for the forecast days
extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"   //EEEE is the code that says I want the day of the week
        return dateFormatter.string(from: self)
    }
}












