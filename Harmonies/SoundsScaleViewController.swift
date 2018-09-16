//
//  SoundsScaleViewController.swift
//  PitchPerfect
//
//  Created by Jeffrey Zhu on 9/12/18.
//  Copyright © 2018 JeffreyZhu. All rights reserved.
//

import UIKit
import AVFoundation

class SoundsScaleViewController: UIViewController {

    var recordedAudioURL : URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioPlayerNode1: AVAudioPlayerNode!
    var stopTimer: Timer!
    var scaleValue : Float = 0.0
    
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var scale: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: PlayingState (raw values correspond to sender tags)
    
    enum PlayingState { case playing, notPlaying }
    
    // MARK: User Action Functions
    
    @IBAction func scaleChanged(_ sender: Any) {
        scaleValue = scale.value
        scaleValue.round()
        switch scaleValue {
        case 1:
            scaleLabel.text = "Major Second"
            scaleValue = 200
        case 2:
            scaleLabel.text = "Major Third"
            scaleValue = 400
        case 3:
            scaleLabel.text = "Perfect Fourth"
            scaleValue = 500
        case 4:
            scaleLabel.text = "Perfect Fifth"
            scaleValue = 700
        case 5:
            scaleLabel.text = "Major Sixth"
            scaleValue = 900
        case 6:
            scaleLabel.text = "Major Seventh"
            scaleValue = 1100
        case 7:
            scaleLabel.text = "Perfect Octave"
            scaleValue = 1200
        default:
            scaleLabel.text = "Original"
            scaleValue = 0
        }
        scaleLabel.sizeToFit()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playSound(pitch: scaleValue)
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAudio()
    }
    
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize (recording) audio file
        do {
            print("ASDF")
            print(recordedAudioURL)
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
            print(audioFile.processingFormat)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(describing: error))
        }
    }
    
    func playSound(pitch: Float? = nil) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        audioEngine.attach(changeRatePitchNode)
        
        connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(SoundsScaleViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        configureUI(.notPlaying)
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    // MARK: UI Functions
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            stopButton.isEnabled = true
            playButton.isEnabled = false
            scale.isEnabled = false
        case .notPlaying:
            stopButton.isEnabled = false
            playButton.isEnabled = true
            scale.isEnabled = true
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: View Load Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
}
