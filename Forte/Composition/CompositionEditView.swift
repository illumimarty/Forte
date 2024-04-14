//
//  CompositionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI
import Inject
import HotSwiftUI

struct CompositionEditView: View {
    
    @ObservedObject var viewModel: CompositionEditViewModel
    @Environment(\.dismiss) var dismiss
    private var title: String?
    
	// TODO: Might need to refactor into one initializer
	
	init(for piece: Composition? = nil, group: Ensemble? = nil) {
		if piece != nil {
			let state = CompositionEditState(piece!)
//			let state = CompositionEditState(piece)
//			self.title = state.name
			self.viewModel = CompositionEditViewModel(initialState: state)
		} else {
			var state = CompositionEditState(for: group)
//			self.title = "New Composition"
			self.viewModel = CompositionEditViewModel(initialState: state, isInitializing: true)
		}
	}
	
//    init(for group: Ensemble, isInitializing: Bool = false) {
//		let state = CompositionEditState(for: group)
//		self.viewModel = CompositionEditViewModel(initialState: state)
//    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Group {
                        TextField("Name", text: viewModel.binding(\.name))
                        TextField("Composer", text: viewModel.binding(\.composer))
                        TextField("Recording URL", text: viewModel.binding(\.recordingLink))
                    }
                }
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button {
                        print("Saving Changes...")
						viewModel.saveChanges()
//                        viewModel.createComposition()
                        dismiss()
//                        withAnimation {
//                            viewModel.saveChanges()
//                        }
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
			.navigationTitle($viewModel.title)
        }
        .toolbar(.hidden, for: .tabBar)
        .eraseToAnyView()
    }
    
    #if DEBUG
//    @ObserveInjection
//    @ObserveInjection var inject
    #endif
}
