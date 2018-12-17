//
//  DeyWeatherCellCell.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

final class DetailsWeatherCell: UICollectionViewCell {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: IconImageView!
    
    var weather: Weather? {
        didSet {
            setValues()
        }
    }
    
    private func setValues() {
        descriptionLabel.text = weather?.main
        iconImageView.iconId = weather?.icon
    }

}
