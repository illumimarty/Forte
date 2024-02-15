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
    
	@FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var students: FetchedResults<Ensemble>
    @StateObject var viewModel = EnsembleViewModel()
	@State private var willDelete = false
	@State private var isEditing = false
	@State private var selectedItem: Ensemble?
    
    var body: some View {
        NavigationStack {
			ScrollView {
				LazyVStack {
					if isEditing {
						Button("Add") {
							viewModel.toggleAuthenticating()
						}
						.alert("Enter group name", isPresented: $viewModel.isAuthenticating) {
							TextField("London Symphony Orchestra", text: $viewModel.chosenName)
							Button("OK", action: viewModel.createEnsemble)
							Button("Cancel", role: .cancel) { }
						}
					}
					ForEach(students, id: \.self) { group in
						EnsembleRowView(ensemble: group, isEditing: $isEditing)
					}
				}
			}
            .navigationTitle("My Groups")
            .navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItemGroup(placement: .topBarTrailing) {
					EditButton().simultaneousGesture(TapGesture().onEnded({ _ in
						isEditing.toggle()
					}))
				}
			}
        }
        .eraseToAnyView()
    }
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}
