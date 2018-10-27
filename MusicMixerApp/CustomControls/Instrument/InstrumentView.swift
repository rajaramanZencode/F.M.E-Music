//
//  InstrumentView.swift
//  
//
//  Created by Zencode Developer on 11/10/18.
//

import Foundation
import UIKit
import VerticalSteppedSlider
import SnapKit

protocol InstrumentViewDelegate:class
{
    func sliderValueChanged(type:InstrumentType, volume:Float)
}
class InstrumentView:UIView
{
    weak var delegate:InstrumentViewDelegate?
    var type: InstrumentType{
        didSet{
            updateView()
        }
    }
    var volume:Float = 0.0
    let imgView:UIImageView = UIImageView()
    let slider:VSSlider = VSSlider(frame: .zero)
    let lblName = UILabel()
    init(withType:InstrumentType)
    {
        self.type = .Master
        super.init(frame: .zero)
        type = withType
        onCreate()
    }
    override convenience init(frame: CGRect)
    {
        self.init(withType: .Melody)
    }
    func updateView()
    {
        lblName.text = type.rawValue
        imgView.image = UIImage(named:type.rawValue)

    }
    func onCreate()
    {
        self.backgroundColor=UIColor.textColorBlack()
        lblName.textColor=UIColor.textColorWhite()
        lblName.font=AppFont.systemFontWithWeightAndSize(fontName: .Regular, size: 15)
        lblName.numberOfLines=0
        lblName.lineBreakMode = .byWordWrapping
        lblName.text="Master"
        lblName.textAlignment = .center
        
        slider.minimumValue=0.0
        slider.maximumValue=1.0
        slider.value=0
        slider.isContinuous=true
        slider.vertical=true
        slider.trackWidth=5.0
        slider.markWidth=3.0
        slider.minimumTrackTintColor=UIColor.red
        slider.maximumTrackTintColor=UIColor.green
        slider.thumbTintColor=UIColor.blue
        
        imgView.image = UIImage(named: "Speaker")
        imgView.backgroundColor=UIColor.clear
        self.addSubview(lblName)
        self.addSubview(imgView)
        self.addSubview(slider)
        
        lblName.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(GlobalConstants.kLabelSizeMedium)
        }
        imgView.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        slider.snp.makeConstraints
        {
            $0.top.equalTo(lblName.snp.bottom).offset(GlobalConstants.kMinimumSpacing)
            $0.width.equalTo(GlobalConstants.kCommonSpacing)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(imgView.snp.top)
        }
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
    }
    @objc func valueChanged() {
        delegate?.sliderValueChanged(type: type, volume: slider.value)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

