//
//  GetImageFromPicker.swift
//  Tookan
//
//  Created by Nitin Kumar on 25/09/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
//import CropViewController


class GetImageFromPicker: NSObject {
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
    
    enum Error:String {
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

    enum PickerResult {
        case success(PickerData?)
        case error(String)
    }
    
    var imageCallBack: ((_ result: PickerResult) -> Void)?
    private var pickerType: PickerType? = .both
    private var imagePicker: UIImagePickerController? = UIImagePickerController()
    private var cameraButtonTitle = "Camera"
    private var galleryButtonTitle = "Gallery"
    private var alertTitle = "Upload image from "
    var index = -1
    private var visibleController: UIViewController?
    var mediaType: MediaType = .image

    
    override init() {}
    
    public func setImagePicker(imagePickerType: PickerType = .both, tag: Int = -1, controller: UIViewController?) {
        self.pickerType = imagePickerType
        
        self.index = tag
        if controller == nil {
            guard let rootViewController = Singleton.window?.rootViewController as? UINavigationController else {
                return
            }
            guard let visibleController = rootViewController.visibleViewController else {
                return
            }
            self.visibleController = visibleController
        } else {
            self.visibleController = controller
        }
        self.showAlert()
    }
    
    private func showAlert() {
        DispatchQueue.main.async {
            switch self.pickerType! {
            case .camera:
                self.cameraAction()
            case .gallery:
                self.galleryAction()
            default:
                let alert = UIAlertController(title: self.alertTitle, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                self.addCameraAction(alert: alert)
                self.addGalleryAction(alert: alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
                    UIAlertAction in
                }
                alert.addAction(cancelAction)
//                DispatchQueue.main.async {
                    self.visibleController?.present(alert, animated: true, completion: nil)
//                }
            }
        }
    }
    
    private func addCameraAction(alert:UIAlertController) {
        DispatchQueue.main.async {
            let cameraAction = UIAlertAction(title: self.cameraButtonTitle, style: UIAlertAction.Style.default){
                UIAlertAction in
                self.cameraAction()
            }
            alert.addAction(cameraAction)
        }
    }
    
    private func addGalleryAction(alert:UIAlertController) {
        DispatchQueue.main.async {
            let gallaryAction = UIAlertAction(title: self.galleryButtonTitle, style: UIAlertAction.Style.default){
                UIAlertAction in
                self.galleryAction()
            }
            alert.addAction(gallaryAction)
        }
    }
    
    private func cameraAction() {
        self.checkCameraAutorizationStatus(completion: {(isAuthorized) in
            DispatchQueue.main.async {
                guard isAuthorized == true else {
                    self.imageCallBack!(.error(Error.REJECTED_CAMERA_SUPPORT.message()))
                    return
                }
                
                self.openCamera()
            }
        })
    }
    
    private func galleryAction() {
        self.checkGalleryAuthorizationStatus(completion: { (isAuthorized) in
            DispatchQueue.main.async {
                guard isAuthorized == true else {
                    self.imageCallBack!(.error(Error.REJECTED_GALLERY_ACCESS.message()))
                    return
                }
                self.openGallery()
            }
        })
    }
    
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
    
    private func openCamera() {
//        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = true
//        self.imagePicker?.mediaTypes = mediaType.type
//        self.imagePicker?.videoMaximumDuration = 60
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                //self.imagePicker?.allowsEditing = false
                self.imagePicker?.sourceType = UIImagePickerController.SourceType.camera
                guard let picker = self.imagePicker else {
                    self.imageCallBack!(.error(Error.SOMETHING_WRONG.message()))
                    return
                }
                if self.mediaType == .image {
                    self.imagePicker?.mediaTypes = MediaType.image.type
                } else {
                    self.imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                    self.imagePicker?.videoMaximumDuration = 60
                }
               self.visibleController?.present(picker, animated: true, completion: nil)
            }
        } else {
            self.imageCallBack!(.error(Error.NO_CAMERA_SUPPORT.message()))
        }
    }
    
    private func openGallery() {
//        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = true
        self.imagePicker?.mediaTypes = mediaType.type
        self.imagePicker?.videoMaximumDuration = 60
        imagePicker?.navigationBar.isMultipleTouchEnabled = false
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            DispatchQueue.main.async {
                self.imagePicker?.sourceType = UIImagePickerController.SourceType.photoLibrary
                guard let picker = self.imagePicker else {
                    self.imageCallBack!(.error(Error.SOMETHING_WRONG.message()))
                    return
                }
                self.visibleController?.present(picker, animated: true, completion: nil)
            }
        } else {
            self.imageCallBack!(.error(Error.NO_GALLERY_SUPPORT.message()))
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        let scale: CGFloat = 1.0
        let targetOrigin: CGFloat = 0.0
        var newHeight = image.size.width * scale
        var newWidth = image.size.width * scale
        
        if imageWidth == imageHeight {
            return image
        } else if imageHeight > imageWidth {
            newHeight = imageWidth
            newWidth = imageWidth
        } else {
            newHeight = imageHeight
            newWidth = imageHeight
        }
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: targetOrigin, y: targetOrigin, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if newImage != nil {
            return newImage!
        } else {
            return image
        }
    }
   
}



