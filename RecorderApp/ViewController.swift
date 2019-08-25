//
//  ViewController.swift
//  RecordAndPlay
//
//  Created by Hady Hammad on 7/26/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    
    var soundRecoder:AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!
    var fileName:String = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playBTN.isEnabled = false
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder(){
        print(getDocumentsDirectory())
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        let recordSetting = [AVFormatIDKey: kAudioFormatAppleLossless,
                             AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                             AVEncoderBitRateKey: 320000,
                             AVNumberOfChannelsKey: 2,
                             AVSampleRateKey: 44100.2 ] as [String:Any]
        do{
            
            soundRecoder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            soundRecoder.delegate = self
            soundRecoder.prepareToRecord()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func setupPlayer(){
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        do{
            
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBTN.isEnabled = true
        playBTN.setTitle("Play", for: .normal)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBTN.isEnabled = true
    }
    
    @IBAction func buRecord(_ sender: Any) {
        if recordBTN.titleLabel?.text == "Record"{
            soundRecoder.record()
            recordBTN.setTitle("Stop", for: .normal)
            playBTN.isEnabled = false
        }else{
            soundRecoder.stop()
            recordBTN.setTitle("Record", for: .normal)
            playBTN.isEnabled = false
        }
        
    }
    
    @IBAction func buPlay(_ sender: Any) {
        if playBTN.titleLabel?.text == "Play"{
            playBTN.setTitle("Stop", for: .normal)
            recordBTN.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        }else{
            soundPlayer.stop()
            playBTN.setTitle("Play", for: .normal)
            recordBTN.isEnabled = false
        }
    }
    
}

