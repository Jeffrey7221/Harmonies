//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jeffrey Zhu on 9/10/18.
//  Copyright © 2018 JeffreyZhu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchVar: UISwitch!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func switched(_ sender: Any) {
        if(switchVar.isOn) {
            switchLabel.text = "Default"
        } else {
            switchLabel.text = "Slider"
        }

    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag && switchVar.isOn) {
            performSegue(withIdentifier: "soundsDefault", sender: audioRecorder.url)
        } else if (flag && !switchVar.isOn) {
            performSegue(withIdentifier: "soundsScale", sender: audioRecorder.url)
        } else {
            print("recording was no successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "soundsDefault") {
            let soundsDefaultVC = segue.destination as! SoundsDefaultViewController
            let recordedAudioURL = sender as! URL
            soundsDefaultVC.recordedAudioURL = recordedAudioURL
//            AudioHelper.recordedAudioURL = recordedAudioURL
//            AudioHelper.scaleOrDefault = "default"

        } else if (segue.identifier == "soundsScale") {
            let soundsScaleVC = segue.destination as! SoundsScaleViewController
            let recordedAudioURL = sender as! URL
            soundsScaleVC.recordedAudioURL = recordedAudioURL
//            AudioHelper.recordedAudioURL = recordedAudioURL
//            AudioHelper.scaleOrDefault = "default"
        }
    }
}

