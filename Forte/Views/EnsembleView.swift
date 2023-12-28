//
//  EnsembleView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI

struct EnsembleView: View {
    
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Ensemble>
    
    @ObservedObject var viewModel: EnsembleViewModel
    
//    @State private var chosenName = ""
    
    init(for viewModel: EnsembleViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                Button("Add") {
                    viewModel.toggleAuthenticating()
//                    isAuthenticating.toggle()
                }
                .alert("Enter group name", isPresented: $viewModel.isAuthenticating) {
                    TextField("London Symphony Orchestra", text: $viewModel.chosenName)
                    Button("OK", action: viewModel.createEnsemble)
                    Button("Cancel", role: .cancel) { }
                }
                List {
                    ForEach(viewModel.groups) { group in
                        NavigationLink {
//                            CompositionView(for: group)
//                            CompositionView(viewModel: CompositionListViewModel(ensemble: group))
                            
                        } label: {
                            Text(group.name ?? "unknown group")
                        }
//                        Text(group.name ?? "unknown group")
                    }
                    .onDelete(perform: viewModel.removeEnsemble)
                }
                .toolbar {
                    EditButton()
                }
            }
            .navigationTitle("My Groups")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

//struct EnsembleView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnsembleView(for: EnsembleViewModel())
//    }
//}
