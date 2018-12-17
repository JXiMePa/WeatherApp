//
//  ConstantValues.swift
//  WeatherApp
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import CoreLocation

struct ConstantValues {
    
    struct DefaultCityLocation {
        static let kiev = Location(lat: 50.4547, lon: 30.5238)
        static let odessa = Location(lat: 46.469391, lon: 30.740883)
    }
}

enum EntityName: String {
    case city = "City"
}
