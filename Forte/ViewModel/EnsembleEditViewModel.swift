//
//  EnsembleEditViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 1/13/24.
//

import Foundation
import SwiftUI

struct EnsembleEditState: Equatable {
    var id: UUID?
    var name: String = ""
    var location: String = ""
    
    init(_ group: Ensemble?) {
        if let group = group {
            self.id = group.id
            self.name = group.name ?? ""
            self.location = group.location ?? ""
        }
    }
}

class EnsembleEditViewModel: StateBindingViewModel<EnsembleEditState> {
    @Published private var dataManager: DataManager
//    @State private var isInitializing: Bool = false
    
    init(initialState: EnsembleEditState, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        super.init(initialState: initialState)
    }
    
    func saveChanges() {
        dataManager.updateEnsemble(for: self.state)
    }
}
