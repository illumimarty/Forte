//
//  SectionEditViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/22/23.
//

import Foundation
import SwiftUI

struct SectionEditState: Equatable {
    var piece: Composition?
    var name: String = ""
    var notes: String = ""
//    var personalNotes: String
//    var startRehearsalMark: String = ""
//    var endRehearsalMark: String = ""
//    var startMeasureNumber: String = ""
//    var endMeasureNumber: String = ""
    
    init(for piece: Composition?) {
        if let unwrappedPiece = piece {
            self.piece = unwrappedPiece
        }
    }
}

final class SectionEditViewModel: StateBindingViewModel<SectionEditState> {
    
    @Published private var dataManager: DataManager
    
    init(
        initialState: SectionEditState,
        dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
            super.init(initialState: initialState)
    }
    
    func createPassage() {
        dataManager.createPassage(for: self.state)
    }
}
