//
//  CoreDataStack.swift
//  TechTrainer
//
//  Created by Mikael Olezeski on 8/4/17.
//  Copyright © 2017 Mikael Olezeski. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    // Mark: Properties
    fileprivate let modelName: String
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //lazy var entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: self.modelName,
                                //   in: self.mainContext)!
    
    
    // Mark: Initializer
    init(modelName: String) {
        self.modelName = modelName
    }
}

// MARK: Internal
extension CoreDataStack {
    
    func saveContext () {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
