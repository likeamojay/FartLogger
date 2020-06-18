//
//  FartEntryDetailViewController.swift
//  FartLogger
//
//  Created by James Lane on 6/17/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit

class FartEntryDetailViewController : UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var playButtonImage: UIImageView!
    @IBOutlet var factoidLabel: UILabel!
    @IBOutlet var deleteEntryButton: UIButton!
    @IBOutlet var dateAndTimeLabel: UILabel!
    
    
    //MARK: - Stored Properties
    
    var entry : FartEntry!
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Fart Detail"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .medium
        
        dateAndTimeLabel.text = "Date & Time: " + formatter.string(from: entry.timestamp)
        dateAndTimeLabel.addShadow()
        deleteEntryButton.backgroundColor = UIColor.red
        deleteEntryButton.layer.cornerRadius = 8.0
        deleteEntryButton.addShadow()
        
        playButtonImage.isUserInteractionEnabled = true
        playButtonImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPlayButton)))
      
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func didTapDeleteEntryButton(_ sender: UIButton) {
        
        FLDataManager.shared.deleteEntry(entry: entry)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapPlayButton() {
        
    }
    
    @objc func didTapShareButton() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        
        let message = "Hey Guess What? I farted at " + formatter.string(from: entry.timestamp)
        
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
}


