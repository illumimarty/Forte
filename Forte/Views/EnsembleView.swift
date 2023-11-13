//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI

struct EnsembleView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var groups: FetchedResults<Ensemble>
    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects
    
    @State private var isAuthenticating = false
    @State private var chosenName = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                Button("Add") {
                    isAuthenticating.toggle()
                }
                .alert("Enter group name", isPresented: $isAuthenticating) {
                    TextField("London Symphony Orchestra", text: $chosenName)
                    Button("OK", action: createEnsemble)
                    Button("Cancel", role: .cancel) {}
                }
                List {
                    ForEach(groups) { group in
                        NavigationLink(destination: EnsembleDetailsView(ensemble: group)) {
                            Text(group.name ?? "unknown")
                        }
                    }
                    .onDelete(perform: removeEnsemble)
                }
                .toolbar {
                    EditButton()
                }
            }
            .navigationTitle("My Groups")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func createEnsemble() {
        let group = Ensemble(context: moc)
        group.id = UUID()
        group.name = chosenName
        try? moc.save()
    }
    
    // ? - why delete from a set of indices than one index?
    func removeEnsemble(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        
        for index in offsets {
            let group = groups[index]
            moc.delete(group)
        }
        try? moc.save()
    }
}

struct EnsembleView_Previews: PreviewProvider {
    static var previews: some View {
        EnsembleView()
    }
}
