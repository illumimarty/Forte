//
//  SectionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI
@_exported import Inject

struct SectionEditView: View {
    
    @ObserveInjection var forceRedraw
    @ObservedObject var viewModel: SectionEditViewModel
    @Environment(\.dismiss) var dismiss
//    @State private var progressValue: Double = 50.0
    
    init (for section: Passage? = nil, piece: Composition) {
        
        let state = SectionEditState(section)

        if section != nil {
            self.viewModel = SectionEditViewModel(initialState: state)
        } else {
            self.viewModel = SectionEditViewModel(initialState: state, isInitializing: true)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Notes") {
                        TextField("Section Name", text: viewModel.binding(\.name))
                        TextField("Description", text: viewModel.binding(\.notes))
                    }
                    Section("Rehearsal Marks") {
                        HStack {
                            TextField("Start", text: viewModel.binding(\.startRehearsalMark))
                            TextField("End", text: viewModel.binding(\.endRehearsalMark))
                        }
                    }
                    Section("Measure Numbers") {
                        HStack {
//                            TextField("Start", text: viewModel.binding(\.startMeasure))
//                            TextField("End", text: viewModel.binding(\.endMeasure))
                        }
                    }
                    Section("Progress") {
                        VStack {
                            Text("\(viewModel.progressValue)")
//                                .padding()

                            Slider(value: $viewModel.progressValue, in: 0...100, step: 1)
                            .padding()
                        }
                    }
                    
                }
                HStack {
                    Button {
//                        viewModel.isPresenting = false
//                        isPresenting = false
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
            .navigationTitle(viewModel.state.name)
        }
        .enableInjection()
    }
}

struct SectionEditView_Previews: PreviewProvider {
    static var previews: some View {
        let piece = Composition(context: DataManager.shared.container.viewContext)
        let section = Passage(context: DataManager.shared.container.viewContext)
        SectionEditView(for: section, piece: piece)
    }
}
