//
//  RecordSessionViewController+SoundAnalysis.swift
//  FartLogger
//
//  Created by James Lane on 6/17/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import AVFoundation
import SoundAnalysis

extension RecordSessionViewController {

    func beginRecording() {
        
        // Create a new audio engine.
        audioEngine = AVAudioEngine()

        // Get the native audio format of the engine's input bus.
        inputBus = AVAudioNodeBus(0)
        inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        
        do {
            // Start the stream of audio data.
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
        
        
         // Pull in our ML model to recognize farts
        
         let classifier = FartSoundClassifier()
         let model: MLModel = classifier.model
        
        streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        // Create a new observer that will be notified of analysis results.
        // Keep a strong reference to this object.
        resultsObserver = FartSoundAnalysisResultsObserver()
        resultsObserver.dataManagerDelegate = FLDataManager.shared

        do {
            // Prepare a new request for the trained model.
            let request = try SNClassifySoundRequest(mlModel: model)
            try streamAnalyzer.add(request, withObserver: resultsObserver)
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
        
       // Install an audio tap on the audio engine's input node.
        audioEngine.inputNode.installTap(onBus: inputBus,
                                         bufferSize: 8192, // 8k buffer
                                         format: inputFormat) { buffer, time in
            
            // Analyze the current audio buffer.
            self.analysisQueue.async {
                self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
    }
    
    func stopRecording() {
        
        // Stop the stream of audio data.
        audioEngine.stop()

    }
}


