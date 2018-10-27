//
//  CommonFunctions.swift
//
//  Created by CSS on 21/11/1939 Saka.
//  Copyright © 1939 Zencode. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension TimeZone {
    func offsetInHours() -> String
    {
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}
extension Date
{
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}
extension String {
    var localized: String {
        if NSLocalizedString(self, comment: "") != nil
        {
            return NSLocalizedString(self, comment: "")
        }
        return ""
    }
    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String {
        if let range = self.range(of: target)
        {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    func removingWhitespaces() -> String {
            return components(separatedBy: .whitespaces).joined()
        }
    
}
class CommonFunctions
{
    // to get icon font
    class func getFontIconUpDown(normalText:String,normalFont:UIFont,normalTextColor:UIColor,iconText:String,iconFont:UIFont,iconTextColor:UIColor) -> (NSAttributedString)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: iconText, attributes:[NSAttributedStringKey.font:iconFont,NSAttributedStringKey.foregroundColor:iconTextColor,NSAttributedStringKey.paragraphStyle:paragraphStyle])
        attributedString.append(NSAttributedString(string: "\n\(normalText)", attributes: [NSAttributedStringKey.font:normalFont,NSAttributedStringKey.foregroundColor:normalTextColor,NSAttributedStringKey.baselineOffset:-10,NSAttributedStringKey.paragraphStyle:paragraphStyle]))
        return attributedString;
    }
    class func getSafeAreaInsets() -> UIEdgeInsets
    {
        if #available(iOS 11.0, *) {
            if (UIApplication.shared.keyWindow?.safeAreaInsets)!.top == 0
            {
               return UIEdgeInsetsMake(20, (UIApplication.shared.keyWindow?.safeAreaInsets)!.left, (UIApplication.shared.keyWindow?.safeAreaInsets)!.bottom, (UIApplication.shared.keyWindow?.safeAreaInsets)!.right) 
            }
            else
            {
                return (UIApplication.shared.keyWindow?.safeAreaInsets)!
            }
        } else
        {
            return UIEdgeInsetsMake(0, 20, 0, 0 )
            // Fallback on earlier versions
        }
    }
   class func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
    
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
        if let _ = dt
        {
            return dateFormatter.string(from: dt!)
        }
        return ""
        
    }
    
    class func UTCToLocal(date:String, dateFormatNeed:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormatNeed
        if let _ = dt
        {
            return dateFormatter.string(from: dt!)
        }
        return ""

    }
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    class func getIPAddresses() -> String {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == 0 else { return [] }
//        guard let firstAddr = ifaddr else { return [] }
        
        guard getifaddrs(&ifaddr) == 0 else { return "" }
        guard let firstAddr = ifaddr else { return "" }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        if addresses.count == 3
        {
            return addresses[2]
        }
        else
        {
            return ""
        }
//        return addresses
    }
    //MARK:- Location Related Methods
    class func cleanNumber(number:String)->String
    {
        var strPhoneNo = number
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "+", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: " ", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "(", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: ")", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "-", with: "")
        return strPhoneNo
    }
    class func getFormattedRawNumber(number:String)->String
    {
        var strPhoneNo = number
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "(", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: ")", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "-", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "*", with: "")
        strPhoneNo=strPhoneNo.replacingOccurrences(of: "#", with: "")
        strPhoneNo=strPhoneNo.removingWhitespaces()
        return strPhoneNo
    }
    class func getCurrentCountryCode() -> String
    {
        let locale = Locale.current
        guard let _ = locale.regionCode else {
            return ""
        }
        return locale.regionCode!
    }
   class func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    let seconds: Int = seconds % 60
    let minutes: Int = (seconds / 60) % 60
    let hours: Int = seconds / 3600
    return String(format: "%02d:%02d:%02d",hours,minutes, seconds)
    }
    //MARK: - Media
   class func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL , options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    class func isVideo(url:String)->Bool
    {
        let imageExtensions = ["png","jpg","gif","jpeg","tiff","dib","ico","cur","xbm","bmp","tif"]
        let path = url.components(separatedBy: ".")
        if imageExtensions.contains(path.last!)
        {
            return false
        }
        else
        {
            return true
        }
   }
    //MARK:- Document Directory
    class func deleteAllAssetsInDocumentDirectory()
    {
        let error: NSErrorPointer = nil
        let filemanger = FileManager.default
        let documentsDirectory = filemanger.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let tempDirPath = documentsDirectory.appendingPathComponent("Assets")
        do{
            let directoryContents = try filemanger.contentsOfDirectory(atPath: tempDirPath.path)
            if directoryContents.count>0 {
                for path in directoryContents {
                    let fullPath = tempDirPath.appendingPathComponent(path)
                    try filemanger.removeItem(at:fullPath)
                }
            } else
            {
                print("Could not retrieve directory: \(error)")
            }
        }
        catch
        {
            print("Could not retrieve directory: \(error)")
        }
    }
    class func getHomePath()->URL
    {
        let filemanger = FileManager.default
        let documentsDirectory = filemanger.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let tempDirPath = documentsDirectory.appendingPathComponent("Assets")
        return tempDirPath
    }
    class func createHomeDirectory()
    {
        let filemanger = FileManager.default
        let documentsDirectory = filemanger.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = documentsDirectory.appendingPathComponent("Assets")
        if !filemanger.fileExists(atPath:folder.absoluteString)
        {
            do
            {
                try filemanger.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
                print("DIRECTORY CREATED")
            }
            catch
            {
                print("UNABLE TOC CREATE DIRETORY:", error)
            }
        }
    }
    class func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: kCMTimeZero, actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    class func getFileSize(path:String)->String
    {
        var fileSize : UInt64

        do {
            //return [FileAttributeKey : Any]
            let attr = try? FileManager.default.attributesOfItem(atPath:path)
            fileSize = attr![FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr! as NSDictionary
            fileSize = dict.fileSize()
            let size = ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: ByteCountFormatter.CountStyle.binary)
            return size
        } catch
        {
            print("Error: \(error)")
        }
    }
    
}




