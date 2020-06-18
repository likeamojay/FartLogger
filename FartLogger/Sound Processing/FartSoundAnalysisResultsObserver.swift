//
//  FartSoundAnalysisResultsObserver.swift
//  FartLogger
//
//  Created by James Lane on 6/18/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import SoundAnalysis
import Foundation

// Observer object that is called as analysis results are found.
class FartSoundAnalysisResultsObserver : NSObject, SNResultsObserving {
    
    var dataManagerDelegate : FLDataManagerDelegate?
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        // Get the top classification.
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        // Determine the time of this result.
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds)
        print("Analysis result for audio at time: \(formattedTime)")
        
        let confidence = classification.confidence * 100.0
        let percent = String(format: "%.2f%%", confidence)

        // Print the result as Instrument: percentage confidence.
        print("\(classification.identifier): \(percent) confidence.\n")
        
        
        if (classification.identifier == "wet" || classification.identifier == "dry") && confidence >= 50.0 {
            DispatchQueue.main.async {
                self.dataManagerDelegate?.fartSoundDetected(confidence: confidence)
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
