//
//  SectionRowView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import Foundation
import SwiftUI

struct SectionRowView {
    var passage: Passage
    
    var body: some View {
        VStack {
            Text(passage.name ?? "unknown section")
        }
    }
}

