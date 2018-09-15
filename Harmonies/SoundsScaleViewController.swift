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
    
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var scale: UISlider!
    
    @IBAction func scaleChanged(_ sender: Any) {
        var scaleValue = scale.value
        scaleValue.round()
        switch scaleValue {
        case 1:
            scaleLabel.text = "Major Second"
        case 2:
            scaleLabel.text = "Major Third"
        case 3:
            scaleLabel.text = "Perfect Fourth"
        case 4:
            scaleLabel.text = "Perfect Fifth"
        case 5:
            scaleLabel.text = "Major Sixth"
        case 6:
            scaleLabel.text = "Major Seventh"
        case 7:
            scaleLabel.text = "Perfect Octave"
        default:
            scaleLabel.text = "Original"
        }
        scaleLabel.sizeToFit()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
