//
//  FartEntry.swift
//  FartLogger
//
//  Created by James Lane on 6/15/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import Foundation

struct FartEntry : Codable, Equatable {
    
    var timestamp : Date
    var confidence : Double
}

extension CDFartEntry {
    
    var valueObject : FartEntry? {
        
        if let t = self.timestamp {
            return FartEntry(timestamp: t, confidence: self.confidence)
        } else {
            return nil
        }
    }
}



