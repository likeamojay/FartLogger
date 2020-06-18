//
//  Utils.swift
//  FartLogger
//
//  Created by James Lane on 6/17/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit


extension UIView {
    
    func addShadow() {
            
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOpacity = 0.3
         self.layer.shadowOffset = CGSize(width: 2, height: 10)
         self.layer.shadowRadius = 8.0
        self.layer.cornerRadius = 8.0
        
    }
        
        // To add border lines to select views
        
        func addTopGrayBoundaryLine() {
            
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: 0, width:self.bounds.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.lightGray.cgColor
            self.layer.addSublayer(bottomLine)
        }
        
        func addBottomGrayBoundaryLine() {
              
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height, width:self.bounds.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.lightGray.cgColor
            self.layer.addSublayer(bottomLine)
        }
}
