//
//  GalleryModel.swift
//  meetwise
//
//  Created by Nitin Kumar on 23/07/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit
import Photos


extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

enum ImagePickerType {
    case document
    case camera
    case gallery
    case both
}

enum ImagePickerControllerType: String {
    case image = "public.image"
    case video = "public.movie"
    case both  = "public.both"
    
    var predicates: [NSPredicate] {
        switch self {
        case .both: return [NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue), NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)]
        case .image:
            return [NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)]
        case .video:
            return [NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)]
        }
    }
    
}


class GalleryModel: NSObject {
    
    
    var pickerType: ImagePickerControllerType = .video
    
    init(type: ImagePickerControllerType) {
        super.init()
        self.pickerType = type
        getPhotos()
    }
    
    override init() {
        super.init()
        getPhotos()
    }
    
    func getPhotos() {
        getAllPhotos()
        getSmartPhotos()
        getUserPhotos()
    }
    
    
    // MARK: Properties
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    
    func getAllPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: pickerType.predicates)
        options.predicate = predicate
        allPhotos = PHAsset.fetchAssets(with: options)
        print("all photos count \(allPhotos.count)")
    }
    
    
    func getSmartPhotos() {
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        print("Smart photos count \(smartAlbums.count)")
    }
    
    func getUserPhotos() {
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        print("user Collections photos count \(userCollections.count)")
    }
    
    static func getFirstImage(complition:((UIImage?)->())?) {
        guard let asset = GalleryModel(type: .image).allPhotos.firstObject else { return }
        let imageManager = PHCachingImageManager()
        let thumbnailSize = CGSize(width: 100, height: 100)
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            complition?(image)
        })
    }
    
}

