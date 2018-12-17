//
//  CityCell.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    var model: SearchCityModel? {
        didSet { textLabel?.text = model?.name }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = UIColor.weatherWhite
        backgroundColor = UIColor.weatherBlack
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
