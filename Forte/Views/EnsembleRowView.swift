//
//  EnsembleRowView.swift
//  Forte
//
//  Created by Marty Nodado on 1/13/24.
//

import SwiftUI
import HotSwiftUI

struct EnsembleRowView: View {
    
    var ensemble: Ensemble
    
    var body: some View {
        VStack {
            Text(ensemble.name ?? "").font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(ensemble.location ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding(.vertical, 8.0)
        .eraseToAnyView()
    }
}
