//
//  SearchCityViewController.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


final class SearchCityViewController: UIViewController {
    
    @IBOutlet private weak var cityTableView: UITableView!
    @IBOutlet private weak var spiner: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let asciiUppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    private var arrayCharacters : [Character] {
        get {
            return asciiUppercase.compactMap { $0 }
        }
    }
    
    private var cities = [[SearchCityModel]]() {
        didSet {
            cityTableView.reloadData()
            searchCities = cities
        }
    }
    
    private var searchCities = [[SearchCityModel]]() {
        didSet {
            cityTableView.reloadData()
        }
    }

    private var cityArray: [SearchCityModel] = [] {
        didSet {
            cities = self.sort(cityArray)
        }
    }
    
    private var searchСities = [CityModel]()
    
    weak var delegat: SelectCityProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getCities()
    }
    
    private func getCurentArray() -> [[SearchCityModel]] {
        
        return searchCities.isEmpty ? cities : searchCities
    }
    
    private func getFirstCharIndex(_ char: Character?) -> Int? {
        
        guard let unwrapChar = char else { return nil }
        
        for (index, asciiChar) in asciiUppercase.enumerated() {
            if Character(String(unwrapChar).uppercased()) == asciiChar {
                return index
            }
        }
        return nil
    }
    
    private func sort(_ array: [SearchCityModel]) -> [[SearchCityModel]] {
        
        var sortedArray = [[SearchCityModel]]()

        for char in arrayCharacters {
            sortedArray.append(array.filter { Character(String($0.name!.first!).uppercased()) == char })
        }
        return sortedArray
    }
    
    private func addToCities(_ array: [SearchCityModel]) {
        
        for char in arrayCharacters {
            cities.append(array.filter { Character(String($0.name!.first!).uppercased()) == char })
        }
    }
    
    private func setupViews() {
        
        view.backgroundColor = UIColor.weatherGrayBlack
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
    
    private func endOfSearch() {
        
        searchСities.removeAll()
        cityTableView?.reloadData()
    }

    private func getCities() {
        
        spiner.startAnimating()
        
        DispatchQueue.main.async {
            if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
                    self.cityArray = try JSONDecoder().decode([SearchCityModel].self, from: data)
                    self.spiner.stopAnimating()
                } catch let error {
                    print(error)
                }
            }
        }
    }
}


extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let curentCity = getCurentArray()[indexPath.section][indexPath.row]
        delegat.add(curentCity)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.weatherGrayBlack
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = asciiUppercase.index(asciiUppercase.startIndex, offsetBy: section)
        return String(asciiUppercase[index])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return asciiUppercase.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = cities.count > 0 ? cities[section].count : 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as! CityCell
        let curentModelArray = getCurentArray().count > 0 ? getCurentArray()[indexPath.section]: nil
        
        if let model = curentModelArray {
        cell.model = model[indexPath.row]
        }
        return cell
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let index = getFirstCharIndex(searchText.first) {
        searchCities = [cities[index]]
        } else {
            searchCities.removeAll()
        }
        
    }
    
    
}
