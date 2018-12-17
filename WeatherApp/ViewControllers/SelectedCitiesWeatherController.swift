//
//  ViewController.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectCityProtocol: class {
    func add(_ model: SearchCityModel)
}

final class SelectedCitiesWeatherController: UIViewController {
    
    @IBOutlet private weak var selectedCitiesCollectionView: UICollectionView!
    @IBOutlet private weak var spiner: UIActivityIndicatorView!
    
    var cities: [CityModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getCitiesFromCD()
        setupViews()
    }
    
    //MARK: Func
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SearchCityViewController {
            controller.delegat = self
        }
    }
    
    private func getCitiesFromCD() {
        guard let cities = DataBaseService.shared.fetchCoreData(entityName: .city) as? [City] else { return }
        for city in cities {
            let model = SearchCityModel(name: city.name, country: city.country, lat: city.lat, lng: city.lng)
            setWeatherValuesFrom(model)
        }
    }

    private func setWeatherValuesFrom(_ model: SearchCityModel) {
        guard let lat = Double(model.lat ?? ""),
            let lon = Double(model.lng ?? "") else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        WeatherService.shared.weather(coordinate: coordinate, completion: { [weak self] weatherResult in
            
            switch weatherResult {
            case .success(let model): self?.cities.append(model)
            case .failure(let error): print("error: \(error)")
            }
            
            DispatchQueue.main.async {
                self?.selectedCitiesCollectionView.reloadData()
                self?.spiner.stopAnimating()
            }
        })
    }
    
   private func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.weatherGrayBlack
        spiner.startAnimating()
        if !isAppAlreadyLaunchedOnce() {
            let kiev = SearchCityModel(name: nil, country: nil,
                                        lat: String(ConstantValues.DefaultCityLocation.kiev.lat!),
                                        lng: String(ConstantValues.DefaultCityLocation.kiev.lon!))
            setWeatherValuesFrom(kiev)
            let oddesa = SearchCityModel(name: nil, country: nil,
                                         lat: String(ConstantValues.DefaultCityLocation.odessa.lat!),
                                         lng: String(ConstantValues.DefaultCityLocation.odessa.lon!))
            setWeatherValuesFrom(oddesa)
        }
    }
}

extension SelectedCitiesWeatherController: UIGestureRecognizerDelegate {}

extension SelectedCitiesWeatherController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = CityDetailedWeatherViewController.instance()
        navigationController?.pushViewController(detailsVC, animated: true)
        detailsVC.city = cities[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedCitiesCollectionView.dequeueReusableCell(withReuseIdentifier: SelectCityCell.identifier, for: indexPath) as! SelectCityCell
        cell.backgroundColor = UIColor.weatherWhite.withAlphaComponent(0.05)
        cell.model = cities[indexPath.item]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = view.frame.width / 3 - 10
        return CGSize(width: cellSize, height: cellSize)
    }
}

extension SelectedCitiesWeatherController: SelectCityProtocol {
    
    func add(_ model: SearchCityModel) {
        setWeatherValuesFrom(model)
        DataBaseService.shared.saveSelectCity(model, forEntityName: .city)
    }

}

extension SelectedCitiesWeatherController: SelectCityCellProtocol {
    
    func deleate(_ indexPath: IndexPath?) {
        if let index = indexPath?.item {
            DataBaseService.shared.clearAtIndex(index, entityNames: .city)
            cities.remove(at: index)
            selectedCitiesCollectionView.reloadData()
        }
    }
}
