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
    
    //Deleate
    func clearAtIndex(_ index: Int, entityNames: EntityName) {
        let delegate = UIApplication.shared.delegate as? AppDelegate

        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNames.rawValue)
                    var objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                    guard let count = objects?.count else { return }
                    guard count > index else { return }
                    if let obj = objects?.remove(at: index) {
                        context.delete(obj)
                    }
                
                try context.save()
            } catch let err { print(err) }
        }
    }
    
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
    
    //MARK: Save
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
