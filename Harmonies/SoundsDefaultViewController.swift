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
    var stopTimer: Timer!
    let audioHelper = AudioHelper()
    
    enum ButtonType: Int {
        case org = 0, third, fourth, fifth
    }
    
    enum PlayingState { case playing, notPlaying }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .org:
            audioHelper.playSound()
        case .third:
            audioHelper.playSound(pitch: 400)
        case .fourth:
            audioHelper.playSound(pitch: 500)
        case .fifth:
            audioHelper.playSound(pitch: 700)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        audioHelper.stopAudio()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioHelper.setupAudio()
        audioHelper.setViewController(parent: self)
        
//        setupAudio()
        // Do any additional setup after loading the view.
    }
 
    // MARK: UI Functions
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        orgButton.isEnabled = enabled
        thirdButton.isEnabled = enabled
        fourthButton.isEnabled = enabled
        fifthButton.isEnabled = enabled
    }    
}
