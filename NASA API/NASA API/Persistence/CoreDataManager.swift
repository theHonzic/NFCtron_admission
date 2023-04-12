//
//  CoreDataManager.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import CoreData
import Foundation

protocol CoreDataManaging {
    var persistentContainer: NSPersistentContainer { get set }
    var viewContext: NSManagedObjectContext { get }
}

final class CoreDataManager: CoreDataManaging {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No descriptions present")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data persistence container: \(error)")
            }
        }
        
        if let storeUrl = container.persistentStoreCoordinator.persistentStores.first?.url {
            Logger.log("Store location: \n\(storeUrl)", .info)
        }
        
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
}
