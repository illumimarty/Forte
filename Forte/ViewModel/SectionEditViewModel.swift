//
//  SectionEditViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/22/23.
//

import Foundation
import SwiftUI

struct SectionEditState: Equatable {
//    var section: Passage?
    var id: UUID?
    var piece: Composition?
    var name: String = ""
    var notes: String = ""
//    var personalNotes: String
    var startRehearsalMark: String = ""
    var endRehearsalMark: String = ""
    var startMeasure: Int16 = -1
    var endMeasure: Int16 = -1
    var progressValue: Int16 = -1
    
    init(_ section: Passage?) {
        if let section = section {
//            self.section = section
            self.id = section.id
            self.piece = section.piece
            self.name = section.name ?? ""
            self.notes = section.notes ?? ""
            self.startRehearsalMark = section.startRehearsalMark ?? ""
            self.endRehearsalMark = section.endRehearsalMark ?? ""
            self.startMeasure = section.startMeasure
            self.endMeasure = section.endMeasure
//            self.startMeasure = String(describing: section.startMeasure)
//            self.endMeasure = String(describing: endMeasure)
            self.progressValue = Int16(section.progressValue)
        }
    }
    
    init(for piece: Composition?) {
        if let unwrappedPiece = piece {
            self.piece = unwrappedPiece
        }
    }
}

final class SectionEditViewModel: StateBindingViewModel<SectionEditState> {
    
    @Published private var dataManager: DataManager
    @Published var progressValue: Double = 50
    @State private var isInitializing: Bool = false
    
    init (
        initialState: SectionEditState,
        dataManager: DataManager = DataManager.shared, isInitializing: Bool = false) {
            
            self.dataManager = dataManager
            self.isInitializing = isInitializing
            self.progressValue = Double(initialState.progressValue)
            super.init(initialState: initialState)
            
//            if !isInitializing {
//                super.init(initialState: initialState)
//            } else {
//                super.init(initialState: SectionEditState())
//            }
    }
    
    func translateNumberToState() {
        let value = doubleToInt(for: self.progressValue)
        self.update(\.progressValue, to: value)
        self.onStateChange(\.progressValue)
    }
    
    func doubleToInt(for number: Double) -> Int16 {
        return Int16(number)
    }
    
    func createPassage() {
        dataManager.createPassage(for: self.state)
    }
    
    func saveChanges() {
        if !isInitializing {
//            dataManager.save()
//            dataManager.updatePassage(self.state.section!, for: self.state)
            
            self.update(\.progressValue, to: Int16(self.progressValue))
            
            dataManager.updatePassage(for: self.state)
            
            return
        }
        createPassage()
    }
}
