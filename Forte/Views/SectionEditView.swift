//
//  SectionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI
//@_exported import Inject
//import HotSwiftUI

struct SectionEditView: View {
    
//    @ObserveInjection var forceRedraw
    @ObservedObject var viewModel: SectionEditViewModel
    @Environment(\.dismiss) var dismiss
    private var title: String?
    
    init (for section: Passage? = nil, piece: Composition) {
        if section != nil {
            let state = SectionEditState(section)
            self.title = state.name
            self.viewModel = SectionEditViewModel(initialState: state)
        } else {
            let state = SectionEditState(for: piece)
            self.title = "New Section"
            self.viewModel = SectionEditViewModel(initialState: state, isInitializing: true)
        }
    }
    
    let measureFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
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
                        TextField("Start", value: $viewModel.startMeasure, formatter: measureFormatter)
                       TextField("End", value: $viewModel.endMeasure, formatter: measureFormatter)
                    }
                }
                Section("Progress") {
                    VStack {
                        Text("\(viewModel.progressValue, format: .percent)")
                        Slider(value: $viewModel.progressValue, in: 0...1, step: 0.01)
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
        .navigationTitle(self.title ?? "")
        .toolbar(.hidden, for: .tabBar)
        .eraseToAnyView()
    }
}

struct SectionEditView_Previews: PreviewProvider {
    static var previews: some View {
        let piece = Composition(context: DataManager.shared.container.viewContext)
        let section = Passage(context: DataManager.shared.container.viewContext)
        SectionEditView(for: section, piece: piece)
		
    }
}
