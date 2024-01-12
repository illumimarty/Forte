//
//  CompositionEditViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 12/26/23.
//

import Foundation
import SwiftUI
import Combine

struct CompositionEditState: Equatable {
    var ensemble: Ensemble?
    var name: String = ""
    var composer: String = ""
    var recordingLink: String = ""
    
    init(for group: Ensemble?) {
        if let unwrappedGroup = group {
            self.ensemble = unwrappedGroup
        }
    }
}

final class CompositionEditViewModel: StateBindingViewModel<CompositionEditState> {

    @Published private var dataManager: DataManager
    //    internal var isInitializing: Bool = false
    
    init (
        initialState: CompositionEditState,
        dataManager: DataManager = DataManager.shared) {
            self.dataManager = dataManager
            super.init(initialState: initialState)
    }
    
    func createComposition() {
        dataManager.createPiece(for: self.state)
    }
}
