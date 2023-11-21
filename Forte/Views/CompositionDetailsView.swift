//
//  CompositionDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import SwiftUI

struct CompositionDetailsView: View {
    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects
    
    let ensemble: Ensemble
    let piece: Composition
    
//    @State private var isAuthenticating = false
    @State private var chosenName = ""
    @State private var isShowingEditView = false

    
    var passages: [Passage] = []
        
    // TODO: Remember to consider the user's groups/pieces since, if multiple users, will pull EVERYONE's data instead of only their own
    
    init(group: Ensemble, piece: Composition) {
        ensemble = group
        self.piece = piece
        passages = DataManager.shared.passages(piece: piece)
    }
    
    var body: some View {
        VStack {
            Button("Add") {
                isShowingEditView.toggle()
            }
            .sheet(isPresented: $isShowingEditView) {
                SectionEditView(piece: self.piece)
            }
//            .alert("Enter section name", isPresented: $isAuthenticating) {
//                TextField("A to B", text: $chosenName)
//                Button("OK", action: createSection)
//                Button("Cancel", role: .cancel) {}
//            }
            
            List {
                ForEach(passages, content: { section in
                    NavigationLink(destination: SectionEditView(piece: self.piece)) {
                        Text(section.name ?? "unknown passage")
                    }
                })
                .onDelete(perform: removeSection)
            }
            .toolbar {
                EditButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(piece.name ?? "unknown").font(.headline)
            }
        }
    }
    
    func createSection() {
//        let _ = DataManager.shared.section(name: chosenName, piece: self.piece)
        let _ = DataManager.shared.passage(piece: self.piece)
        DataManager.shared.save()
    }

    // ? - why delete from a set of indices than one index?
    func removeSection(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion

        for index in offsets {
            let section = passages[index]
//            DataManager.shared.deleteSection(section: section)
            DataManager.shared.deletePassage(passage: section)
        }
    }
}

