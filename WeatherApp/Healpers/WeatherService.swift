//
//  WeatherController.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import CoreLocation

enum WeatherError: Error {
    case requestFailed
    case noData
    case serializationFailed
    case parsingFailed
}

enum WeatherResult {
    case success(CityModel)
    case failure(WeatherError)
}

class WeatherService {
    static let shared = WeatherService()
    fileprivate init() {}
    
    let session = URLSession.shared
    
    fileprivate let APIKey = "b46cd2a1f1e4ae6a6dc84609decf43a8"
    fileprivate let baseURLPath = "http://api.openweathermap.org/data/2.5/weather?"
    
    typealias WeatherCompletion = (WeatherResult) -> Void
    
    private func weatherURL(for coordinate: CLLocationCoordinate2D) -> URL {
        
        let URLPath = baseURLPath + "lat=\(coordinate.latitude)" + "&lon=\(coordinate.longitude)" + "&appid=\(APIKey)"
        return URL(string: URLPath)!
    }
    
    func weather(coordinate: CLLocationCoordinate2D, completion: @escaping WeatherCompletion) {
        
        session.dataTask(with: weatherURL(for: coordinate)) { data, URLResponse, requestError in
            
            guard let data = data else {
                
                if let _ = requestError {
                    completion(.failure(.requestFailed))
                    
                } else {
                    print("WeatherController: data is nil, but there is no error!")
                }
                return
            }
            
            do {
                let weatherResult = try JSONDecoder().decode(CityModel.self, from: data)
                completion(.success(weatherResult))
                
            } catch {
                completion(.failure(.serializationFailed))
            }
            }.resume()
    }
}
