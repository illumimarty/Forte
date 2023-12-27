//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI

struct EnsembleView: View {
    @ObservedObject var viewModel: EnsembleViewModel
    
    @State private var isAuthenticating = false
    @State private var chosenName = ""
    
    init(for viewModel: EnsembleViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                Button("Add") {
                    isAuthenticating.toggle()
                }
                .alert("Enter group name", isPresented: $isAuthenticating) {
                    TextField("London Symphony Orchestra", text: $chosenName)
                    Button("OK", action: {
                        guard !chosenName.isEmpty else { return }
                        viewModel.createEnsemble(for: chosenName)
                        chosenName = ""
                    })
                    Button("Cancel", role: .cancel) { }
                }
                List {
                    ForEach(viewModel.groups) { group in
                        NavigationLink {
                            CompositionView(viewModel: CompositionListViewModel(ensemble: group))
                        } label: {
                            Text(group.name ?? "unknown group")
                        }

                    }
                    .onDelete(perform: viewModel.removeEnsemble)
                }
                .onAppear(perform: self.viewModel.loadEnsembleList)
                .toolbar {
                    EditButton()
                }
            }
            .navigationTitle("My Groups")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
