//
//  EnsembleViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import CoreData
import SwiftUI

class EnsembleViewModel: ObservableObject {
//    @Published var groups: [Ensemble]
//
//    @Environment(\.managedObjectContext) var moc
//
//    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Ensemble>
    
    @Published private var dataManager: DataManager
    @Published var isAuthenticating = false
    @Published var chosenName = ""

    
    var groups: [Ensemble] {
        dataManager.ensembles()
    }
    
    
    init(dataManager: DataManager = DataManager.shared) {
//        self.groups = []
        self.dataManager = dataManager
    }
    

//    func createEnsemble(for name: String) {
//        let _ = DataManager.shared.ensemble(name: name)
//        DataManager.shared.save()
//    }
    
    func toggleAuthenticating() {
        isAuthenticating = !isAuthenticating
    }
    
    func createEnsemble() {
        guard !(chosenName.isEmpty) else { return }
        dataManager.createEnsemble(for: chosenName)
        chosenName = ""
    }
    
//    func createEnsemble(for name: String) {
//        dataManager.createEnsemble(for: name)
////        loadEnsembleList()
//    }
    
    func loadEnsembleList() -> [Ensemble] {
        return dataManager.ensembles()
//        self.groups = dataManager.ensembles()
//        DataManager.shared.ensembles()
    }
    
    // ? - why delete from a set of indices than one index?
    func removeEnsemble(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
//        let groups = loadEnsembleList() // is this even necessary
        for index in offsets {
            let group = groups[index]
            DataManager.shared.deleteEnsemble(ensemble: group)
        }
    }
}
