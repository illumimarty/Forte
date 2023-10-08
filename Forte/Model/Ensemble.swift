//
//  Ensemble.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import Foundation

struct Instrument {
    var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

struct Ensemble {
    var name: String?
    var location: String?
    var instrument: Instrument?
    
    init(name: String? = nil, location: String? = nil, instrument: Instrument? = nil) {
        self.name = name
        self.location = location
        self.instrument = instrument
    }
}
