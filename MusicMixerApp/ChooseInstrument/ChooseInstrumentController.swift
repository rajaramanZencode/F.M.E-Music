//
//  ChooseInstrumen tController.swift
//  MusicMixerApp
//
//  Created by Zencode Developer on 21/10/18.
//  Copyright © 2018 Rajaraman. All rights reserved.
//

import Foundation
import UIKit
protocol ChooseInstrumentDelegate:class
{
    func selectedInstrument(type:InstrumentType)
}
class ChooseInstrumentController:UIViewController
{
    weak var delegate:ChooseInstrumentDelegate?
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var tblInstrumentType: UITableView!
    let arrInstruments = [InstrumentType.Melody.rawValue,InstrumentType.Mic.rawValue,InstrumentType.Tanpura.rawValue,InstrumentType.Percussion.rawValue] as! [String]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblInstrumentType.register(UITableViewCell.self, forCellReuseIdentifier: "TypeCell")
        tblInstrumentType.tableFooterView=UIView(frame: .zero)
    }
    @IBAction func cancelClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK:- UITableViewDelegate and Datasource
extension ChooseInstrumentController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInstruments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TypeCell")!
        cell.textLabel?.text=arrInstruments[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.dismiss(animated: true, completion: nil)
        delegate?.selectedInstrument(type: InstrumentType(rawValue: arrInstruments[indexPath.row])!)
    }
    
}
