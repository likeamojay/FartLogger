//
//  FartLogViewController.swift
//  FartLogger
//
//  Created by James Lane on 6/15/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit


class FartLogViewController : UIViewController {
    
    //MARK: - IBoutlets
    
    @IBOutlet var tableView: UITableView!
    
    
    //MARK: - Properties
    
    var dataManager : FLDataManager = FLDataManager.shared
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "My Log"
        
        self.tableView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
}
