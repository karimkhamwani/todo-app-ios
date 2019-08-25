//
//  CoreDataStack.swift
//  TodoApplication
//
//  Created by Karim on 25/08/2019.
//  Copyright © 2019 Karim. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedContext : NSManagedObjectContext{
        return persistentContainer.viewContext;
    }
}
