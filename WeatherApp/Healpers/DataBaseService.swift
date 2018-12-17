//
//  Constants.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import CoreData

final class DataBaseService {
    static let shared = DataBaseService()
    private init() {}
    
   private let appDelegate = UIApplication.shared.delegate as! AppDelegate
   private lazy var context = appDelegate.persistentContainer.viewContext
    
    //MARK: Clear All!
    func clearDataInEntity(_ entityName: EntityName) {

            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
                let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                
                for i in objects! {
                    context.delete(i)
                }
                try context.save()
            } catch let err { print(err) }
        
    }
    
    //MARK: Contains
//    func isUniqeName(entityName: String, uidName: String , uid: String) -> Bool {
//
//        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        myRequest.predicate = NSPredicate(format: "\(uidName) = %@", uid)
//
//        do {
//            let results = try context.fetch(myRequest)
//             assert(results.count < 2)
//            if results.count > 0 {
//                return false
//            } else {
//                return true
//            }
//        } catch let error {
//            print(error)
//        }
//        return false
//    }
    
    //MARK: Featch
    func fetchCoreData(entityName: EntityName) -> Any? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        do {
            let results = try context.fetch(fetchRequest)
            if let objectArray = results as? [NSManagedObject] {
                return objectArray
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
//    func getDataBy(_ entityName: String, uidValueInCD: String, completion: @escaping ([String : Any]?) -> ()) {
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let predicate = NSPredicate(format: "\(uidValueInCD) = %@", uidValueInCD)
//        fetchRequest.predicate = predicate
//
//        do {
//            let profiles = try context.fetch(fetchRequest)
//            assert(profiles.count < 2) // we shouldn't have any duplicates in CD
//
//            if let objectArray = profiles.first as? NSManagedObject  {
//                completion(convertToJSONArray([objectArray])?.first)
//            } else {
//                // no local cache
//            }
//        } catch let error {
//            print(error)
//        }
//    }
    
    //MARK: SaveValueForKeys
    func saveSelectCity(_ city: SearchCityModel, forEntityName: EntityName) {

        if let object = NSEntityDescription.insertNewObject(forEntityName: forEntityName.rawValue, into: context) as? City {
            object.name = city.name
            object.lat = city.lat
            object.lng = city.lng
            object.country = city.country
            appDelegate.saveContext()
        }
    }
}

//MARK: convertToJSONArray
extension DataBaseService {
    
//    private func convertToJSONArray(_ moArray: [NSManagedObject]) -> [[String: Any]]? {
//
//        if moArray.isEmpty { return nil }
//        var jsonArray: [[String: Any]] = []
//
//        for item in moArray {
//            var dict = [String: Any]()
//
//            for attribute in item.entity.attributesByName {
//                if let value = item.value(forKey: attribute.key) {
//                    dict[attribute.key] = value
//                }
//            }
//            jsonArray.append(dict)
//        }
//        return jsonArray
//    }
}
