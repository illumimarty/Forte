//
//  DataController.swift
//  Forte
//
//  Created by Marty Nodado on 10/8/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    static let shared = DataController()
    let container = NSPersistentContainer(name: "Ensemble")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
