//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI

struct EnsembleView: View {
    
    @StateObject var viewModel = EnsembleViewModel()
    
    var body: some View {
		NavigationStack {
			ScrollView {
				LazyVStack {
					if viewModel.isEditing {
						Button("Add") {
							viewModel.toggleAuthenticating()
						}
						.alert("Enter group name", isPresented: $viewModel.isAuthenticating) {
							TextField("London Symphony Orchestra", text: $viewModel.chosenName)
							Button("OK", action: viewModel.createEnsemble)
							Button("Cancel", role: .cancel) { }
						}
					}
					ForEach(viewModel.groups) { row in
						EnsembleRowView.init(rowViewModel: row, mainViewModel: self.viewModel)
					}
				}
			}
			.navigationTitle("My Groups")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItemGroup(placement: .topBarTrailing) {
					EditButton().simultaneousGesture(TapGesture().onEnded({ _ in
						viewModel.isEditing.toggle()
					}))
				}
			}
		}
    }
}
