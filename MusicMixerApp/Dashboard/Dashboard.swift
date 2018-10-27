//
//  ViewController.swift
//  MusicMixerApp
//
//  Created by Zencode Developer on 08/10/18.
//  Copyright © 2018 Rajaraman. All rights reserved.
//

import UIKit
import SnapKit
import SSCircularSlider
import AVFoundation

class DashboardController: UIViewController
{
    @IBOutlet weak var sliderReverb: SSCircularRingSlider!
    @IBOutlet weak var sliderDelay: SSCircularRingSlider!
    @IBOutlet weak var slideerWetDry: SSCircularRingSlider!
    
    @IBOutlet weak var tempoPicker: UIPickerView!
    @IBOutlet weak var keyPicker: UIPickerView!
    @IBOutlet weak var rhythmPicker: UIPickerView!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    
    @IBOutlet weak var collectionViewInstrument: UICollectionView!
    var selectedInstrumentType:InstrumentType = .Master
    
    var arrInstruments:[Instruments]=[Instruments]()
    
    let masterInstrument = InstrumentView(frame: .zero)
    let arrTempo = ["95","100","105","110"]
    let arrKeys = ["95-G","100-H","105-F","110-I"]
    let arrRhytms = ["rhythm1","rhythm2","rhythm3","rhythm4"]
    