//MARK: ImagePickerDelegate Methods
extension GetImageFromPicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            let imageUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            
            
            var fileName: String?
            if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset {
                fileName = asset.value(forKey: "filename") as? String
            }
            if fileName == nil {
                if imageUrl?.absoluteString.isImageType ?? true {
                    fileName = "IMG_\(Date().miliseconds().inInt)"
                } else {
                    fileName = "VID_\(Date().miliseconds().inInt)"
                }
                if let pathExtension = imageUrl?.pathExtension {
                    fileName! += ".\(pathExtension)"
                } else {
                    fileName! += ".jpg"
                }
            }
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                image = editedImage
            }
            
            let data = PickerData(fileName, imageUrl, image, self.index)
            
            if let pathExtension = imageUrl?.pathExtension,
               pathExtension.lowercased() == "gif" {
                data.data = imageUrl?.data
                data.fileSize = data.data?.count
                picker.dismiss(animated: false, completion: nil)
                self.imageCallBack?(.success(data))
                return
            } else {
                data.data = image?.jpegData(compressionQuality: 0.6)
                data.image = image
                print("data.image ********    \(data.image) ******** data \(data.data) ")
            }
            data.fileSize = data.data?.count
            
            
            print("data *************** \(data.image) ")
            print("data *************** \(data.data?.count) ")
            print("data *************** \(data.url) ")
            
            self.imageCropperViewController(picker: picker, pickerData: data)
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
            picker.dismiss(animated: false) {}
//            pickerData.checkVideoThumb()
            self.imageCallBack?(.success(pickerData))
//        }
    }
    
}
//
//extension GetImageFromPicker : CropViewControllerDelegate {
//    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
//        self.pickerData?.image = cropped
//        self.pickerData?.data = cropped.pngData()
//        self.dismissViewController(cropViewController: cropViewController)
//    }
//
//    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
//        self.pickerData = nil
//        self.dismissViewController(cropViewController: cropViewController)
//    }
//
//    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
//        self.pickerData = nil
//        self.dismissViewController(cropViewController: cropViewController)
//    }
//
//    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
//    }
//
//    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
//
//    }
//
//    func cropViewControllerWillDismiss(_ cropViewController: CropViewController) {
//    }
//
//
//    func dismissViewController(cropViewController: CropViewController) {
//        cropViewController.dismiss(animated: false) {
//            DispatchQueue.main.async {
//                self.imagePicker?.dismiss(animated: false, completion: {
//                    DispatchQueue.main.async {
//                        if let data = self.pickerData {
//                            self.imageCallBack?(.success(data))
//                        }
//                    }
//                })
//            }
//        }
//    }
//
//}










//
////MARK: ImagePickerDelegate Methods
//extension GetImageFromPicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
////        let updatedImage = self.resizeImage(image: image)
////        ActivityIndicator.shared.show()
////        picker.dismiss(animated: true) {
////            DispatchQueue.main.async {
////                if self.imageCallBack != nil {
////                    self.imageCallBack!(.success(updatedImage, self.index))
////                }
////            }
////        }
////    }
//
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
//        let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
//
//        var fileName:String?
//
//        if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset {
//             fileName = asset.value(forKey: "filename") as? String
//        }
//        if fileName == nil {
//            fileName = "IMG_\(Date().miliseconds().inInt).JPG"
//        }
//
//
////        print("url ==== \(info[UIImagePickerController.InfoKey.imageURL] as! URL)")
//
////        let cropViewController = CropViewController(image: image)
////        cropViewController.delegate = self
////        picker.present(cropViewController, animated: true, completion: nil)
//
////        var updatedImage:UIImage?
////        if image != nil {
////            updatedImage = self.resizeImage(image: image!)
////        } else {
////            updatedImage = self.resizeImage(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
////        }
////        guard let newImage = updatedImage else {return}
//        //ActivityIndicator.shared.show()
//
//
//        picker.dismiss(animated: false) {
//            DispatchQueue.main.async {
//                if self.imageCallBack != nil {
//                    let data = PickerData(fileName, imageUrl, image, self.index)
//                    data.data = image.jpegData(compressionQuality: 1.0)
//                    data.fileSize = data.data?.count
//                    self.imageCallBack!(.success(data))
//                }
//            }
//        }
//    }
//
//
//    func presentCropViewController(image:UIImage) {
//
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
//
////extension GetImageFromPicker: CropViewControllerDelegate {
////    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
////        cropViewController.dismiss(animated: false) {
////            self.imagePicker?.dismiss(animated: false) {
////                DispatchQueue.main.async {
////                    if self.imageCallBack != nil {
////                        self.imageCallBack!(.success(image, self.index))
////                    }
////                }
////            }
////        }
////    }
////}
