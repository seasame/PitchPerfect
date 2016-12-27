//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Bhardwaj, Vikas on 11/7/16.
//  Copyright © 2016 DebonairCoder. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var stopRecButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecButton.isEnabled = false
        recButton.isEnabled = true
        stopRecButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recordAudio(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording(){
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            print("Recording complete.")
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("There's an error with recording.")
        }
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("record button is pressed")
        recLabel.text = "Recording in Progress"
        recButton.isEnabled = false
        stopRecButton.isEnabled = true
        stopRecButton.isHidden = false
        recordAudio()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("stop recording button is pressed")
        recLabel.text = "Tap to Record"
        recButton.isEnabled = true
        stopRecButton.isEnabled = false
        stopRecording()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            print("here")
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

