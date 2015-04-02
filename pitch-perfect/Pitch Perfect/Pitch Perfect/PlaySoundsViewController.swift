//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ken Hahn on 3/22/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.enabled = false
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    // called when the audio player node has finished playing the given audio.
    func audioPlayerDidFinishPlaying() {
        stopButton.enabled = false
    }
    
    func playWithEffects(pitch: Float = 0, rate: Float = 1) {
        stop() // ensure that any ongoing plays are stopped, to prevent overlap
        stopButton.enabled = true
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        var changeRateEffect = AVAudioUnitVarispeed()
        changeRateEffect.rate = rate
        audioEngine.attachNode(changeRateEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeRateEffect, format:nil)
        audioEngine.connect(changeRateEffect, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format:nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: audioPlayerDidFinishPlaying)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    func stop() {
        audioEngine.stop()
        audioEngine.reset()
    }

    /**
     * corrects the pitch based on the documentation for rate here: https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVAudioUnitVarispeed_Class/index.html#//apple_ref/occ/instp/AVAudioUnitVarispeed/rate
     */
    @IBAction func onSnailPress(sender: UIButton) {
        playWithEffects(rate: 0.5, pitch: 1200)
    }
    
    @IBAction func onDarthVaderPress(sender: UIButton) {
        playWithEffects(pitch: -1000)
    }
    
    /**
    * corrects the pitch based on the documentation for rate here: https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVAudioUnitVarispeed_Class/index.html#//apple_ref/occ/instp/AVAudioUnitVarispeed/rate
    */
    @IBAction func onRabbitPress(sender: UIButton) {
        playWithEffects(rate: 2, pitch: -1200.0)
    }
    
    @IBAction func onChipmunkPress(sender: UIButton) {
        playWithEffects(pitch: 1000)
    }

    @IBAction func stopPlayback(sender: UIButton) {
        stop()
    }
}
