//
//  Constants.swift
//  AF4
//
//  Created by Pasha Bahadori on 9/11/16.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import Foundation

// We need to think about how we're going to store the URL from the JSON data because we need to put inside information inside this URL but it kind of needs to go in a weird spot. 
// http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=6b2c6b22f86d2a29d46708c654a02602

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"

let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "6b2c6b22f86d2a29d46708c654a02602"

//A type alias - This will tell our function when we are finished downloading data from the web
typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=6b2c6b22f86d2a29d46708c654a02602"


// http://api.openweathermap.org/data/2.5/forecast/daily?lat=-36&lon=123&cnt=10&mode=json&appid=6b2c6b22f86d2a29d46708c654a02602

let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=6b2c6b22f86d2a29d46708c654a02602"
