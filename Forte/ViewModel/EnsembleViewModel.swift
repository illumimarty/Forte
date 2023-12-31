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

    @Published private var dataManager: DataManager
    @Published var isAuthenticating = false
    @Published var chosenName = ""

    
    var groups: [Ensemble] {
        get { dataManager.ensembles() }
        set {}
    }
    
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func toggleAuthenticating() {
        isAuthenticating = !isAuthenticating
    }
    
    func createEnsemble() {
        guard !(chosenName.isEmpty) else { return }
        dataManager.createEnsemble(for: chosenName)
        chosenName = ""
    }
    
    func loadEnsembleList() -> [Ensemble] {
        return dataManager.ensembles()
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
