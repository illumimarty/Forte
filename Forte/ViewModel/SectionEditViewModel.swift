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
    var startMeasure: Int16 = 0
    var endMeasure: Int16 = 0
    var progressValue: Int16 = 0
    
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
    @State private var isInitializing: Bool = false
    @Published var progressValue: Double = 0
    @Published var startMeasure: Int = 0
    @Published var endMeasure: Int = 0
    private var progressIntValue: Int16 {
        return Int16(progressValue * 100)
    }
    
    init (
        initialState: SectionEditState,
        dataManager: DataManager = DataManager.shared, isInitializing: Bool = false) {
        self.dataManager = dataManager
        self.isInitializing = isInitializing
        
//        if isInitializing {
//            self.progressValue = 0
//            self.startMeasure =
//        }
            
        self.progressValue = Double(initialState.progressValue) / 100
        
        self.startMeasure = Int(initialState.startMeasure)
        self.endMeasure = Int(initialState.endMeasure)

        super.init(initialState: initialState)
    }
    
    func checkIsInitializing() -> Bool {
        return self.isInitializing
    }
    
    func translateNumberToState(for num: Double) {
        let value = doubleToInt(for: self.progressValue)
        self.update(\.progressValue, to: value)
        self.onStateChange(\.progressValue)
    }
    
    func doubleToInt(for number: Double) -> Int16 {
        return Int16(number * 100)
    }
    
    func createPassage() {
        let newId = UUID()
        self.update(\.id, to: newId)
        dataManager.createPassage(for: self.state)
    }
    
    func saveChanges() {
        
        // MARK: Change numeric values to CoreData preferred type
        
        self.update(\.progressValue, to: Int16(self.progressIntValue))
        self.update(\.startMeasure, to: Int16(self.startMeasure))
        self.update(\.endMeasure, to: Int16(self.endMeasure))
        
        if !isInitializing {
            dataManager.updatePassage(for: self.state)
        } else {
            createPassage()
        }
    }
}
