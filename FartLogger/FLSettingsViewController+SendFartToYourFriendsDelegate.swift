//
//  FLSettingsViewController+SendFartToYourFriendsDelegate.swift
//  FartLogger
//
//  Created by James Lane on 6/20/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import Alamofire
import Foundation

extension FLSettingsViewController : SendFartToYourFriendsDelegate {
    
    func sendTo(entry: FartEntry) {
        
         print("-------------- SENDING ENTRY" )
        
         let accountSID = Constants.kTwilioAccountID
         let authToken = Constants.kTwilioAccountToken
        

       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.timeStyle = .medium
       

         let message = "Hey Guess What? This is " + NameToSend + ", I farted at " + formatter.string(from: entry.timestamp) + "\nMessage courtesy of Jimbo's FartLogger."

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        
        let numbers : [String] = FLDataManager.shared.currentContactNumbers.map { (c : ContactNumber) -> String in
            return c.phoneNumber
        }
        
        let condition = NSCondition()
        
        DispatchQueue.global(qos: .background).async {
        
        for number in numbers {
          print("-------------- ABOUT TO SEND TEXT SENT TO " + number)
        let parameters = ["From": "7192591279", "To": number , "Body": message]
                
            condition.lock()
                  Alamofire.AF.request(url, method: .post, parameters: parameters).authenticate(username: accountSID, password: authToken).responseJSON {
                      response in
                      print("-------------- TEXT SENT TO " + number)
                    
                    condition.signal()
                  }
            condition.wait()
            
            condition.unlock()
            

            RunLoop.main.run()
        }
        }
    }
}
