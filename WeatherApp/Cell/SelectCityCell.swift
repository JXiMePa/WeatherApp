//
//  SelectCityCell.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

protocol SelectCityCellProtocol {
    func deleate(_ indexPath: IndexPath?)
}

final class SelectCityCell: UICollectionViewCell {
    
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var citiesNameLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var deleateButton: UIButton!
    
    var delegate: SelectCityCellProtocol?
    var indexPath: IndexPath?
    
    var model: CityModel? {
        didSet {
            
            switch model?.weather?.first?.icon  {
            case "01d", "01n":
                weatherImage.image = UIImage(named: "Weather3_Big")
            case "02d", "02n":
                weatherImage.image = UIImage(named: "Weather4_Big")
            case "03d", "03n", "04d", "04n":
                weatherImage.image = UIImage(named: "Weather1_Big")
            case "10d", "10n","11d", "11n", "13d", "13n":
                weatherImage.image = UIImage(named: "Weather5_Big")
            case "50d", "50n":
                weatherImage.image = UIImage(named: "Weather6_Big")?.withRenderingMode(.alwaysTemplate)
                weatherImage.tintColor = .white
            default: break
            }
            
            citiesNameLabel.text = model?.name
            
            if let min = model?.main?.temp_min, let max = model?.main?.temp_max {
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
    
    
   private func convertToCelsius(_ fahrenheit: Double?) -> Int {
    guard let `fahrenheit` = fahrenheit else { return 0}
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}

