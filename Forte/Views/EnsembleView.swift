//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI
import HotSwiftUI
import Inject

struct EnsembleView: View {
    
    @StateObject var viewModel = EnsembleViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Add") {
                    viewModel.toggleAuthenticating()
                }
                .alert("Enter group name", isPresented: $viewModel.isAuthenticating) {
                    TextField("London Symphony Orchestra", text: $viewModel.chosenName)
                    Button("OK", action: viewModel.createEnsemble)
                    Button("Cancel", role: .cancel) { }
                }
                List {
                    ForEach(Array(viewModel.groups.enumerated()), id: \.1) { index, group in
                            NavigationLink {
                                CompositionView(for: group)
                            } label: {
                                EnsembleRowView(ensemble: group)
                                    .onDisappear(perform: viewModel.loadEnsembleList)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                                Button(role: .destructive) {
                                    let idx = IndexSet(integer: index)
                                    viewModel.removeEnsemble(at: idx)
                                    print("Deleting...")
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            })
                            .swipeActions(allowsFullSwipe: true) {
                                NavigationLink {
                                    EnsembleEditView(for: group)
                                        .onDisappear(perform: {
                                            viewModel.loadEnsembleList()
                                        })
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                .tint(.yellow)
                            }
                    }
                    .onDelete(perform: viewModel.removeEnsemble)
                }
                .toolbar {
                    EditButton()
                }
            }
            .navigationTitle("My Groups")
            .navigationBarTitleDisplayMode(.large)
        }

        .eraseToAnyView()
    }
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}
