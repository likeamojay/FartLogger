//
//  FLSettingsViewController.swift
//  FartLogger
//
//  Created by James Lane on 6/18/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit

class FLSettingsViewController : UIViewController {
    
  
    @IBOutlet var automaticMessagesOnOff: UISwitch!
    @IBOutlet var automaticMessagesLabel: UILabel!
    @IBOutlet var automaticFartMessagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticMessagesOnOff.isOn = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func didSwitchOnOff(_ sender: UISwitch) {
        
        
    }
    
    
    
}
