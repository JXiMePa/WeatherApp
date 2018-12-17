//
//  IconImageView.swift
//  WeatherApp
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class IconImageView: UIImageView {

    var iconId: String? {
        didSet {
            switch iconId {
            case "01d", "01n":
                self.image = UIImage(named: "Weather3_Big")
            case "02d", "02n":
                self.image = UIImage(named: "Weather4_Big")
            case "03d", "03n", "04d", "04n":
                self.image = UIImage(named: "Weather1_Big")
            case "10d", "10n","11d", "11n", "13d", "13n":
                self.image = UIImage(named: "Weather5_Big")
            case "50d", "50n":
                self.image = UIImage(named: "Weather6_Big")?.withRenderingMode(.alwaysTemplate)
                self.tintColor = .white
            default: break
            }

        }
    }

}
