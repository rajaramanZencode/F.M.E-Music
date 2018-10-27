//
//  Fonts.swift
//  CircleIT
//
//  Created by CSS on 31/03/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import UIKit

enum FontType:String{
    case AppFont
    case IconFont
}
enum FontName:String
{
    case None = "None"
    case SemiBold="Raleway-SemiBold"
    case Bold="Raleway-Bold"
    case Regular="Raleway-Regular"
  
}

struct AppFont
{
    static func systemFontWithWeightAndSize(fontName:FontName,size:CGFloat) -> UIFont
    {
        if fontName == .Regular
        {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        else if fontName == .SemiBold
        {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
            
        }
        else if fontName == .Bold
        {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        else
        {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
   
}
struct IconFont
{
    static func iconFontWithSize(size:CGFloat) -> UIFont
    {
        return UIFont.init(name: "icomoon", size: size)!
    }
   
    static let kCamera = "e"
    static let kMusic = "b"
    static let kMic = "c"
    static let kFileText = "d"
    static let kLocation = "f"
    static let kChat = "g"
    static let kUser = "i"
    static let kMenu = "h"
    static let kPlay = "j"
    static let kPause = "k"
    static let kStop = "l"
    static let kBackward = "m"
    static let kForward = "n"
    static let kPrevious = "o"
    static let kNext = "p"
    static let kPrevious1 = "q"
    static let kNext1 = "r"
    static let kRecord  = "s"






  

    
}
