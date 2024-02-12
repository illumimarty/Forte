//
//  EnsembleViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class EnsembleViewModel: ObservableObject {

    @Published private var dataManager: DataManager
    @Published var isAuthenticating = false
    @Published var chosenName = ""

    var groups = [Ensemble]()
	var anyCancellable: AnyCancellable?
	
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.groups = dataManager.ensembles()
		
		anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
			dataManager.objectWillChange.send()
		}
    }
    
    func toggleAuthenticating() {
        isAuthenticating = !isAuthenticating
    }
    
    func createEnsemble() {
        guard !(chosenName.isEmpty) else { return }
        dataManager.createEnsemble(for: chosenName)
        self.loadEnsembleList()
        chosenName = ""
    }
    
    func loadEnsembleList() {
		objectWillChange.send()
        self.groups = dataManager.ensembles()
    }
    
    // ? - why delete from a set of indices than one index?
    func removeEnsemble(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        for index in offsets {
            let group = groups[index]
            dataManager.deleteEnsemble(ensemble: group)
        }
        groups.remove(atOffsets: offsets)
    }
}

extension Dictionary where Key == AnyHashable {
    func value<T>(for key: NSManagedObjectContext.NotificationKey) -> T? {
        return key.rawValue as? T
    }
}

extension Notification {
    var insertedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .insertedObjects)
    }
    
    var updatedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .updatedObjects)
    }
}
