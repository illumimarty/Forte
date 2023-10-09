//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI

struct EnsembleView: View {
    
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Ensemble>
    
    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("EnsembleView")
            }
            .navigationTitle("My Groups")
            .navigationBarTitleDisplayMode(.large)
            Button("Add") {
                let names = ["Mariposa Symphony Orchestra", "London Symphony Orchestra", "Vanden Wind Ensemble", "Hilmar Community Band"]
                let chosenName = names.randomElement()!
                
                let group = Ensemble(context: moc)
                group.id = UUID()
                group.name = chosenName
                
                try? moc.save()
                
            }
            List(groups) { group in
                Text(group.name ?? "unknown")
            }
        }
    }
}

struct EnsembleView_Previews: PreviewProvider {
    static var previews: some View {
        EnsembleView()
    }
}
