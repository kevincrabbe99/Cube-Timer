//
//  Persistance.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import CoreData

struct PersistanceController {
    static let shared = PersistanceController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Cube_Timer")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
}
