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
    
//    init(section: Passage) {
//        self.passageName = section.name!
//        self.passageNotes = section.notes ?? ""
////        self.personalNotes = personalNotes
//        self.startRehearsalMark = section.startRehearsalMark ?? ""
//        self.endRehearsalMark = section.endRehearsalMark ?? ""
//        self.startMeasureNumber = String(describing: section.startMeasure) 
//        self.endMeasureNumber = String(describing: section.endMeasure)
//    }
}


//class SectionEditViewModel: ObservableObject {
//    
//    @Published var state: SectionEditState
////    @Published var section: Passage?
//    @State var isInitializing: Bool = false
//    @State var isPresenting: Bool = false
//    
////    init(section: Passage?, isInitializing: Bool = true, isPresenting: Bool = true) {
//////        if let unwrappedSection = section {
//////            self.section = unwrappedSection
//////        }
////    }
//    
////    init(section: Passage) {
////        self.state = SectionEditState(section: section)
////    }
//}

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
//    @State var isInitializing: Bool = false
//    @State var isPresenting: Bool = false
    
//    init(isInitializing: Bool, piece: Composition? = nil) {
//        if isInitializing {
//            self.isInitializing = isInitializing
//            self.isPresenting = true
////            self.initialState
//        }
//    }
}
