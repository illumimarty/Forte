//
//  CompositionDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import SwiftUI

struct CompositionDetailsView: View {

    
//    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects
    
    
    
    @ObservedObject var passageViewModel: PassageListViewModel
    
//    @ObservedObject var compositionViewModel: CompositionListViewModel
    
    init(for piece: Composition) {
        self.passageViewModel = PassageListViewModel(for: piece)
    }
    
//    let ensemble: Ensemble
//    let piece: Composition
    
//    @State private var isAuthenticating = false
//    @State private var piece: Composition
    @State private var chosenName = ""
    @State private var isShowingEditView: Bool = false
    @State private var isInitializingSection: Bool = false

//    @State private var passages: [Passage]
        
    // TODO: Remember to consider the user's groups/pieces since, if multiple users, will pull EVERYONE's data instead of only their own

    var body: some View {
        VStack {
            Button("Add") {
                isShowingEditView.toggle()
                isInitializingSection.toggle()
            }
            .sheet(isPresented: $isShowingEditView) {
                SectionEditView(for: passageViewModel.piece)
                    .onDisappear(perform: {
                        passageViewModel.getPassages()
                    }) 
//                SectionEditView(viewModel: <#T##SectionEditViewModel#>)
            }
            List {
                ForEach(passageViewModel.passages, content: { section in
                    NavigationLink {
                        SectionEditView(for: passageViewModel.piece)
//                        SectionEditView(viewModel: SectionEditViewModel(initialState: SectionEditState(section: section)))
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

