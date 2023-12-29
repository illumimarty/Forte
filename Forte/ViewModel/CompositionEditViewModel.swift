//
//  CompositionEditViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 12/26/23.
//

import Foundation
import SwiftUI

struct CompositionEditState: Equatable {
    var ensemble: Ensemble?
    var name: String = ""
    var composer: String = ""
    var recording_link: String = ""
//    internal var isInitializing: Bool = false
    
    init(for group: Ensemble?) {
        if let unwrappedGroup = group {
            self.ensemble = unwrappedGroup
        }
    }
    
//    init(pieceName: String, composerName: String, recordingLink: String, isInitializing: Bool) {
//        self.pieceName = pieceName
//        self.composerName = composerName
//        self.recordingLink = recordingLink
//        self.isInitializing = isInitializing
//    }
}

//class CompositionEditViewModel: ObservableObject {
//    
//    @Published private var dataManager: DataManager
//
//    init(dataManager: DataManager = DataManager.shared) {
//        self.dataManager = dataManager
//    }
//    
//}
//
final class CompositionEditViewModel: StateBindingViewModel<CompositionEditState> {

    @Published private var dataManager: DataManager
    
    init (
        initialState: CompositionEditState,
        dataManager: DataManager = DataManager.shared) {
            self.dataManager = dataManager
            super.init(initialState: initialState)
    }
    
    func createComposition() {
        
        // TODO: Add data validation for creating a composition
        
        let newComp = dataManager.createPiece(for: self.state.ensemble!)
        
        let mirror = Mirror(reflecting: self.state)
        for (compProp, compVal) in mirror.children {
//            if let keyPath = \CompositionEditState[keyPath: prop!] {
//                newGroup[keyPath: prop] = val
//            }
            newComp.setValue(compVal, forKeyPath: compProp!)
        }
        dataManager.save()
//        dataManager.createPiece(newComp, for: state.ensemble!)
//        dataManager.createPiece(for: newGroup)
        
//        let piece = DataManager.shared.piece(ensemble: self.state.ensemble!)
//        piece.name = self.state.pieceName
//        piece.composer = self.state.composerName
//        piece.recording_link = self.state.recordingLink
//        DataManager.shared.save()
    }
}
