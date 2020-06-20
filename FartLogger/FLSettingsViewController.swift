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
import Alamofire

protocol SendFartToYourFriendsDelegate {
    func sendTo(entry: FartEntry)
}

class FLSettingsViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameToGiveToRecipientsLabel: UILabel!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var selectContactsButton: UIButton!
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var automaticMessagesOnOff: UISwitch!
    @IBOutlet var automaticMessagesLabel: UILabel!
    @IBOutlet var automaticFartMessagesLabel: UILabel!
    
    //MARK: - Properties
    
    var contactsSelected = Set<CNContact>()
    var contactStore : CNContactStore = CNContactStore()
    var NameToSend = "Jimbo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticMessagesOnOff.isOn = false
        automaticFartMessagesLabel.addBottomGrayBoundaryLine()
        aboutLabel.addBottomGrayBoundaryLine()
        selectContactsButton.layer.cornerRadius = 8.0
        selectContactsButton.addShadow()
        FLDataManager.shared.sendFartsToFriendsDelegate = self
        nameTextField.delegate = self
        
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if FLDataManager.shared.currentContactNumbers.count > 0 && !nameTextField.text!.isEmpty{
            
            automaticMessagesOnOff.isOn = true
        } else {
            automaticMessagesOnOff.isOn = false
        }
        
        if  UserDefaults.standard.value(forKey: Constants.kNameToGoBy) != nil {
            nameTextField.text = UserDefaults.standard.value(forKey: Constants.kNameToGoBy) as? String
        }
        
        if !automaticMessagesOnOff.isOn {
                  FLDataManager.shared.removeAllContactNumbers()
              }
        
        nameToGiveToRecipientsLabel.text = "Name to give to " + String(FLDataManager.shared.currentContactNumbers.count) + " recipients"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func didSwitchOnOff(_ sender: UISwitch) {
        
        if !sender.isOn {
            FLDataManager.shared.removeAllContactNumbers()
        }
        
        UserDefaults.standard.set(sender.isOn, forKey: Constants.kAutoTextsEnabled)
        
        UserDefaults.standard.synchronize()
        
    }
    
    @IBAction func didTapSelectContacts(_ sender: UIButton) {
        
        contactStore.requestAccess(for: .contacts) { (granted, error: Error?) in
            
            if granted {
                let contactPicker = CNContactPickerViewController()
                      contactPicker.delegate = self
                      contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                      // 2
                self.present(contactPicker, animated: true, completion: nil)
            }
        }
        
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.NameToSend = textField.text!
        UserDefaults.standard.set(self.NameToSend, forKey: Constants.kNameToGoBy)
        UserDefaults.standard.synchronize()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.NameToSend = textField.text!
               UserDefaults.standard.set(self.NameToSend, forKey: Constants.kNameToGoBy)
               UserDefaults.standard.synchronize()
        return textField.resignFirstResponder()
        
    }
    
    @objc func didTapInfoButton() {
        
        let alert = UIAlertController(title: nil, message: "When Fartlogger automatically sends a text. The below-entered name will be included in the message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
        self.present(alert,animated: true)
        
    }
}

//MARK: - CNContactPickerDelegate

extension FLSettingsViewController : CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let stripped  = (contact.phoneNumbers.first!.value).stringValue.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: " ", with: "")
        FLDataManager.shared.insertNewContactNumber(entry: ContactNumber(name: contact.givenName + " " + contact.familyName, phoneNumber: stripped))
    }
    
}


extension FLSettingsViewController : SendFartToYourFriendsDelegate {
    
    func sendTo(entry: FartEntry) {
        
         let accountSID = Constants.kTwilioAccountID
         let authToken = Constants.kTwilioAccountToken
        

       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.timeStyle = .medium
       

         let message = "Hey Guess What? This is " + NameToSend + ". I farted at " + formatter.string(from: entry.timestamp) + "\nMessage courtesy of Jimbo's FartLogger."

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        
        let numbers : [String] = FLDataManager.shared.currentContactNumbers.map { (c : ContactNumber) -> String in
            return c.phoneNumber
        }
        
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .background
       
        for number in numbers {
        operationQueue.addOperation {
        
        let parameters = ["From": "7192591279", "To": number , "Body": message]
                      
                  Alamofire.AF.request(url, method: .post, parameters: parameters).authenticate(username: accountSID, password: authToken).responseJSON {
                      response in
                      debugPrint(response)
                  }
            

            RunLoop.main.run()
            operationQueue.waitUntilAllOperationsAreFinished()
            
        }
        
        }
        
    }
}
