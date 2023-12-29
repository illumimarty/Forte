//
//  CompositionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI

struct CompositionEditView: View {
    @ObservedObject var viewModel: CompositionEditViewModel
    @Environment(\.dismiss) var dismiss
    
    
    /*
     if isInitializing:
        set the viewmodel with a blank slate
     else:
        populate the 
     
     
     */
    
    init(for group: Ensemble, isInitializing: Bool = false) {
        let state = CompositionEditState(for: group)

//        let state = CompositionEditState(for: group, isInitializing: isInitializing)
        self.viewModel = CompositionEditViewModel(initialState: state)
//        if isInitializing {
//            
//
//        } else {
////            let state = Compo
//        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Group {
                        TextField("Name", text: viewModel.binding(\.name))
                        TextField("Composer", text: viewModel.binding(\.composer))
                        TextField("Recording URL", text: viewModel.binding(\.recording_link))
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
                        viewModel.createComposition()
                        dismiss()
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .navigationTitle("New Composition")
        }
    }
}
