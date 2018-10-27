//
//  InstrumentCell.swift
//  MusicMixerApp
//
//  Created by Zencode Developer on 21/10/18.
//  Copyright © 2018 Rajaraman. All rights reserved.
//

import Foundation
import UIKit
class InstrumentCell:UICollectionViewCell
{
    let instrument:InstrumentView=InstrumentView(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        onCreate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func onCreate()
    {
        self.addSubview(instrument)
        instrument.snp.makeConstraints{
            $0.left.top.width.height.equalToSuperview()
        }
    }
}
