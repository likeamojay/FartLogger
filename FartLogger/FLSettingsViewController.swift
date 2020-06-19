//
//  FLSettingsViewController.swift
//  FartLogger
//
//  Created by James Lane on 6/18/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class FLSettingsViewController : UIViewController {
    
  
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var automaticMessagesOnOff: UISwitch!
    @IBOutlet var automaticMessagesLabel: UILabel!
    @IBOutlet var automaticFartMessagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticMessagesOnOff.isOn = false
        automaticFartMessagesLabel.addBottomGrayBoundaryLine()
        aboutLabel.addBottomGrayBoundaryLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func didSwitchOnOff(_ sender: UISwitch) {
        
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
          print("Access: \(access)")
        }
        
        let contactViewController = CNContactPickerViewController()
        contactViewController.hidesBottomBarWhenPushed = true
        contactViewController.delegate = self
        
        // 3
        navigationController?.pushViewController(contactViewController, animated: true)
        
        
    }
    
}

extension FLSettingsViewController : CNContactPickerDelegate {
    
    
    
    
    
}
