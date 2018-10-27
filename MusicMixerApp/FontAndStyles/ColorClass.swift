//
//  ColorClass.swift
//  CircleIT
//
//  Created by CSS on 31/03/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import UIKit
extension UIColor
{
   // Text color
    class func textColorBlack() -> UIColor
    {
        return UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    class func textColorWhite() -> UIColor
    {
        return UIColor.white
    }
    class func textColorLightGray() -> UIColor
    {
        return UIColor.lightGray
    }
    class func textColorDarkGray() -> UIColor
    {
        return UIColor.darkGray
    }
    class func textMenuNormal()->UIColor
    {
        return UIColor.init(red: 182/255.0, green: 212/255.0, blue: 248.0/255, alpha:1.0)
    }
    // BG Colors
    
    class func BGWhite() -> UIColor
    {
        return UIColor.white
    }
    class func sliderColor() -> UIColor
    {
        return UIColor.blue
    }
  

}
