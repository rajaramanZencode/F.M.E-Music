//
//  Enums.swift
//  MusicMixerApp
//
//  Created by Zencode Developer on 16/10/18.
//  Copyright © 2018 Rajaraman. All rights reserved.
//
import Foundation
import AVFoundation
enum InstrumentType:String
{
    case Percussion="Percussion", Tanpura="Tanpura", Melody="Melody", Mic="Mic", Master="Master"
}
class Instruments
{
    var type:InstrumentType
    var fileName:String
    var fileURL:URL?
    var volume:Float
    var reverb:Float?
    var delay:Int?
    var wetDry:Float?
    var bpm:Int?
    var pitch:Int?
    var audioPlayer = AVAudioPlayerNode()
    var audioFileBuffer:AVAudioPCMBuffer?
    let reverbNode = AVAudioUnitReverb()
    let delayNode = AVAudioUnitDelay()
    let pitchControl = AVAudioUnitTimePitch()

    
    

    init(withType:InstrumentType,name:String)
    {
        self.type = withType
        self.fileName = name
        self.fileURL = Bundle.main.url(forResource: name, withExtension: "mp3")?.absoluteURL
        self.volume = 0.2
        self.reverb = 50
        self.delay = 1
        self.wetDry = 100
        self.bpm = 60 // Default to 60bpm beats per minute
        self.pitch = 0 // Default to C
        if type != .Master
        {
            setUpInstrument()
        }
    }
    func setUpInstrument()
    {
        let file : AVAudioFile =  try! AVAudioFile.init(forReading: self.fileURL!)
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
        try! file.read(into: audioFileBuffer!)
        audioPlayer.volume=self.volume
        
       reverbNode.loadFactoryPreset(.plate)
        reverbNode.wetDryMix=50
//        audioPlayer.scheduleBuffer(audioFileBuffer!, at: nil, options:.loops, completionHandler: nil)
    }
}
