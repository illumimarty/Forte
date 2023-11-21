//
//  CompositionEditView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import SwiftUI

struct CompositionEditView: View {
    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects

    
    let isInitializing: Bool
    
    let ensemble: Ensemble
    @State private var pieceName: String = ""
    @State private var composerName: String = ""
    @State private var recordingLink: String = ""
    @Environment(\.dismiss) var dismiss
    
    
    init(ensemble: Ensemble, isInitializing: Bool = false) {
        self.ensemble = ensemble
        self.isInitializing = isInitializing
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Group {
                        TextField("Name", text: $pieceName)
                        TextField("Composer", text: $composerName)
                        TextField("Recording Link", text: $recordingLink)
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
                        createComposition()
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
    
    func createComposition() {
        let piece = DataManager.shared.piece(ensemble: self.ensemble)
        piece.name = pieceName
        piece.composer = composerName
        piece.recording_link = piece.recording_link
        DataManager.shared.save()
    }
}
