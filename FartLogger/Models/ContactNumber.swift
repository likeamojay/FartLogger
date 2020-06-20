//
//  ContactNumber.swift
//  FartLogger
//
//  Created by James Lane on 6/19/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import Foundation


struct ContactNumber : Codable, Equatable {
    
    var name : String
    var phoneNumber : String
}

extension CDContactNumber {
    
    var valueObject : ContactNumber? {
        
        if let p = self.phoneNumber, let n = self.name {
            return ContactNumber(name: n, phoneNumber: p)
        } else {
            return nil
        }
    }
}
