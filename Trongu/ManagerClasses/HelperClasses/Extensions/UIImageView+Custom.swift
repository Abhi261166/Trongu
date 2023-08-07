//
//  UIImageView + Custom.swift
//  Leila
//
//  Created by Soumya Jain on 01/06/18.
//  Copyright © 2018 Soumya Jain. All rights reserved.
//

import UIKit
import Kingfisher
//import SkeletonView


extension UIImage {
    
    var renderTemplateMode: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    var renderOriginalMode: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    func maskWithColor(color: UIColor) -> UIImage {

         UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
         let context = UIGraphicsGetCurrentContext()!
         color.setFill()
        
         context.translateBy(x: 0, y: self.size.height)
         context.scaleBy(x: 1.0, y: -1.0)
         let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
         context.draw(self.cgImage!, in: rect)
         context.setBlendMode(CGBlendMode.sourceIn)
         context.addRect(rect)
         context.drawPath(using: CGPathDrawingMode.fill)
         let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return coloredImage!
    }
    
    
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
    
    
}
extension UIImage {
    func setCacheAt(url: String) {
        KingfisherManager.shared.cache.store(self, forKey: url)
    }
    
}

extension UIImageView {
    
    open func setImageView(_ image:UIImage, with color:UIColor) {
        let img = image.renderTemplateMode
        self.tintColor = color
        self.image = img
    }
    
    func setImage(image urlString:String?, placeholder image: UIImage? = nil) {
        if urlString?.count ?? 0 == 0 {
            self.image = image
            return
        }
        if let urlStr = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            urlStr.count > 0 {
            if let url = URL(string: urlStr), url.canOpen {
                var isSkeleton: Bool = false
                self.kf.setImage(with: url, progressBlock: { receivedSize, totalSize in
                    if !isSkeleton {
                        isSkeleton.toggle()
                        self.image = .gifImageWithName(name: "skeleton-loading")
                    }
                }, completionHandler: { result in
                    if isSkeleton == true {
                    }
                    switch result {
                    case .failure(let error):
                        print("image not downloaded \(error.localizedDescription) \(urlString)")
                        self.image = image
                        if ImageCache.default.isCached(forKey: urlString ?? "") {
                            ImageCache.default.retrieveImage(forKey: urlString ?? "") { result in
                                switch result {
                                case .success(let value):
                                    self.image = value.image
                                case .failure(let error):
                                    self.image = image
                                    print("erro ********** \(error)")
                                }
                            }
                        }
                    case .success(let img):
//                        print("image downloaded  \(urlString) \(image?.pngData()?.count)")
                        self.image = img.image
                    }
                })
            } else {
                self.image = image
            }
        } else {
            self.image = image
        }
    }
    
    
    public func setImageView(urls urlStrings: [String], placeholder image: UIImage? = nil, item: Int = 0, controller: UIViewController? = nil) {
        print("urls count is *******  \(urlStrings)")
        guard urlStrings.filter({$0.count > 0}).count > 0 else { return }
        
        let urls = urlStrings.map { str -> URL in
            let val = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            return URL(string: val)!
        }
//        guard urls.count > 0 else { return }
//        let types: [ImageViewerOption] = [.theme(.dark)]
//        self.setupImageViewer(urls: urls, initialIndex: item, options: types, from: controller)
        
//        let url = URL(string: urlStrings[item].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//        if isSkeleton {
//            self.image = UIImage.gifImageWithName(name: "skeleton-loading")
//        } else {
//            self.setProgressView()
//        }
        
        self.setImage(image: urlStrings.first, placeholder: image)
    }
    
    
}



extension UIImage {
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl: String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        return gifImageWithData(data: imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a!
            a = b!
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b!
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension UIImageView {
    
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
    
    func download(url: String?, rounded: Bool = true) {
        guard let _url = url else {
            return
        }
        if rounded {
            let processor = ResizingImageProcessor(referenceSize: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: self.frame.size.width / 2)
            self.kf.setImage(with: URL(string: _url), placeholder: nil, options: [.processor(processor)])
        } else {
            self.kf.setImage(with: URL(string: _url))
        }
    }

}


