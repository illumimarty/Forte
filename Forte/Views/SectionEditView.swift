//
//  SectionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI

struct SectionEditView: View {
    
    let isInitializing: Bool = false
    let piece: Composition
    @State private var passageName: String = ""
    @State private var passageNotes: String = ""
    @State private var personalNotes: String = ""
    @State private var startRehearsalMark: String = ""
    @State private var endRehearsalMark: String = ""
    @State private var startMeasureNumber: String = ""
    @State private var endMeasureNumber: String = ""
    @Environment(\.dismiss) var dismiss
    
    init(piece: Composition) {
        self.piece = piece
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Notes") {
                        TextField("Section Name", text: $passageName)
                        TextField("Description", text: $passageNotes)
//                        TextField("Notes", text: $personalNotes)
                    }
                    
                    Section("Rehearsal Marks") {
                        HStack {
                            TextField("Start", text: $startRehearsalMark)
                            TextField("End", text: $endRehearsalMark)
                        }
                    }
                    
                    Section("Measure Numbers") {
                        HStack {
                            TextField("Start", text: $startMeasureNumber)
                            TextField("End", text: $endMeasureNumber)
                        }
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
                        createSection()
                        //                        createComposition()
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
            .navigationTitle("New Section")
        }
    }
    
    func createSection() {
        let section = DataManager.shared.passage(piece: self.piece)
        section.name = passageName
        section.notes = passageNotes
        section.startRehearsalMark = self.startRehearsalMark
        section.endRehearsalMark = self.endRehearsalMark
        section.startMeasure = Int16(self.startMeasureNumber) ?? 0
        section.endMeasure = Int16(self.endMeasureNumber) ?? 0
        DataManager.shared.save()
    }
}

//struct SectionEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        SectionEditView()
//    }
//}
