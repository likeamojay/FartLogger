//
//  RecordSessionViewController+AVAudioSession.swift
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
        
    }
    
    
    func stopRecording() {
        
        // Stop the stream of audio data.
        audioEngine.stop()
    }

}
