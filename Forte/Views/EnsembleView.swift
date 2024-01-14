//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI
import HotSwiftUI

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
                    ForEach(viewModel.groups) { group in
//                        Section {
                            NavigationLink {
                                CompositionView(for: group)
                            } label: {
                                Text(group.name ?? "unknown group")
                                    .font(.title3)
                                    .padding(.vertical)
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
