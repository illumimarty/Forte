//
//  PassageListViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import Combine

class PassageListViewModel: ObservableObject {
    
    @Published private var dataManager: DataManager
    @Published var passages: [Passage]
    var piece: Composition
    var anyCancellable: AnyCancellable?

    init(for piece: Composition, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.piece = piece
        self.passages = dataManager.passages(for: piece)
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func getPassages() {
        self.passages = dataManager.passages(for: piece)
    }
    
    func addPassage(for piece: Composition) {
        let passage = DataManager.shared.passage(piece: piece)
        passages.append(passage)
        DataManager.shared.save()
    }
    
    func removePassage(at offsets: IndexSet) {
        for index in offsets {
            let section = passages[index]
            dataManager.deletePassage(passage: section)
        }
        passages.remove(atOffsets: offsets)
    }
}
