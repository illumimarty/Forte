//
//  SectionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI

struct SectionEditView: View {
    
    @ObservedObject var viewModel: SectionEditViewModel
    @Environment(\.dismiss) var dismiss
    
    init (for piece: Composition, isIntializing: Bool = false) {
        let state = SectionEditState(for: piece)
        self.viewModel = SectionEditViewModel(initialState: state)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Notes") {
                        TextField("Section Name", text: viewModel.binding(\.name))
                        TextField("Description", text: viewModel.binding(\.notes))
                    }
                }

                HStack {
                    Button {
//                        viewModel.isPresenting = false
//                        isPresenting = false
//                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button {
                        print("Saving Changes...")
                        viewModel.createPassage()
                        dismiss()
//                        viewModel.isPresenting = false
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .navigationTitle("New Section")
        }
    }
}

//struct SectionEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        SectionEditView()
//    }
//}
