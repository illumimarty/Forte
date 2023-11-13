//
//  EnsembleDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/12/23.
//

import Foundation
import SwiftUI


struct EnsembleDetailsView: View {
    let ensemble: Ensemble
    
    var body: some View {
        VStack {
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(ensemble.name ?? "unknown").font(.headline)
            }
        }
    }
}
