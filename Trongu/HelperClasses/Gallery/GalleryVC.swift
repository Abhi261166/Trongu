//
//  GalleryVC.swift
//  meetwise
//
//  Created by Nitin Kumar on 23/07/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit
import Photos
import PhotosUI



protocol GalleryVCDelegate: NSObjectProtocol {
    func galleryController(_ gallery: GalleryVC, didselect videos: [AVURLAsset], assetIds: [String], localIdentifier: String)
    func galleryController(_ gallery: GalleryVC, didselect images: [PHAsset], assetIds: [String])
    func galleryControllerOpenCamera(_ gallery: GalleryVC)
}

class GalleryVC: UIViewController {
    
    @IBOutlet weak var tableView: GalleryAlbumTableView!
    @IBOutlet weak var collectionView: GalleryImagesCollectionView!
    @IBOutlet weak var selectAlbumButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableBackgroundView: UIView!
    
    
    lazy var assetIdentifiers: [String] = []
    lazy var isCameraOption: Bool = false
    var delegate: GalleryVCDelegate?
    lazy var maxSelection: Int = 10
    var pickerType: ImagePickerControllerType = .both
    var isAddStory:Bool = false
    
    init(isCameraOption: Bool = false, delegate: GalleryVCDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.isCameraOption = isCameraOption
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.assetIdentifiers = self.assetIdentifiers
        collectionView.isCameraOption = isCameraOption
        collectionView.galleryDelegate = self
        
        tableView.galleryDelegate = self
        tableBackgroundView.isHidden = true
        
//        scrollView.isScrollEnabled = false
        
        let height = tableView.frame.height
        self.tableView.transform = .init(translationX: 0, y: -height)
        collectionView.setImageCollection(type: pickerType)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGalleryPermission()
        collectionView.maxSelection = self.maxSelection
    }
    
    private func setGalleryPermission() {
        
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            if (newStatus == PHAuthorizationStatus.authorized) {
            } else {
                let model = PushModel(json: ["title": "Please enable permission for camera"])
                Singleton.shared.showErrorMessage(pushData: model, isError: .error) { model in
                    DispatchQueue.main.async {
                        print("tap on error message")
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                }
            }
        })
    }
    
    
    @IBAction func selectAlbumAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        let height = tableView.frame.height
        if sender.isSelected {
            self.tableView.transform = .init(translationX: 0, y: -height)
            self.tableBackgroundView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            if sender.isSelected {
                sender.imageView?.transform = .init(rotationAngle: CGFloat.pi)
                self.tableView.transform = .identity
            } else {
                sender.imageView?.transform = .identity
                self.tableView.transform = .init(translationX: 0, y: -height)
            }
        } completion: { ani in
            if !sender.isSelected {
                self.tableBackgroundView.isHidden = true
            }
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        let assets = self.collectionView.images.map({$0.0})
        print("assets count are \(assets.count) \(delegate == nil)")
        if assets.first?.mediaType == .video , let asset = assets.first  {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: {(vidAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                DispatchQueue.main.async {
                    if let urlAsset = vidAsset as? AVURLAsset {
                        let localVideoUrl: URL = urlAsset.url as URL
                        let vc = VideoTrimmerVC(url: localVideoUrl, delegate: self)
                        vc.assetId = asset.localIdentifier
                        self.present(vc, true)
                    } else {
                        
                    }
                }
            })
        } else {
            self.delegate?.galleryController(self, didselect: assets, assetIds: self.collectionView.assetIdentifiers)
        }
    }
    
}

extension GalleryVC : GalleryAlbumTableViewDelegate {
    func tableView(selection: GalleryAlbumTableView.Section, didSelect ablum: PHCollection?) {
        var title: String = ""
        switch selection {
        case .allPhotos:
            self.collectionView.fetchResult = GalleryModel(type: pickerType).allPhotos
            title = "All Photos"
        case .smartAlbums, .userCollections:
            if let assetCollection = ablum as? PHAssetCollection {
                title = assetCollection.localizedTitle ?? "Photos"
                
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: pickerType.predicates)
                options.predicate = predicate
                
                let result = PHAsset.fetchAssets(in: assetCollection, options: options)
                self.collectionView.fetchResult = result
            }
        }
        let height = tableView.frame.height
        UIView.animate(withDuration: 0.3) { [self] in
            selectAlbumButton.imageView?.transform = .identity
            tableView.transform = .init(translationX: 0, y: -height)
            selectAlbumButton.setTitle(title, for: .normal)
        } completion: { ani in
            self.selectAlbumButton.isSelected = false
            self.tableBackgroundView.isHidden = true
        }
    }
}

extension GalleryVC: GalleryImagesCollectionViewDelegate {
    func galleryOpenCamera() {
        print("open camera")
        self.delegate?.galleryControllerOpenCamera(self)
    }
    
    func didSelect(item atIndex: IndexPath) {
        print("did Select image")
    }
    
}

extension GalleryVC: VideoTrimmerVCDelegate {
    
    func videoTrimmer(_ viewController: VideoTrimmerVC, didTrimVideo url:URL?, failedTrimming error: Error?) {
//        self.delegate?.galleryController(self, didselect: assets, assetIds: self.collectionView.assetIdentifiers)
        if let url = url {
            viewController.dismiss(animated: false) {
                DispatchQueue.main.async {
                    let asset = AVURLAsset(url: url)
                    self.delegate?.galleryController(self, didselect: [asset], assetIds: self.collectionView.assetIdentifiers, localIdentifier: viewController.assetId)
                }
            }
        }
    }
    
    func videoTrimmerDidCancel(_ viewController: VideoTrimmerVC) {
    }
    
}
