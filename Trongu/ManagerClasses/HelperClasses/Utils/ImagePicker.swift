//
//  ImagePicker.swift
//  Clout Lyfe
//
//  Created by apple on 03/06/22.
//

import UIKit
import AVFoundation
import Photos

protocol ImagePickerDelegate: NSObjectProtocol {
    func imagePicker(_ picker: ImagePicker, didSelect data: [PickerData]?, assetIds: [String])
    func imagePicker(_ picker: ImagePicker, didCapture data: PickerData?)
    func imagePicker(_ picker: ImagePicker, didFinish withError: ImagePicker.Error)
}

class ImagePicker: NSObject {
    enum PickerType {
        case camera
        case gallery
        case both
    }
    
    enum MediaType {
        case image
        case video
        case both
        
        var type: [String] {
            switch self {
            case .video: return ["public.movie"]
            case .image: return ["public.image"]
            case .both: return ["public.image", "public.movie"]
            }
        }
    }
    enum Error: String {
        case REJECTED_CAMERA_SUPPORT
        case REJECTED_GALLERY_ACCESS
        case SOMETHING_WRONG
        case NO_CAMERA_SUPPORT
        case NO_GALLERY_SUPPORT
        
        func message() -> String {
            switch self {
            case .REJECTED_CAMERA_SUPPORT:
                return "Need permission to open camera"
            case .REJECTED_GALLERY_ACCESS:
                return "Need permission to open Gallery"
            case .SOMETHING_WRONG:
                return "Something went wrong. Please try again."
            case .NO_CAMERA_SUPPORT:
                return "This device does not support camera"
            case .NO_GALLERY_SUPPORT:
                return "Photo library not found in this device."
            }
        }
    }
    
    var delegate: ImagePickerDelegate?
    var controller: UIViewController?
    private var imagePicker: UIImagePickerController?
    private var pickerType: PickerType = .both
    private var cameraButtonTitle = "Camera"
    private var galleryButtonTitle = "Gallery"
    private var alertTitle = "Upload image from"
    var mediaType: MediaType = .image
    var selectedAssetIds:[String] = []
    
    
    override init() {}
    
    public func setImagePicker(imagePickerType: PickerType = .both, controller: UIViewController?, delegate: ImagePickerDelegate?) {
        self.pickerType = imagePickerType
        self.delegate  = delegate
        if controller == nil {
            let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
            guard let rootViewController = window?.rootViewController as? UINavigationController else {
                return
            }
            guard let visibleController = rootViewController.visibleViewController else {
                return
            }
            self.controller = visibleController
        } else {
            self.controller = controller
        }
        self.showAlert()
    }
    
