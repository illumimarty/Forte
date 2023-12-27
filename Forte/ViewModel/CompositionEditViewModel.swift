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
    var pieceName: String = ""
    var composerName: String = ""
    var recordingLink: String = ""
    internal var isInitializing: Bool = false
    
    init(group: Ensemble?) {
        if let unwrappedGroup = group {
            self.ensemble = unwrappedGroup
        }
    }
    
    init(pieceName: String, composerName: String, recordingLink: String, isInitializing: Bool) {
        self.pieceName = pieceName
        self.composerName = composerName
        self.recordingLink = recordingLink
        self.isInitializing = isInitializing
    }
}

final class CompositionEditViewModel: StateBindingViewModel<CompositionEditState> {
    
    func createComposition() {
        let piece = DataManager.shared.piece(ensemble: self.state.ensemble!)
        piece.name = self.state.pieceName
        piece.composer = self.state.composerName
        piece.recording_link = self.state.recordingLink
        DataManager.shared.save()
    }
}
