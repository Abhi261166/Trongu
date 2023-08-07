//
//  Data+Custom.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 04/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit
import AVKit

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    
    func getFormatSize(style: ByteCountFormatter.Units) -> String {
        print("There were \(self.count) bytes")
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [style]
        // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self.count))
        print("formatted result: \(string)")
        return string
    }
    
}

extension URL {
    var data:Data? {
        do {
            return try Data(contentsOf: self)
        } catch {
            return nil
        }
    }
    
    var canOpen: Bool {
        return UIApplication.shared.canOpenURL(self)
    }
    
    func getThumbnailImageFromVideoUrl(completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: self) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                completion(thumbNailImage) //9
            } catch {
                print("error to get thumb  *****  \(error.localizedDescription)") //10
                completion(nil) //11
            }
        }
    }
    
}

extension Double {
    var inString:String {
        return "\("\(self.rounded())".dropLast(2))"
    }
    
    var inInt: Int {
        return Int(self)
    }
    
}




extension UILabel {
    open func setText(number:Double?) {
        if let num = number {
            self.text = num.inString
        } else {
            self.text = ""
        }
    }
}

extension UITextField {
    open func setText(number:Double?) {
        if let num = number {
            self.text = num.inString
        } else {
            self.text = ""
        }
    }
}
