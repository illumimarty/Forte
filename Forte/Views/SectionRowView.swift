//
//  SectionRowView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import Foundation
import SwiftUI

struct SectionRowView {
    var section: Section
    
    var body: some View {
        VStack {
            Text(section.name ?? "unknown section")
        }
    }
}
