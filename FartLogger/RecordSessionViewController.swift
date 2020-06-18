//
//  RecordSessionViewController.swift
//  FartLogger
//
//  Created by James Lane on 6/16/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import UIKit
import AVFoundation
import SoundAnalysis
import JGProgressHUD

class RecordSessionViewController : UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var descriptionTextLabel: UILabel!
    @IBOutlet var recordButton: UIImageView!
    @IBOutlet var phonePostitionImage: UIImageView!
    
    //MARK: - Stored Properties
    
    var audioEngine : AVAudioEngine!
    var inputBus : AVAudioNodeBus!
    var inputFormat : AVAudioFormat!
    var streamAnalyzer : SNAudioStreamAnalyzer!
    var resultsObserver : FartSoundAnalysisResultsObserver!
    var analysisQueue : DispatchQueue!
    var hud : JGProgressHUD!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        
        recordButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTaprecordButton)))
        recordButton.image = #imageLiteral(resourceName: "startRecordButton")
        
        descriptionTextLabel.addShadow()

        // Configure separate background thread to do ML analysis on microphone input
        analysisQueue = DispatchQueue(label: "com.jameslane.AnalysisQueue")
    }
    
    override func viewDidAppear(_ animated: Bool) {
         
         super.viewDidAppear(animated)
        
        // Request permission to use microphone
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            
            DispatchQueue.main.async {
                
                if !granted {
                    self.recordButton.isUserInteractionEnabled = false
                    
                } else {
                    self.recordButton.isUserInteractionEnabled = true
                }
            }
        }
        
        // Configure UI
        
        self.tabBarController?.title = "Record Fart Session"
        
        
        
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         
         super.viewWillDisappear(animated)
     }
    
    
    @objc func didTaprecordButton() {
        
        if recordButton.image == #imageLiteral(resourceName: "startRecordButton") {
            recordButton.image = #imageLiteral(resourceName: "stopRecordButton")
            recordButton.tintColor = UIColor.red
            self.beginRecording()
            self.startHUD()
        } else {
            recordButton.image = #imageLiteral(resourceName: "startRecordButton")
            recordButton.tintColor = UIColor.clear
            self.stopRecording()
            self.stopHUD()
        }
        
        
    }
    
    
    func startHUD() {
        
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Listening for Your Farts"
        hud.show(in: self.descriptionTextLabel)
        
    }
    
    
    func stopHUD() {
        
        hud.dismiss()
    }
    
}