    private func showAlert() {
        DispatchQueue.main.async {
            switch self.pickerType {
            case .camera:
                self.cameraAction()
            case .gallery:
                self.galleryImageAction()
            default:
                let alert = UIAlertController(title: self.alertTitle, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                self.addCameraAction(alert: alert)
                self.addGalleryImageAction(alert: alert)
                if self.mediaType == .both {
                    self.addGalleryVideoAction(alert: alert)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
                    UIAlertAction in
                }
                alert.addAction(cancelAction)
                DispatchQueue.main.async {
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
//    MARK: - addCameraAction
    private func addCameraAction(alert:UIAlertController) {
        DispatchQueue.main.async {
            let cameraAction = UIAlertAction(title: self.cameraButtonTitle, style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.cameraAction()
            }
            alert.addAction(cameraAction)
        }
    }
    
//    MARK: - addGalleryVideoAction
    private func addGalleryVideoAction(alert: UIAlertController) {
        DispatchQueue.main.async {
            let gallaryAction = UIAlertAction(title: "Select Video", style: UIAlertAction.Style.default){
                UIAlertAction in
                self.galleryVideoAction()
            }
            alert.addAction(gallaryAction)
        }
    }
    
//    MARK: - addGalleryImageAction
    private func addGalleryImageAction(alert: UIAlertController) {
        DispatchQueue.main.async {
            let gallaryAction = UIAlertAction(title: "Select images", style: UIAlertAction.Style.default){
                UIAlertAction in
                self.galleryImageAction()
            }
            alert.addAction(gallaryAction)
        }
    }
    
//    MARK: - cameraAction
    private func cameraAction() {
        self.checkCameraAutorizationStatus(completion: {(isAuthorized) in
            DispatchQueue.main.async {
                guard isAuthorized == true else {
                    self.delegate?.imagePicker(self, didFinish: .REJECTED_CAMERA_SUPPORT)
                    return
                }
                self.openCamera()
            }
        })
    }
    
//    MARK: - galleryVideoAction
    private func galleryVideoAction() {
        self.checkGalleryAuthorizationStatus(completion: { (isAuthorized) in
            DispatchQueue.main.async {
                guard isAuthorized == true else {
                    self.delegate?.imagePicker(self, didFinish: .REJECTED_GALLERY_ACCESS)
                    return
                }
                self.openVideoGallery()
            }
        })
    }
    
//    MARK: - galleryImageAction
    private func galleryImageAction() {
        self.checkGalleryAuthorizationStatus(completion: { (isAuthorized) in
            DispatchQueue.main.async {
                guard isAuthorized == true else {
                    self.delegate?.imagePicker(self, didFinish: .REJECTED_GALLERY_ACCESS)
                    return
                }
                self.openImageGallery()
            }
        })
    }
//    MARK: - checkCameraAutorizationStatus
    private func checkCameraAutorizationStatus(completion: ((Bool) -> Void)?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
        completion?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        default:
            return (completion?(false))!
        }
    }
    
//    MARK: - checkGalleryAuthorizationStatus
    private func checkGalleryAuthorizationStatus(completion: ((Bool) -> Void)?) {
        let authStatus = PHPhotoLibrary.authorizationStatus() //PHPhotoLibrary.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized:
            completion?(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization{ grantedStatus in
                switch grantedStatus {
                case .authorized:
                    completion?(true)
                default:
                    (completion?(false))!
                }
            }
        default:
            return (completion?(false))!
        }
    }
    
//    MARK: - checkGalleryAuthorizationStatus
    private func openCamera() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                //self.imagePicker?.allowsEditing = false
                self.imagePicker?.sourceType = UIImagePickerController.SourceType.camera
                guard let picker = self.imagePicker else {
                    self.delegate?.imagePicker(self, didFinish: .SOMETHING_WRONG)
                    return
                }
                if self.mediaType == .image {
                    self.imagePicker?.mediaTypes = MediaType.image.type
                } else {
                    self.imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                    self.imagePicker?.videoMaximumDuration = 60
                }
               self.controller?.present(picker, animated: true, completion: nil)
            }
        } else {
            self.delegate?.imagePicker(self, didFinish: .NO_CAMERA_SUPPORT)
        }
    }
    
//    MARK: - openImageGallery
    private func openImageGallery() {
        DispatchQueue.main.async {
            let vc = GalleryVC(isCameraOption: false, delegate: self)
            vc.pickerType       = .image
            vc.assetIdentifiers = self.selectedAssetIds
            vc.maxSelection     = 10
            self.controller?.present(vc, true)
        }
    }
    
//    MARK: - openVideoGallery
    private func openVideoGallery() {
        DispatchQueue.main.async {
            let vc = GalleryVC(isCameraOption: false, delegate: self)
            vc.assetIdentifiers = self.selectedAssetIds
            vc.pickerType       = .video
            vc.maxSelection     = 1
            self.controller?.present(vc, true)
        }
    }
    
    
//    private func openGallery() {
////        self.imagePicker = UIImagePickerController()
//        self.imagePicker?.delegate = self
//        self.imagePicker?.allowsEditing = false
//        self.imagePicker?.mediaTypes = mediaType.type
//        self.imagePicker?.videoMaximumDuration = 60
//        imagePicker?.navigationBar.isMultipleTouchEnabled = false
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            DispatchQueue.main.async {
//                self.imagePicker?.sourceType = UIImagePickerController.SourceType.photoLibrary
//                guard let picker = self.imagePicker else {
//                    self.delegate?.imagePicker(self, didFinish: .SOMETHING_WRONG)
//                    return
//                }
//                self.controller?.present(picker, animated: true, completion: nil)
//            }
//        } else {
//            self.delegate?.imagePicker(self, didFinish: .NO_GALLERY_SUPPORT)
//        }
//    }
        
}

//MARK: ImagePickerDelegate Methods
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            var imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
        
            if imageUrl == nil, let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                imageUrl = url
                print("imageUrl **************** \(String(describing: imageUrl)) ******* url *********\(url)")
            }
//            if let data = imageUrl?.data {
////                let type = Swime.mimeType(data: data)
////                print("type \(type?.mime) ext \(type?.ext) ** \(type?.mime)")
//            }
            var fileName: String?
            if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset {
                fileName = asset.value(forKey: "filename") as? String
            }
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            let data = PickerData(fileName, imageUrl, image, 0)
            if fileName == nil {
                if imageUrl?.absoluteString.isImageType ?? true {
                    fileName = "IMG_\(Date().miliseconds().inInt)"
                    data.type = .image
                } else {
                    fileName = "VID_\(Date().miliseconds().inInt)"
                    data.type = .video
                }
                if let pathExtension = imageUrl?.pathExtension {
                    fileName! += ".\(pathExtension)"
                } else {
                    fileName! += ".jpg"
                }
                data.fileName = fileName
            }
            print("file name is \(fileName)")
            print("data **************** \(data) (data.image ************************ \(data.image) data.imageUrl *********************\(data.url)")
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if let pathExtension = imageUrl?.pathExtension,
                   pathExtension.lowercased() == "gif" {
                    data.data = imageUrl?.data
                    data.fileSize = data.data?.count
                    picker.dismiss(animated: false, completion: nil)
                    data.id = data.fileName
                    self.delegate?.imagePicker(self, didCapture: data)
                    return
                } else {
                    data.data = image.pngData()
                    print("data.image *********    \(data.image) ********* data \(data) ")
                }
            } else {
                data.data = imageUrl?.data
                imageUrl?.getThumbnailImageFromVideoUrl(completion: { image in
                    DispatchQueue.main.async {
                        data.image = image
                    }
                })
                if data.id?.count ?? 0 == 0 {
                    data.id   = data.fileName
                }
            }
            data.fileSize = data.data?.count
            picker.dismiss(animated: false) {
                self.delegate?.imagePicker(self, didCapture: data)
            }
