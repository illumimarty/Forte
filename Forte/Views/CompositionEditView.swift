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

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Group {
                        TextField("Name", text: viewModel.binding(\.pieceName))
                        TextField("Composer", text: viewModel.binding(\.composerName))
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
