//
//  EnsembleEditView.swift
//  Forte
//
//  Created by Marty Nodado on 1/13/24.
//

import SwiftUI
import HotSwiftUI

struct EnsembleEditView: View {
    
    @ObservedObject var viewModel: EnsembleEditViewModel
    @Environment(\.dismiss) var dismiss
    private var title: String?
    
    init(for group: Ensemble? = nil) {
        let state = EnsembleEditState(group)
        self.title = "Edit Ensemble"
        self.viewModel = EnsembleEditViewModel(initialState: state)
    }
    
    var body: some View {
        VStack {
            Form {
                Group {
                    TextField("Name", text: viewModel.binding(\.name))
                    TextField("Location", text: viewModel.binding(\.location))
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
        .navigationTitle(title ?? "")
        .toolbar(.hidden, for: .tabBar)

        .eraseToAnyView()
    }
}
