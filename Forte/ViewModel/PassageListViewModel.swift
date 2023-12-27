//
//  PassageListViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation

class PassageListViewModel: ObservableObject {
    
    @Published var passages: [Passage]
    var piece: Composition
    
    init(piece: Composition) {
        self.piece = piece
        self.passages = DataManager.shared.passages(piece: piece)
    }
    
    func addPassage(for piece: Composition) {
        let passage = DataManager.shared.passage(piece: piece)
        passages.append(passage)
        DataManager.shared.save()
    }
    
    func removePassage(at offsets: IndexSet) {
        for index in offsets {
            let section = passages[index]
//            DataManager.shared.deleteSection(section: section)
            DataManager.shared.deletePassage(passage: section)
        }
    }
}
