//
//  SoundsDefaultViewController.swift
//  PitchPerfect
//
//  Created by Jeffrey Zhu on 9/11/18.
//  Copyright © 2018 JeffreyZhu. All rights reserved.
//

import UIKit
import AVFoundation

class SoundsDefaultViewController: UIViewController {
    
    @IBOutlet weak var orgButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    
    
    var recordedAudioURL : URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioPlayerNode1: AVAudioPlayerNode!
    var stopTimer: Timer!
    let audioHelper = AudioHelper()
    
    enum ButtonType: Int {
        case org = 0, third, fourth, fifth
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .org:
            playSound()
        case .third:
            playSound(pitch: 400)
        case .fourth:
            playSound(pitch: 500)
        case .fifth:
            playSound(pitch: 700)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
//        audioHelper.stopAudio()
        configureUI(.notPlaying)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        AudioHelper.parent = self
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        audioHelper.setupAudio()
        setupAudio()
        // Do any additional setup after loading the view.
    }
    
    
}
