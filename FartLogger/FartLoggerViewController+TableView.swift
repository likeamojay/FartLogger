//
//  FartLoggerViewController+TableView.swift
//  FartLogger
//
//  Created by James Lane on 6/15/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit


extension FartLogViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataManager.currentFartEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FartLogTableCellView") as? FartLogTableCellView {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            if dataManager.currentFartEntries.count != 0 && dataManager.currentFartEntries.count > indexPath.row {
                
                    cell.dateAndTimeLabel.text = formatter.string(from: dataManager.currentFartEntries[indexPath.row].timestamp)
            }
            
            return cell
            
        } else {
            return UITableViewCell() // Should never be called
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "FartEntryDetailViewController") as! FartEntryDetailViewController

        vc.entry = dataManager.currentFartEntries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}



