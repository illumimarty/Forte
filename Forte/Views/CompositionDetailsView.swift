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
    
    @State private var isAuthenticating = false
    @State private var chosenName = ""
    
    var sections: [Section] = []
        
    // TODO: Remember to consider the user's groups/pieces since, if multiple users, will pull EVERYONE's data instead of only their own
    
    init(group: Ensemble, piece: Composition) {
        ensemble = group
        self.piece = piece
        sections = DataManager.shared.sections(piece: piece)
    }
    
    var body: some View {
        VStack {
            Button("Add") {
                isAuthenticating.toggle()
            }
            .alert("Enter section name", isPresented: $isAuthenticating) {
                TextField("A to B", text: $chosenName)
                Button("OK", action: createSection)
                Button("Cancel", role: .cancel) {}
            }
            List {
                ForEach(sections, content: { section in
                    Text(section.name ?? "unknown piece")
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
        let _ = DataManager.shared.section(name: chosenName, piece: self.piece)
        DataManager.shared.save()
    }

    // ? - why delete from a set of indices than one index?
    func removeSection(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion

        for index in offsets {
            let section = sections[index]
            DataManager.shared.deleteSection(section: section)
        }
    }
}

