//
//  AVAssetManager.swift
//  Clout Lyfe
//
//  Created by apple on 02/06/22.
//

import Foundation
import AVFoundation
import UIKit


class AVAssetManager: NSObject {
    static let shared = AVAssetManager()
    
    var assets = [(AVURLAsset, UIImage?)]()

    class func setAsset(videoUrl: URL) -> (AVURLAsset, UIImage?) {
        if let asset = Self.shared.assets.first(where: {$0.0.url == videoUrl}) {
            return asset
        } else {
            let asset = AVURLAsset(url: videoUrl)
            Self.shared.assets.append((asset, nil))
            return (asset, nil)
        }
    }
    
    class func setImageTo(videoUrl: URL, image: UIImage?) {
        if let index = Self.shared.assets.firstIndex(where: {$0.0.url == videoUrl}) {
            let asset = Self.shared.assets[index]
            Self.shared.assets[index] = (asset.0, image)
        }
    }
    
}
