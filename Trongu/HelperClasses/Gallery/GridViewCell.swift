//
//  GridViewCell.swift
//  meetwise
//
//  Created by Nitin Kumar on 23/07/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import AVKit


class GridViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    lazy var overLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 140, g: 202, b: 60, a: 0.7)
        return view
    }()
    
    lazy var selectionImageView: UIView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = #imageLiteral(resourceName: "Vector 15")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    lazy var videoPlayerButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_play"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(videoPlayAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    var asset: PHAsset?
//    var media: Banner?
    var representedAssetIdentifier: String!
    var is_selected: Bool = false {
        didSet {
            overLayer.isHidden = !is_selected
            selectionImageView.isHidden = !is_selected
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageView()
        setSelectionImageView()
        cornerRadius = 4.0
    }
    
    private func setImageView() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        overLayer.frame = imageView.bounds
        addSubview(overLayer)
        overLayer.isHidden = !is_selected
        selectionImageView.isHidden = !is_selected
    }
    
    private func setSelectionImageView() {
        addSubview(selectionImageView)
        selectionImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        selectionImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        selectionImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        selectionImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(videoPlayerButton)
        videoPlayerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        videoPlayerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    public func setPHAsset(_ asset: PHAsset, imageManager: PHCachingImageManager, seletedIds: [String]) {
        self.asset = asset
        self.representedAssetIdentifier = asset.localIdentifier
        
        
//        let option = PHImageRequestOptions()
//        option.isSynchronous = false
//        option.isNetworkAccessAllowed = true
//        option.resizeMode = .exact
//        option.deliveryMode = .highQualityFormat
//
//        let option = PHImageRequestOptions()
//        option.isSynchronous = false
//        option.isNetworkAccessAllowed = false
//        option.resizeMode = .exact
//        option.deliveryMode = .opportunistic
//        option.version = .original
        
//        imageManager.requestImageData(for: asset, options: option) { data, value, orientation, dict in
//            if self.representedAssetIdentifier == asset.localIdentifier,
//                let data = data {
//                self.thumbnailImage = UIImage(data: data)
//            }
//        }
        
        imageManager.requestImage(for: asset, targetSize: self.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if self.representedAssetIdentifier == asset.localIdentifier {
                self.thumbnailImage = image
            }
        })
        
      
        switch asset.mediaType {
        case .image: self.videoPlayerButton.isHidden = true
        case .video: self.videoPlayerButton.isHidden = false
        default: break
        }
        
        self.is_selected = seletedIds.contains(self.representedAssetIdentifier)
        
//        print("\(representedAssetIdentifier)  *** \(seletedIds.contains(self.representedAssetIdentifier))  ----   \(seletedIds)")
        
    }
    
    
    
    
    public func setImage(_ data: PickerData) {
        self.imageView.image = data.image
        self.videoPlayerButton.isHidden = true
    }
    
    
    func getSize() -> UInt64 {
        if let asset = self.asset {
            let resources = PHAssetResource.assetResources(for: asset)
            if let resource = resources.first,
                  let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong {
                return UInt64(unsignedInt64)
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func isValidSize() -> Bool {
        let size = self.getSize()
        print("size is ********* \(size)")
        if self.asset?.mediaType == .image {
            return size < (1024*1024*20)
        } else {
            return size < (1024*1024*100)
        }
    }
    
    @objc func videoPlayAction(_ button: UIButton) {
        if let vc = self.getParentViewController() {
            if let asset = self.asset {
                self.playVideo(view: vc, asset: asset)
            }
        }
    }
    
    func playVideo(view: UIViewController, asset: PHAsset) {
        guard asset.mediaType == .video else { return }
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (asset, audioMix, info) in
            if let asset = asset as? AVURLAsset {
                DispatchQueue.main.async {
                    let player = AVPlayer(url: asset.url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    view.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
        })
    }
    
    
//    func setMedia(_ data: Banner?) {
//        self.media = data
//        self.imageView.setUserImage(data?.url)
//        self.videoPlayerButton.isHidden = data?.url?.isImageType == true
//    }
    
}


extension PHAsset {
    
//    var isGifType: Bool {
//        let resources = PHAssetResource.assetResources(for: self)
//        for resource in resources {
//             if resource.uniformTypeIdentifier == (kUTTypeGIF as String) {
//                 return true
//             }
//        }
//        return false
//    }
    
    
}



