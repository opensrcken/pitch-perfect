//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ken Hahn on 3/22/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingButtonLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // when there is an ongoing recording, this ensures that
    // all the proper buttons and labels are shown / hidden.
    func displayRecordingState() {
        stopButton.hidden = false
        startButton.enabled = false
        recordingButtonLabel.text = "Recording..."
    }
    
    // when there is no ongoing recording, this ensures that
    // all the proper buttons and labels are shown / hidden.
    func displayWaitingState() {
        stopButton.hidden = true
        startButton.enabled = true
        recordingButtonLabel.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        displayRecordingState()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    var recordedAudio: RecordedAudio!
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            startButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            displayWaitingState()
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as
                PlaySoundsViewController
            
            playSoundsVC.receivedAudio = sender as RecordedAudio
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