//            self.imageCropperViewController(picker: picker, pickerData: data)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageCropperViewController(picker: UIImagePickerController, pickerData: PickerData) {
//        self.pickerData = pickerData
//        if let image = pickerData.image {
//            let cropperVC = Mantis.cropViewController(image: image)
//            cropperVC.delegate = self
//            cropperVC.modalPresentationStyle = .overFullScreen
//            picker.present(cropperVC, animated: true)
//        } else {
            picker.dismiss(animated: false) {
                self.delegate?.imagePicker(self, didSelect: [pickerData], assetIds: [])
            }
//            pickerData.checkVideoThumb()
//            self.imageCallBack?(.success(pickerData))
//        }
    }
    
}

extension ImagePicker: GalleryVCDelegate {
    func galleryController(_ gallery: GalleryVC, didselect videos: [AVURLAsset], assetIds: [String], localIdentifier: String) {
        let pickerItems = videos.map({PickerData(video: $0, identifier: localIdentifier)})
        gallery.dismiss(animated: true) {
            self.delegate?.imagePicker(self, didSelect: pickerItems, assetIds: assetIds)
        }
    }
    
    func galleryControllerOpenCamera(_ gallery: GalleryVC) {
    }
    
    func galleryController(_ gallery: GalleryVC, didselect images: [PHAsset], assetIds: [String]) {
        let pickerItems = images.map({PickerData(asset: $0)})
        gallery.dismiss(animated: true) {
            self.delegate?.imagePicker(self, didSelect: pickerItems, assetIds: assetIds)
        }
    }
}
