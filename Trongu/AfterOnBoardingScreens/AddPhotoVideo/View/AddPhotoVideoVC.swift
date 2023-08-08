//
//  AddPhotoVideoVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import YPImagePicker
import CoreLocation

class AddPhotoVideoVC: UIViewController {

    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBOutlet weak var addPhotoVideoCollectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    
    var postImage = ["AddImage_1","AddImage_2"]
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var selectedItems = [YPMediaItem]()
    var selectedIndex:IndexPath?
    var completion : (( _ posts:[YPMediaItem]) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableviewDelegates()
        
        if selectedItems.count == 0 {
            disableTextFileds()
        }else{
            enableTextFileds()
        }
        
        addDatePicker()
        addTimePicker()
        
    }
    
    func addDatePicker(){
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
           
        }
        datePicker.locale = Locale.current
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateTF.inputView = datePicker

    }
    func addTimePicker(){
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
           
        }
    //    timePicker.locale = Locale.current
        timePicker.date = Date()
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        timeTF.inputView = timePicker
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTF.text = dateFormatter.string(from: sender.date)
    }

    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeTF.text = timeFormatter.string(from: sender.date)
    }
    
    func disableTextFileds(){
        btnAddAddress.isEnabled = false
        timeTF.isUserInteractionEnabled = false
        placeTF.isUserInteractionEnabled = false
        dateTF.isUserInteractionEnabled = false
    }
    
    func enableTextFileds(){
        btnAddAddress.isEnabled = true
        timeTF.isUserInteractionEnabled = true
        placeTF.isUserInteractionEnabled = true
        dateTF.isUserInteractionEnabled = true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func addAction(_ sender: UIButton) {
      
        debugPrint("selected items is --- ",self.selectedItems)
        
        if let completion = self.completion{
            popVC()
            Singleton.shared.showMessage(message: "Post images and videos added sucsessfully, Now please enter remaning information and post. ", isError: .success)
            completion(selectedItems)
        }
    }
    
    @IBAction func addAddress(_ sender: UIButton) {
        let vc = AddLocationVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTableviewDelegates(){
        self.addPhotoVideoCollectionView.delegate = self
        self.addPhotoVideoCollectionView.dataSource = self
        self.addPhotoVideoCollectionView.register(UINib(nibName: "AddPhotoVideoCVCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotoVideoCVCell")
    }
    
   
    
}
extension AddPhotoVideoVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.selectedItems.count
        if count > 0 {
           
            return count > 9 ? count : count + 1
            
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoVideoCVCell", for: indexPath) as! AddPhotoVideoCVCell
       
        if selectedItems.count > 0{
           
            self.enableTextFileds()
            
            if indexPath.row == selectedItems.count{
                cell.btnCross.isHidden = true
                cell.postImage.image = UIImage(named: "AddImage_2")
                cell.postImage.borderWidth = 0
            }else{
                cell.btnCross.isHidden = false
                 let post = selectedItems[indexPath.row]
                switch post{
                case .photo(p: let photo):
                    cell.postImage.image = photo.image
                    print("Lat -- ",photo.asset?.location?.coordinate.latitude ?? 0.0)
                    print("Long -- ",photo.asset?.location?.coordinate.longitude ?? 0.0)
                    print("Date Time -- ",photo.asset?.creationDate ?? Date())
                case .video(v: let video):
                    cell.postImage.image = video.thumbnail
                    print("Lat -- ",video.asset?.location?.coordinate.latitude ?? 0.0)
                    print("Long -- ",video.asset?.location?.coordinate.longitude ?? 0.0)
                    print("Date Time -- ",video.asset?.creationDate ?? Date())
                }
                
                cell.btnCross.tag = indexPath.row
                cell.btnCross.addTarget(target: self, action: #selector(actionCross))
                
                if selectedIndex == indexPath{
                    cell.postImage.borderWidth = 2
                    cell.postImage.borderColor = UIColor(named: "OrengeAppColour")
                    self.showMetaDataInTextFileds(index: indexPath.row)
                    
                }else{
                    cell.postImage.borderWidth = 0
                }
                
            }
            
        }else{
            cell.btnCross.isHidden = true
            cell.postImage.image = UIImage(named: "AddImage_2")
            cell.postImage.borderWidth = 0
            
            self.disableTextFileds()
        }
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == selectedItems.count{
            print("Add post")
            showPicker()
        }else{
            self.selectedIndex = indexPath
            self.showMetaDataInTextFileds(index: indexPath.row)
            self.addPhotoVideoCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 165)
    }
    
    func scrollToLastItem() {
           let lastSection = addPhotoVideoCollectionView.numberOfSections - 1
           guard lastSection >= 0 else { return }
           
           let lastItem = addPhotoVideoCollectionView.numberOfItems(inSection: lastSection) - 1
           guard lastItem >= 0 else { return }
           
           let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
           addPhotoVideoCollectionView.scrollToItem(at: lastIndexPath, at: .right, animated: true)
       }
    
    
    @objc func actionCross(sender:UIButton){
        self.selectedItems.remove(at: sender.tag)
        
        // is last element
        
        if (selectedItems.count) == sender.tag{
           
            //text filed data start
            
            self.selectedIndex = IndexPath(row: sender.tag - 1, section: 0)
            
            if selectedItems.count != 0{
                self.showMetaDataInTextFileds(index: sender.tag - 1)
            }else{
                self.disableTextFileds()
                
            }
           
            
            //text filed data end
            
            self.addPhotoVideoCollectionView.reloadData()
            scrollToLastItem()
        }else{
            self.selectedIndex = IndexPath(row: selectedItems.count - 1, section: 0)
            
            //text filed data start
            
            self.showMetaDataInTextFileds(index: selectedItems.count - 1)

            //text filed data end
            
            self.addPhotoVideoCollectionView.reloadData()
            print("Not last Index-- Index is ",sender.tag)
        }
        
    }
    
}

extension AddPhotoVideoVC{
    
    func showPicker() {
        btnBack.isHidden = true
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        config.library.mediaType = .photoAndVideo
        config.shouldSaveNewPicturesToAlbum = false
        config.library.itemOverlayType = .grid
        config.video.compression = AVAssetExportPresetPassthrough
        config.startOnScreen = .library
        config.screens = [.library, .photo, .video]
        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8
        config.video.libraryTimeLimit = 500.0
       // config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        config.gallery.hidesRemoveButton = false
        config.library.preselectedItems = selectedItems
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [weak picker] items, cancelled in
            self.btnBack.isHidden = false
            if cancelled {
                print("Picker was canceled")
                picker?.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            
            let post = self.selectedItems.last
               switch post{
               case .photo(p: let photo):
                   self.selectedIndex = IndexPath(row: self.selectedItems.count - 1, section: 0)
                   self.getAddressFromLatLong(latitude: photo.asset?.location?.coordinate.latitude ?? 0.0, longitude: photo.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
                       
                       if address ?? "" == "North Atlantic Ocean"{
                           self.placeTF.text = ""
                       }else{
                           self.placeTF.text = address
                       }
                       print("Got address from picker -----",address ?? "")
                         
                   })
                   self.dateTF.text = photo.asset?.creationDate?.dateToString(format: "dd/MM/yyyy")
                   self.timeTF.text = photo.asset?.creationDate?.dateToString(format: "h:mm a")
                  
               case .video(v: let video):
                   self.selectedIndex = IndexPath(row: self.selectedItems.count - 1, section: 0)
                   self.getAddressFromLatLong(latitude: video.asset?.location?.coordinate.latitude ?? 0.0, longitude: video.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
                       if address ?? "" == "North Atlantic Ocean"{
                           self.placeTF.text = ""
                       }else{
                           self.placeTF.text = address
                       }
                       print("Got address from picker -----",address ?? "")
                       self.dateTF.text = video.asset?.creationDate?.dateToString(format: "dd/MM/yyyy")
                       self.timeTF.text = video.asset?.creationDate?.dateToString(format: "h:mm a")
                   })
                   
               case .none:
                   print("No Photo Selected")
               }
            picker?.dismiss(animated: true, completion: nil)
            self.addPhotoVideoCollectionView.reloadData()
            self.scrollToLastItem()
            
//            if let firstItem = items.first {
//                switch firstItem {
//                case .photo(let photo):
//                   // self.selectedImageV.image = photo.image
//                  //  self.arrPosts.append(photo.image)
//                    picker?.dismiss(animated: true, completion: nil)
//
//                case .video(let video):
//                   // self.selectedImageV.image = video.thumbnail
//
//                    let assetURL = video.url
//                    let playerVC = AVPlayerViewController()
//                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
//                    playerVC.player = player
//
//                    picker?.dismiss(animated: true, completion: { [weak self] in
//                        self?.present(playerVC, animated: true, completion: nil)
//                       // print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
//                    })
//                }
//            }
            
        }
        
       
        
    }
    
}

