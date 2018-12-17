//
//  SelectCityCell.swift
//  WeatherApp
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

protocol SelectCityCellProtocol {
    func deleate(_ indexPath: IndexPath?)
}

final class SelectCityCell: UICollectionViewCell {
    
    @IBOutlet private weak var weatherImage: IconImageView!
    @IBOutlet private weak var citiesNameLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var deleateButton: UIButton!
    
    var delegate: SelectCityCellProtocol?
    var indexPath: IndexPath?
    
    var model: CityModel? {
        didSet {
            
            weatherImage.iconId = model?.weather?.first?.icon
            citiesNameLabel.text = model?.name
            
            if let min = model?.main?.temp_min,
                let max = model?.main?.temp_max {
                tempLabel.text = "\(min.fromKelvinToCelsius())/ \(max.fromKelvinToCelsius())"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    @IBAction func deleateButtonAction(_ sender: UIButton) {
        delegate?.deleate(indexPath)
    }

   private func convertToCelsius(_ fahrenheit: Double?) -> Int? {
    guard let `fahrenheit` = fahrenheit else { return nil }
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}

