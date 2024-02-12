//
//  CompositionRowView.swift
//  Forte
//
//  Created by Marty Nodado on 1/8/24.
//

import SwiftUI
// import Inject
import HotSwiftUI

struct CompositionRowView: View {
    
//    @ObserveInjection var forceRedraw
    @Binding var piece: Composition
    let viewPadding: CGFloat = 12
//    let itemInsets: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    var body: some View {
        VStack {
            Text(piece.name ?? "").font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(piece.composer ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding(.vertical, 8.0)
//        .enableInjection()
        .eraseToAnyView()
    }
    
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

// #Preview {
//     CompositionRowView(piece: piece)
// }
