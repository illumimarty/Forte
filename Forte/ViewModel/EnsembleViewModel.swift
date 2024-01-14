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
    
//    private var cancellables: Set<AnyPublisher> = []

    var groups = [Ensemble]()
//    var groups: [Ensemble] {
//        get {
//            dataManager.ensembles()
//        }
//        set {}
//    }
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        
//        self.observer = dataManager.getEnsemblesWithCombine()
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    print("Finished")
//                case .failure(let err):
//                    print(err)
//                }
//            }, receiveValue: { [weak self] value in
//                self?.groups = value
//            })
    }
    
//    private func setupSubscribers() {
//        let contextPublisher = NotificationCen
//    }
    
    func toggleAuthenticating() {
        isAuthenticating = !isAuthenticating
    }
    
    func createEnsemble() {
        guard !(chosenName.isEmpty) else { return }
        dataManager.createEnsemble(for: chosenName)
        chosenName = ""
    }
    
    func loadEnsembleList() {
        self.groups = dataManager.ensembles()
    }
    
    // ? - why delete from a set of indices than one index?
    func removeEnsemble(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        for index in offsets {
            let group = groups[index]
            dataManager.deleteEnsemble(ensemble: group)
        }
        groups.remove(atOffsets: offsets)
    }
}
