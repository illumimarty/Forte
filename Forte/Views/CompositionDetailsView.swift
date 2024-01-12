//
//  CompositionDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import SwiftUI

struct CompositionDetailsView: View {
    
    @ObservedObject var passageViewModel: PassageListViewModel
    
    init(for piece: Composition) {
        self.passageViewModel = PassageListViewModel(for: piece)
    }
    
    @State private var chosenName = ""
    @State private var isShowingEditView: Bool = false
    @State private var isInitializingSection: Bool = false

    var body: some View {
        VStack {
            Button("Add") {
                isShowingEditView.toggle()
                isInitializingSection.toggle()
            }
            .sheet(isPresented: $isShowingEditView) {
                SectionEditView(piece: passageViewModel.piece)
                    .onDisappear(perform: {
                        passageViewModel.getPassages()
                    })
            }
            List {
                ForEach(passageViewModel.passages, content: { section in
                    NavigationLink {
                        SectionEditView(for: section, piece: passageViewModel.piece)
                    } label: {
                        Text(section.name ?? "unknown passage")
                    }
                })
                .onDelete(perform: passageViewModel.removePassage)
                
            }
            .toolbar {
                EditButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(passageViewModel.piece.name ?? "unknown").font(.headline)
            }
        }
    }
}