    //Player
    private var audioFiles: Array<URL> = []
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    private var mixer: AVAudioMixerNode = AVAudioMixerNode()
    
    
    let reverb = AVAudioUnitReverb()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        setUpDelegates()
        setUpDefaults()
    }
    func setUpDefaults()
    {
        let master = Instruments(withType: .Master, name:"")
        arrInstruments.append(master)
        collectionViewInstrument.reloadData()
      
        enableDisableAllAudioControls(isEnable: false)
    }
    func enableDisableAllAudioControls(isEnable:Bool)
    {
        let alphaValues:CGFloat = (isEnable == true) ? 1.0:0.4
        sliderReverb.isUserInteractionEnabled=isEnable
        sliderDelay.isUserInteractionEnabled=isEnable
        slideerWetDry.isUserInteractionEnabled=isEnable
        
        keyPicker.isUserInteractionEnabled=isEnable
        tempoPicker.isUserInteractionEnabled=isEnable
        rhythmPicker.isUserInteractionEnabled=isEnable
        
        sliderReverb.alpha=alphaValues
        slideerWetDry.alpha=alphaValues
        sliderDelay.alpha=alphaValues
        keyPicker.alpha=alphaValues
        tempoPicker.alpha=alphaValues
        rhythmPicker.alpha=alphaValues
        
        
    }
    func setValueForSelectedInstrument(instrument:Instruments)
    {
        if instrument.type == .Master
        {
            enableDisableAllAudioControls(isEnable: false)
        }
        else
        {
            enableDisableAllAudioControls(isEnable: true)
        }
        
    }
    func setUpDelegates()
    {
        (collectionViewInstrument.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        collectionViewInstrument.register(InstrumentCell.self, forCellWithReuseIdentifier: "InstrumentCell")
        tempoPicker.delegate=self
        tempoPicker.dataSource=self
        keyPicker.delegate=self
        keyPicker.dataSource=self
        rhythmPicker.delegate=self
        rhythmPicker.dataSource=self
        
        slideerWetDry?.delegate=self
        sliderDelay?.delegate=self
        sliderReverb?.delegate=self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func addInstrument(_ sender: Any) {
        audioEngine.stop()
        self.present(ChooseInstrumentController(), animated: true, completion: nil)
    }
    
    @IBAction func menuClicked(_ sender: Any)
    {
        self.sideMenuController()?.sideMenu?.showSideMenu()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    //MARK:- Player Controls
    @IBAction func playButtonClicked(_ sender: Any)
    {
        // do work in a background thread
        reverb.loadFactoryPreset(.largeRoom2)
        reverb.wetDryMix = 4
        
       
        
        DispatchQueue.global(qos: .background).async
            {
//                self.audioEngine.attach(self.mixer)
//                self.audioEngine.connect(self.mixer, to: self.audioEngine.outputNode, format: nil)

                // !important - start the engine *before* setting up the player nodes
              
                for instrument in self.arrInstruments
                {
                    if instrument.type != .Master
                    {
                        self.audioEngine.attach(instrument.audioPlayer)
                        self.audioEngine.attach(instrument.delayNode)
                        self.audioEngine.attach(instrument.reverbNode)
                        self.audioEngine.attach(instrument.pitchControl)
                        // Notice the output is the mixer in this case

                        self.audioEngine.connect(instrument.audioPlayer, to: instrument.delayNode, format: instrument.audioFileBuffer?.format)
                        self.audioEngine.connect(instrument.audioPlayer, to: instrument.reverbNode, format: instrument.audioFileBuffer?.format)
                         self.audioEngine.connect(instrument.audioPlayer, to: instrument.pitchControl, format: instrument.audioFileBuffer?.format)

                        self.audioEngine.connect(instrument.reverbNode, to: self.audioEngine.mainMixerNode, format: instrument.audioFileBuffer?.format)
                        self.audioEngine.connect(instrument.delayNode, to: self.audioEngine.mainMixerNode, format: instrument.audioFileBuffer?.format)
                        self.audioEngine.connect(instrument.pitchControl, to: self.audioEngine.mainMixerNode, format: instrument.audioFileBuffer?.format)

                        self.audioEngine.connect(instrument.audioPlayer, to: self.audioEngine.mainMixerNode, format: instrument.audioFileBuffer?.format)
//                        instrument.audioPlayer.scheduleBuffer(instrument.audioFileBuffer!, at: nil, options:.loops, completionHandler: nil)

//                        instrument.audioPlayer.play(at: nil)
                    }

                }
                self.audioEngine.prepare()
                try! self.audioEngine.start()
                for instrument in self.arrInstruments
                {
                    if instrument.type != .Master
                    {
                        instrument.audioPlayer.scheduleBuffer(instrument.audioFileBuffer!, at: nil, options:.loops, completionHandler: nil)
                        instrument.audioPlayer.play(at: nil)

                    }
                }

        }
        /*
        audioFiles = [Bundle.main.url(forResource: "Bhajan-1", withExtension: "mp3")!,Bundle.main.url(forResource: "harmonium-1", withExtension: "mp3")!,Bundle.main.url(forResource: "Bhajan-2", withExtension: "mp3")!]

        // do work in a background thread
        DispatchQueue.global(qos: .background).async
            {
            self.audioEngine.attach(self.mixer)
            self.audioEngine.connect(self.mixer, to: self.audioEngine.outputNode, format: nil)
            // !important - start the engine *before* setting up the player nodes
            try! self.audioEngine.start()
            
            let fileManager = FileManager.default
            for audioFile in self.audioFiles {
                // Create and attach the audioPlayer node for this file
                
//                let fileUrl = NSURL.init(fileURLWithPath: fileName.removingPercentEncoding!)
                let file : AVAudioFile =  try! AVAudioFile.init(forReading: audioFile.absoluteURL)
                
                let audioFormat = file.processingFormat
                let audioFrameCount = UInt32(file.length)
                let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
                try! file.read(into: audioFileBuffer!)
                
                let audioPlayer = AVAudioPlayerNode()
                self.audioEngine.attach(audioPlayer)
                // Notice the output is the mixer in this case
                self.audioEngine.connect(audioPlayer, to: self.mixer, format: audioFileBuffer?.format)
                audioPlayer.scheduleBuffer(audioFileBuffer!, at: nil, options:.loops, completionHandler: nil)
                let pitch = AVAudioUnitTimePitch()
                // We should probably check if the file exists here ¯\_(ツ)_/¯

//                audioPlayer.scheduleFile(file, at: nil, completionHandler: nil)
                audioPlayer.play(at: nil)
            }
        }
 */
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ChooseInstrument"
        {
            let vCtrl = segue.destination as! ChooseInstrumentController
            vCtrl.delegate=self
        }
    }
    @IBAction func stopButtonClicked(_ sender: Any)
    {
        audioEngine.stop()
    }
    @IBAction func recordButtonClicked(_ sender: Any)
    {
        
    }
}
// MARK:- SSCircularRing  Delegates
extension DashboardController:SSCircularRingSliderDelegate
{
    func controlValueUpdated(value: Int,slider:SSCircularRingSlider)
    {
        
        print("Control value:\(value)")
        reverb.wetDryMix = Float(value)

       
        let arrList = arrInstruments.filter{$0.type == selectedInstrumentType}
        if arrList.count>0
        {
            let instrument = arrList[0]
//
//            var adjustedBpm: Float = 120
//            let currentTap = Date()
//
//
//                let interval = currentTap.timeIntervalSince(Date())
//                adjustedBpm = Float(60/interval)
//                 instrument.pitchControl.rate = 15
//            instrument.pitchControl.pitch=1000
            
            instrument.reverbNode.wetDryMix=Float(value)
            
//
            if slider == sliderReverb
            {
                instrument.reverb=Float(value)
                instrument.reverbNode.wetDryMix=Float(value)
            }
            else if slider == sliderDelay
            {
                instrument.delay=value
                instrument.delayNode.delayTime=TimeInterval(value)
            }
            else
            {
                instrument.wetDry=Float(value)
                instrument.delayNode.wetDryMix=Float(value)
            }
        }
    }

}
//MARK:- Choose Instrument Delegate
extension DashboardController:ChooseInstrumentDelegate
{
    func selectedInstrument(type:InstrumentType)
    {
        let arrAlreaadySelected = arrInstruments.filter{$0.type==type}
        if arrAlreaadySelected.count>0
        {
            let alert = UIAlertController(title: "F.M.E Music", message: "Instrument already added", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        var name = ""
        switch type
        {
        case .Melody:
            name="sitar-1"
        case .Percussion:
            name="Bhajan-1"
        case .Tanpura:
            name="a"
        default:
            name="sitar-1"
        }
        enableDisableAllAudioControls(isEnable: true)
        let master = Instruments(withType: type, name:name)
        selectedInstrumentType = type
        arrInstruments.append(master)
        collectionViewInstrument.reloadData()
    }
}
extension DashboardController:ENSideMenuDelegate
{
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}
//MARK:- UIColllectionviewDelegate and Datasource
extension DashboardController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,InstrumentViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrInstruments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstrumentCell", for: indexPath) as! InstrumentCell
        let instrument = arrInstruments[indexPath.row]
        cell.instrument.type = instrument.type
        cell.instrument.slider.value=instrument.volume
        cell.instrument.delegate=self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        setValueForSelectedInstrument(instrument: arrInstruments[indexPath.row])
    }
    func sliderValueChanged(type: InstrumentType, volume: Float)
    {
        print("volume: \(volume)")
        let arrList = arrInstruments.filter{$0.type == type}
        if arrList.count>0
        {
            let instrument = arrList[0]
            if type == .Master
            {
                audioEngine.mainMixerNode.volume = volume
            }
            else
            {
                instrument.audioPlayer.volume=volume
            }
        }
    }
}


//MARK:- UIPickerViewDelegate and Datasource
extension DashboardController:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == tempoPicker
        {
            return arrTempo.count
        }
        else if pickerView == keyPicker
        {
            return arrKeys.count
        }
        else
        {
            return arrRhytms.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == tempoPicker
        {
            return arrTempo[row]
        }
        else if pickerView == keyPicker
        {
            return arrKeys[row]
        }
        else
        {
            return arrRhytms[row]
        }
    }
    
    
}
