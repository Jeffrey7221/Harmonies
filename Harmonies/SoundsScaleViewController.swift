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
    var stopTimer: Timer!
    var scaleValue : Float = 0.0
    let audioHelper = AudioHelper()
    
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
        audioHelper.playSound(pitch: scaleValue)
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        audioHelper.stopAudio()
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
    
    // MARK: View Load Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioHelper.setupAudio()
        audioHelper.setViewController(otherParent: self)
        // Do any additional setup after loading the view.
    }
}
