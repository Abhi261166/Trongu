//
//  FeedGalleryCollectionView.swift
//  meetwise
//
//  Created by Amandeep on 24/09/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit
import Photos
import PhotosUI



protocol FeedGalleryCollectionViewDelegate: NSObjectProtocol {
    func feedGalleryOpenCamera(_ gallery: FeedGalleryCollectionView)
    func feedGallery(_ gallery: FeedGalleryCollectionView, didSelect asset: PHAsset)
}


class FeedGalleryCollectionView: UICollectionView {
    lazy var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>() {
        didSet {
            self.reloadData()
        }
    }
    weak var assetCollection: PHAssetCollection!
    lazy var previousPreheatRect = CGRect.zero
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    var model: GalleryModel!
    
    lazy var images:[(PHAsset, IndexPath)] = []
    weak var galleryDelegate: FeedGalleryCollectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
    private func setCollectionView() {
//        let size = (SCREEN_SIZE.width-4)/3
//        thumbnailSize = CGSize(width: size, height: size)
        
        thumbnailSize = CGSize(width: self.bounds.height, height: self.bounds.height)
        
        self.delegate = self
        self.dataSource = self
        self.register(GridViewCell.self, forCellWithReuseIdentifier: "GridViewCell")
        self.register(GridCameraViewCell.self, forCellWithReuseIdentifier: "GridCameraViewCell")
        
//       PHPhotoLibrary.shared().register(self)
    }
    
    
    
    public func setImageCollection(type: ImagePickerControllerType) {
        model = GalleryModel(type: type)
        fetchResult = model.allPhotos
    }
    
    // MARK: Asset Caching
    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
}

extension FeedGalleryCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = fetchResult.count > 15 ? 15 : fetchResult.count
        return count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCameraViewCell", for: indexPath) as! GridCameraViewCell
            cell.label.isHidden = true
            cell.cornerRadius = 12.0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as! GridViewCell
            let item = indexPath.item-1
            let asset = fetchResult.object(at: item)
            cell.setPHAsset(asset, imageManager: imageManager, seletedIds: [])
            cell.cornerRadius = 12.0
            return cell
        }
    }
    
}

extension FeedGalleryCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
}

extension FeedGalleryCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            galleryDelegate?.feedGalleryOpenCamera(self)
        } else {
            let item = indexPath.item-1
            let asset = fetchResult.object(at: item)
            self.galleryDelegate?.feedGallery(self, didSelect: asset)
            self.reloadData()
        }
    }
    
}
