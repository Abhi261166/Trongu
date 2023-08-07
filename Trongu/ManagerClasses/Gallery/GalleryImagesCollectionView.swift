//
//  GalleryImagesCollectionView.swift
//  meetwise
//
//  Created by Nitin Kumar on 25/07/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//



import UIKit
import Photos
import PhotosUI


protocol GalleryImagesCollectionViewDelegate: NSObjectProtocol {
    func galleryOpenCamera()
    func didSelect(item atIndex: IndexPath)
}

class GalleryImagesCollectionView: UICollectionView {
    
    lazy var isCameraOption: Bool = false {
        didSet {
            reloadData()
        }
    }
    lazy var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>() {
        didSet {
            self.reloadData()
        }
    }
    
    lazy var maxSelection: Int = 1
    weak var assetCollection: PHAssetCollection!
    lazy var availableWidth: CGFloat = 0
    lazy var previousPreheatRect = CGRect.zero
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    var model: GalleryModel!
    
    lazy var images:[(PHAsset, IndexPath)] = []
    weak var galleryDelegate: GalleryImagesCollectionViewDelegate?
    var assetIdentifiers: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
    private func setCollectionView() {
        let size = (SCREEN_SIZE.width-4)/3
        thumbnailSize = CGSize(width: size, height: size)
        
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

extension GalleryImagesCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCameraOption {
            return fetchResult.count+1
        } else {
            return fetchResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCameraOption, indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCameraViewCell", for: indexPath) as! GridCameraViewCell
            cell.cornerRadius = 4.0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as! GridViewCell
            let item = isCameraOption ? indexPath.item-1 : indexPath.item
            let asset = fetchResult.object(at: item)
            cell.setPHAsset(asset, imageManager: imageManager, seletedIds: assetIdentifiers)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? GridViewCell {
            let item = isCameraOption ? indexPath.item-1 : indexPath.item
            let asset = fetchResult.object(at: item)
            cell.is_selected = assetIdentifiers.contains(asset.localIdentifier)
        }
    }
    
}

extension GalleryImagesCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
}

extension GalleryImagesCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCameraOption, indexPath.item == 0 {
            galleryDelegate?.galleryOpenCamera()
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? GridViewCell else { return }
            
//            guard cell.isValidSize() else {
//                if cell.asset?.mediaType == .image {
//                    self.showMessage(message: "Images size should be less from 20Mb", isError: .error)
//                } else {
//                    self.showMessage(message: "Videos size should be less from 100MB", isError: .error)
//                }
//                return
//            }
            
            print("is valid video size ***** \(cell.isValidSize())")
            
            let item = isCameraOption ? indexPath.item-1 : indexPath.item
            let asset = fetchResult.object(at: item)
            
            if self.maxSelection == 1 {
                if self.images.contains(where: {$0.1 == indexPath}) {
                    self.images.removeAll()
                    self.assetIdentifiers.removeAll()
                    self.reloadItems(at: [indexPath])
                    return
                }
                var indexs = [IndexPath]()
                if let index = self.images.first?.1 {
                    indexs.append(index)
                }
                self.images.removeAll()
                self.assetIdentifiers.removeAll()
                
                if let cell = collectionView.cellForItem(at: indexPath) as? GridViewCell,
                   let asset = cell.asset {
                    self.images.append((asset, indexPath))
                    indexs.append(indexPath)
                    assetIdentifiers.append(asset.localIdentifier)
                }
                self.reloadItems(at: indexs)
            } else {
                if images.contains(where: {$0.0.localIdentifier == asset.localIdentifier}) == false {
                    if self.images.contains(where: {$0.0.mediaType == .video}) {
                        self.showMessage(message: "You can select one video or \(maxSelection) images at a time", isError: .notification)
                        return
                    }
                    if self.images.count > 0 && asset.mediaType == .video {
                        self.showMessage(message: "You can select one video or \(maxSelection) images at a time", isError: .notification)
                        return
                    }
                }
                if assetIdentifiers.contains(asset.localIdentifier) {
                    assetIdentifiers = assetIdentifiers.filter({$0 != asset.localIdentifier})
                    self.images.removeAll(where: {$0.1 == indexPath})
                } else {
                    if assetIdentifiers.count < maxSelection {
                        assetIdentifiers.append(asset.localIdentifier)
                        self.images.append((asset, indexPath))
                    }
                }
                self.reloadItems(at: [indexPath])
            }
        }
    }
    
}

extension PHAsset {
    
    func getPickerData(complition: @escaping((PickerData?) -> ())) {
        let pickerData = PickerData(index: 0)
        pickerData.fileName = self.originalFilename
        switch mediaType {
        case .image:
            let options = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = false
            self.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, dictionary) in
                if let url = contentEditingInput?.fullSizeImageURL {
                    
                    do {
                        pickerData.data = try Data(contentsOf: url)
                        pickerData.image = UIImage(data: pickerData.data!)
//                        pickerData.uploadData()
                        
                        complition(pickerData)
                        
                    } catch {
                        print("error to find data ******** \(error)")
                    }
                }
            })
        case .video:
            let options = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = false
            self.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, dictionary) in
                if let url = (contentEditingInput?.audiovisualAsset as? AVURLAsset)?.url {
                    pickerData.url = url
                    pickerData.data = url.data
                }
                complition(pickerData)
            })
        default:
            complition(nil)
        }
    }
    
    var originalFilename: String? {
        var fname: String?
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            switch mediaType {
            case .image:
                fname = "IMG_\(Date().miliseconds().inInt).jpg"
            case .video:
                fname = "VID_\(Date().miliseconds().inInt).mov"
            default:
                fname = self.value(forKey: "filename") as? String
            }
        }
        return fname
    }
    
}






