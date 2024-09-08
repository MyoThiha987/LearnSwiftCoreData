//
//  Persistence.swift
//  LearningCoreData
//
//  Created by Myo Thiha on 08/09/2024.
//

import CoreData

class CoreDataStack{
    static let shared : CoreDataStack = CoreDataStack()
    let persistanceContainer : NSPersistentContainer
    
    private init(){
        persistanceContainer = NSPersistentContainer(name: "TaskModel")
        persistanceContainer.loadPersistentStores { description, error in
            if let error = error{
                fatalError("Unable to initialize CoreData \(error) ")
            }
        }
    }
    
     
}
