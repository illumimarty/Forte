//
//  EnsembleViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class EnsembleViewModel: ObservableObject {

    @Published private var dataManager: DataManager
    @Published var isAuthenticating = false
    @Published var chosenName = ""
	@Published var isEditing = false

	@Published var groups: [EnsembleRowViewModel] = []
	
	private var disposables = Set<AnyCancellable>()
	
//    var groups: [Ensemble] {
//        get { dataManager.ensembles() }
//        set {}
//    }
    
    
	init(dataManager: DataManager = DataManager.shared, scheduler: DispatchQueue = DispatchQueue(label: "EnsembleViewModel")) {
        self.dataManager = dataManager
		
		loadEnsembleList()
		
		
    }
    
    func toggleAuthenticating() {
        isAuthenticating = !isAuthenticating
    }
    
    func createEnsemble() {
        guard !(chosenName.isEmpty) else { return }
        dataManager.createEnsemble(for: chosenName)
        chosenName = ""
    }
    
    func loadEnsembleList() {
        groups = dataManager.ensembles()
    }
    
    // ? - why delete from a set of indices than one index?
    func removeEnsemble(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        for index in offsets {
            let group = groups[index]
			group.deleteEnsemble()
//            dataManager.deleteEnsemble(ensemble: group)
        }
        groups.remove(atOffsets: offsets)
    }
}