extension AddPhotoVideoVC: YPImagePickerDelegate {
    func noPhotos() {
        print("No Photos")
    }
    
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
        // PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }

    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true // indexPath.row != 2
    }
}

extension AddPhotoVideoVC{
    
    func getAddressFromLatLong(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error geocoding location: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                // Create a dictionary to hold the address components
                var addressComponents = [String]()

                if let name = placemark.name {
                    addressComponents.append(name)
                }

//                if let thoroughfare = placemark.thoroughfare {
//                    addressComponents.append(thoroughfare)
//                }

//                if let subThoroughfare = placemark.subThoroughfare {
//                    addressComponents.append(subThoroughfare)
//                }

                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }

//                if let administrativeArea = placemark.administrativeArea {
//                    addressComponents.append(administrativeArea)
//                }

//                if let postalCode = placemark.postalCode {
//                    addressComponents.append(postalCode)
//                }

//                if let country = placemark.country {
//                    addressComponents.append(country)
//                }

                // Join all the address components to get the complete address
                let address = addressComponents.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func showMetaDataInTextFileds(index:Int){
        
        let post = selectedItems[index]
       switch post{
       case .photo(p: let photo):
           getAddressFromLatLong(latitude: photo.asset?.location?.coordinate.latitude ?? 0.0, longitude: photo.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
               if address ?? "" == "North Atlantic Ocean"{
                   self.placeTF.text = ""
               }else{
                   self.placeTF.text = address
               }
               print("Got address from picker -----",address ?? "")
               self.dateTF.text = photo.asset?.creationDate?.dateToString(format: "dd/MM/yyyy")
               self.timeTF.text = photo.asset?.creationDate?.dateToString(format: "h:mm a")
               
           })
          
       case .video(v: let video):
           getAddressFromLatLong(latitude: video.asset?.location?.coordinate.latitude ?? 0.0, longitude: video.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
               if address ?? "" == "North Atlantic Ocean"{
                   self.placeTF.text = ""
               }else{
                   self.placeTF.text = address
               }
               print("Got address from picker -----",address ?? "")
               self.dateTF.text = video.asset?.creationDate?.dateToString(format: "dd/MM/yyyy")
               self.timeTF.text = video.asset?.creationDate?.dateToString(format: "h:mm a")
           })
       }
        
    }
    
    func getDate(date:Date){
       
        
    }
    
}

extension AddPhotoVideoVC:AddLocationVCDelegate{
    
    func setLocation(text: String, lat: Double, long: Double, address: String) {
        DispatchQueue.main.async {
            self.placeTF.text = address
        }
        
    }
    
}
