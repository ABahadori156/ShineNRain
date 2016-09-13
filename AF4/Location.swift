//
//  Location.swift
//  AF4
//
//  Created by Pasha Bahadori on 9/12/16.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    //A static variable can be accessed anywhere throughout the app, like accessible globally
    static var sharedInstance = Location()
    private init() {}
    
    //Inside of a location we only need two things: A longitude and a latitude
    //When CLLocation is pulling our device location, it's going to pull it in as CLLocation Degrees which is equal to a double
    var latitude: Double!
    var longitude: Double!
}
