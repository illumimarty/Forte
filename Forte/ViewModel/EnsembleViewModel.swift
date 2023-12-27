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
    @Published var groups: [Ensemble] = []
    
    func createEnsemble(for name: String) {
        let _ = DataManager.shared.ensemble(name: name)
        DataManager.shared.save()
    }
    
    func loadEnsembleList() {
        self.groups = DataManager.shared.ensembles()
    }
    
    // ? - why delete from a set of indices than one index?
    func removeEnsemble(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        
        for index in offsets {
            let group = groups[index]
            DataManager.shared.deleteEnsemble(ensemble: group)
        }
    }
}
