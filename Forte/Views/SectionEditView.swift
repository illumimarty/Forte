//
//  SectionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI

struct SectionEditView: View {
    
    @ObservedObject var viewModel: SectionEditViewModel
    
//    @ObservedObject var viewModel: PassageListViewModel
    
//    @ObservedObject var section: Passage
//    @StateObject var section: Passage
//    @Binding var isInitializing: Bool
//    @Binding var isPresenting: Bool

//    @ObservedObject var piece: Composition
    
//    @State private var passageName: String?
//    @State private var passageNotes: String?
//    @State private var personalNotes: String?
//    @State private var startRehearsalMark: String?
//    @State private var endRehearsalMark: String?
//    @State private var startMeasureNumber: String?
//    @State private var endMeasureNumber: String?
    

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Notes") {
                        TextField("Section Name", text: viewModel.binding(\.passageName))
                        TextField("Description", text: viewModel.binding(\.passageNotes))
                    }
                }

                
                HStack {
                    Button {
                        viewModel.isPresenting = false
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
                        createSection()
                        //                        createComposition()
//                        dismiss()
                        viewModel.isPresenting = false
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
    
    func createSection() {

    }
}

//struct SectionEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        SectionEditView()
//    }
//}

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        // Ensure a non-nil value in `source`.
        if source.wrappedValue == nil {
            source.wrappedValue = defaultValue
        }
        // Unsafe unwrap because *we* know it's non-nil now.
        self.init(source)!
    }
}
