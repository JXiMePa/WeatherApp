//
//  CityModel.swift
//  WeatherApp
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import Foundation

struct SearchCityModel: Decodable {
    let name: String?
    let lng: String?
    let lat: String?
    let country: String?
    
    init(name: String?, country: String?, lat: String?, lng: String?) {
        self.name = name
        self.country = country
        self.lat = lat
        self.lng = lng
    }
}

struct CityModel: Decodable {
    
    let name: String?
    let coord: Location?
    let weather: [Weather]?
    let base: String?
    let main: Geodata?
    let clouds: Clouds?
    let wind: Wind?
    let dt: Double?
    let sys: Sys?
    let id: Int?
}

struct Location: Codable {
    let lon: Double?
    let lat: Double?
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Clouds: Decodable  {
    let all: Int?
}

struct Geodata: Decodable {
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
    let temp_min: Double?
    let temp_max: Double?
    let sea_level: Double?
    let grnd_level: Double?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Double?
}

struct Sys: Decodable {
    let message: Double?
    let country: String?
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}
