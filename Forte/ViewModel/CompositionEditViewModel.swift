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
    var id: UUID?
    var ensemble: Ensemble?
    var name: String = ""
    var composer: String = ""
    var recordingLink: String = ""
    
    init(_ piece: Composition?) {
        if let piece = piece {
            self.id = piece.id
            self.ensemble = piece.ensemble
            self.name = piece.name ?? ""
            self.composer = piece.composer ?? ""
            self.recordingLink = piece.recordingLink ?? ""
        }
    }
    
    init(for group: Ensemble?) {
        if let unwrappedGroup = group {
            self.ensemble = unwrappedGroup
        }
    }
}

final class CompositionEditViewModel: StateBindingViewModel<CompositionEditState> {

    @Published private var dataManager: DataManager
    @State private var isInitializing: Bool = false

    //    internal var isInitializing: Bool = false
    
    init (
        initialState: CompositionEditState,
        dataManager: DataManager = DataManager.shared, isInitializing: Bool = false) {
            self.dataManager = dataManager
            self.isInitializing = isInitializing
            super.init(initialState: initialState)
    }
    
    func createComposition() {
        let newId = UUID()
        self.update(\.id, to: newId)
        dataManager.createPiece(for: self.state)
    }
    
    func saveChanges() {
        if !isInitializing {
            dataManager.updatePiece(for: self.state)
        } else {
            createComposition()
//            createPassage()
        }
		objectWillChange.send()
    }
}
