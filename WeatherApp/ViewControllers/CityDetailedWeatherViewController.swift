//
//  CityDetailedWeatherViewController.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

final class CityDetailedWeatherViewController: UIViewController {

    @IBOutlet private weak var weatherImageView: IconImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var windowLabel: UILabel!
    @IBOutlet private weak var rainLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var weaksWeatherCollectionView: UICollectionView!

    var city: CityModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCell()
    }

    //MARK: Func
    private func registerCell() {
        weaksWeatherCollectionView.register(UINib(nibName: DetailsWeatherCell.identifier, bundle: nil), forCellWithReuseIdentifier: DetailsWeatherCell.identifier)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.weatherGrayBlack
        navigationController?.navigationBar.topItem?.title = city?.name
        
        if let temp = city?.main?.temp {
        tempLabel.text = temp.fromKelvinToCelsius() + " °C"
        }
        if let speed = city?.wind?.speed {
        windowLabel.text = String(speed)
        }
        if let rain = city?.clouds?.all {
        rainLabel.text = String(rain)
        }
        if let humidity = city?.main?.humidity {
        humidityLabel.text = String(humidity)
        }
        weatherImageView.iconId = city?.weather?.first?.icon
    }
}

extension CityDetailedWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item) //TODO: !?
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return city?.weather?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weaksWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: DetailsWeatherCell.identifier, for: indexPath) as! DetailsWeatherCell
            cell.weather = city?.weather?[indexPath.item]
        return cell
    }
}
