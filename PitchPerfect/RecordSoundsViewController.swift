//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Gök Gün Çağatay Koç on 1.12.2021.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var tap2RecordLabel: UILabel!
    
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false
    }

    @IBAction func recordButton(_ sender: UIButton) {
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecordButton(_ sender: UIButton) {
        configureUI(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioUrl
        }
    }
    
    func configureUI(_ isRecording: Bool) {
        switch isRecording {
        case true:
            tap2RecordLabel.text = "Recording in Progress"
            recordButtonOutlet.isEnabled = false
            stopRecordButton.isEnabled = true
        case false:
            tap2RecordLabel.text = "Tap to Record"
            recordButtonOutlet.isEnabled = true
            stopRecordButton.isEnabled = false
        }
    }
}

