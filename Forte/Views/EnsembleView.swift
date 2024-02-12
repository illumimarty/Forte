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
    
	@FetchRequest(sortDescriptors: []) var students: FetchedResults<Ensemble>
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
					ForEach(students) { student in
//					ForEach(students.indices, id: \.self) { idx in
//					ForEach(viewModel.groups.indices, id: \.self) { idx in
//                    ForEach(Array(viewModel.groups.enumerated()), id: \.1) { index, group in
                            NavigationLink {
								CompositionView(for: student)
//								CompositionView(for: viewModel.groups[idx])
                            } label: {
								EnsembleRowView(ensemble: student)
//								EnsembleRowView(ensemble: viewModel.groups[idx])
//                                    .onDisappear(perform: viewModel.loadEnsembleList)
                            }
//                            .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
//                                Button(role: .destructive) {
//                                    let idx = IndexSet(integer: index)
//                                    viewModel.removeEnsemble(at: idx)
//                                    print("Deleting...")
//                                } label: {
//                                    Label("Delete", systemImage: "trash.fill")
//                                }
//                            })
                            .swipeActions(allowsFullSwipe: true) {
                                NavigationLink {
									EnsembleEditView(for: student)
//									EnsembleEditView(for: viewModel.groups[idx])
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
                .refreshable {
                    viewModel.loadEnsembleList()
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
