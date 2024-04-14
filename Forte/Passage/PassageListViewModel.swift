//
//  PassageListViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import Combine
import SwiftUI

class PassageListViewModel: ObservableObject {
    
    @Published private var dataManager: DataManager
	@Published var passages: [PassageRowViewModel] = []
	@Published var chosenName = ""
	@Published var isShowingEditView: Bool = false
	@Published var isInitializingSection: Bool = false
	@Published var editMode: EditMode = .inactive

    var piece: Composition
    
    init(for piece: Composition, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.piece = piece
		getPassages()
    }
    
    func getPassages() {
        self.passages = dataManager.passages(for: piece)
    }
    
    func addPassage(for piece: Composition) {
        let passage = DataManager.shared.passage(piece: piece)
        passages.append(passage)
		dataManager.save()
    }
    
    func removePassage(at offsets: IndexSet) {
        for index in offsets {
            let section = passages[index]
			section.deletePassage()
        }
        passages.remove(atOffsets: offsets)
    }
}
