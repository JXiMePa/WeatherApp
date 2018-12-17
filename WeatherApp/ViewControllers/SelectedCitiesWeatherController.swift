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
        guard let lat = Double(model.lat ?? ""), let lon = Double(model.lng ?? "") else { print("cord?"); return }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        WeatherService.shared.weather(coordinate: coordinate, completion: { weatherResult in
            switch weatherResult {
            case .success(let model): self.cities.append(model)
            case .failure(let error): print("error: \(error)")
            }
            
            DispatchQueue.main.async {
                self.selectedCitiesCollectionView.reloadData()
            }
        })
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.weatherGrayBlack
    }
    
    
} //end

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
            guard index < cities.count else { return }
            let city = cities[index]  //TODO: Deleate from CD!
            cities.remove(at: index)
            selectedCitiesCollectionView.reloadData()
        }
    }
}