//                if self.images.contains(where: {$0.1 == indexPath}) {
//
//                } else {
//                    guard maxSelection > images.count else {
//                        collectionView.deselectItem(at: indexPath, animated: false)
//                        return }
//                    if let cell = collectionView.cellForItem(at: indexPath) as? GridViewCell,
//                       let asset = cell.asset {
//                        self.images.append((asset, indexPath))
//                        assetIdentifiers.append(asset.localIdentifier)
//                    }
//                }




//if asset.mediaSubtypes.contains(.photoLive) {
//    cell.livePhotoBadgeImage = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
//}


//
//
//// MARK: PHPhotoLibraryChangeObserver
//extension GalleryImagesCollectionView: PHPhotoLibraryChangeObserver {
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        
//        guard let changes = changeInstance.changeDetails(for: fetchResult)
//            else { return }
//        
//// Change notifications may originate from a background queue.
//// As such, re-dispatch execution to the main queue before acting
//// on the change, so you can update the UI.
//        
////        DispatchQueue.main.sync {
//        
//// Hang on to the new fetch result.
//            fetchResult = changes.fetchResultAfterChanges
//// If we have incremental changes, animate them in the collection view.
//            if changes.hasIncrementalChanges {
//                guard let collectionView = self.collectionView else { fatalError() }
//// Handle removals, insertions, and moves in a batch update.
//                collectionView.performBatchUpdates({
//                    if let removed = changes.removedIndexes, !removed.isEmpty {
//                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
//                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    changes.enumerateMoves { fromIndex, toIndex in
//                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                to: IndexPath(item: toIndex, section: 0))
//                    }
//                })
//// We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to
//// items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
//                if let changed = changes.changedIndexes, !changed.isEmpty {
//                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
//                }
//            } else {
//// Reload the collection view if incremental changes are not available.
//                collectionView.reloadData()
//            }
//            resetCachedAssets()
////        }
//    }
//}
//
//

////MARK: - Tag: UpdateAssets
//extension GalleryVC {
//
//    fileprivate func updateCachedAssets() {
//        // Update only if the view is visible.
//        guard isViewLoaded && view.window != nil else { return }
//
//        // The window you prepare ahead of time is twice the height of the visible rect.
//        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
//        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
//
//        // Update only if the visible area is significantly different from the last preheated area.
//        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
//        guard delta > view.bounds.height / 3 else { return }
//
//        // Compute the assets to start and stop caching.
//        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
//        let addedAssets = addedRects
//            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
//            .map { indexPath in fetchResult.object(at: indexPath.item) }
//        let removedAssets = removedRects
//            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
//            .map { indexPath in fetchResult.object(at: indexPath.item) }
//
//        // Update the assets the PHCachingImageManager is caching.
//        imageManager.startCachingImages(for: addedAssets,
//                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
//        imageManager.stopCachingImages(for: removedAssets,
//                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
//        // Store the computed rectangle for future comparison.
//        previousPreheatRect = preheatRect
//    }
//
//    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
//        if old.intersects(new) {
//            var added = [CGRect]()
//            if new.maxY > old.maxY {
//                added += [CGRect(x: new.origin.x, y: old.maxY,
//                                 width: new.width, height: new.maxY - old.maxY)]
//            }
//            if old.minY > new.minY {
//                added += [CGRect(x: new.origin.x, y: new.minY,
//                                 width: new.width, height: old.minY - new.minY)]
//            }
//            var removed = [CGRect]()
//            if new.maxY < old.maxY {
//                removed += [CGRect(x: new.origin.x, y: new.maxY,
//                                   width: new.width, height: old.maxY - new.maxY)]
//            }
//            if old.minY < new.minY {
//                removed += [CGRect(x: new.origin.x, y: old.minY,
//                                   width: new.width, height: new.minY - old.minY)]
//            }
//            return (added, removed)
//        } else {
//            return ([new], [old])
//        }
//    }
//}
//

//
//// MARK: UI Actions
///// - Tag: AddAsset
//@IBAction func addAsset(_ sender: AnyObject?) {
//
//    // Create a dummy image of a random solid color and random orientation.
//    let size = (arc4random_uniform(2) == 0) ?
//        CGSize(width: 400, height: 300) :
//        CGSize(width: 300, height: 400)
//    let renderer = UIGraphicsImageRenderer(size: size)
//    let image = renderer.image { context in
//        UIColor(hue: CGFloat(arc4random_uniform(100)) / 100,
//                saturation: 1, brightness: 1, alpha: 1).setFill()
//        context.fill(context.format.bounds)
//    }
//    // Add the asset to the photo library.
//    PHPhotoLibrary.shared().performChanges({
//        let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//        if let assetCollection = self.assetCollection {
//            let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
//            addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
//        }
//    }, completionHandler: {success, error in
//        if !success { print("Error creating the asset: \(String(describing: error))") }
//    })
//}


//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        updateCachedAssets()
//    }



//            cell.isSelected = assetIdentifiers.contains(asset.localIdentifier)
//            print("id *** \(asset.localIdentifier)  ______  \(assetIdentifiers)")
//            cell.isSelected = images.contains(where: {$0.1 == indexPath})
