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
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    var postImage = ["AddImage_1","AddImage_2"]
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var selectedItems = [YPMediaItem]()
    var arrPostItems = [PostImagesVideo]()
    var images : [UIImage] = []
    var selectedIndex:IndexPath?
    
    var completion : (( _ post1:[YPMediaItem], _ posts2:[PostImagesVideo], _ images:[UIImage]) -> Void)? = nil
    var completion2 : (() -> Void)? = nil
   
    var comeFrom:String?
    var dateFormat = "MM/dd/yy"  //  dd/MM/yyyy
    var deviceTimeZone:String?
    var timeZoneAbbreviation:String?
    var errorTitle = "Create Post"
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var curruntLatitude :String?
    var curruntLongitude:String?
    var curruntAddress:String?
    var curruntCountry:String?
    
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
        textFiledDelegates()
        
        if self.comeFrom == "Edit"{
            ActivityIndicator.shared.showActivityIndicator()
            self.selectedIndex = IndexPath(row: 0, section: 0)
            enableTextFileds()
            
            if self.arrPostItems.count > 1{
                self.btnNext.isHidden = false
            }else{
                self.btnNext.isHidden = true
            }
            
//            getAddressFromLatLong(latitude: Double(arrPostItems[0].lat) ?? 0.0, longitude: Double(arrPostItems[0].long) ?? 0.0, completion: { address in
//                if address ?? "" == "North Atlantic Ocean"{
//                    self.placeTF.text = ""
//                }else{
//                    self.placeTF.text = address
//                }
               
       //     })
        
            self.dateTF.text = self.arrPostItems[0].date
            self.placeTF.text = self.arrPostItems[0].place
            self.timeTF.text = self.arrPostItems[0].time
            ActivityIndicator.shared.hideActivityIndicator()
            
        }
        
         deviceTimeZone = "\(TimeZone.current)"
         let deviceTZone = TimeZone.current
         timeZoneAbbreviation = "\(deviceTZone.abbreviation() ?? "Unknown")"
         timeZoneAbbreviation = timeZoneAbbreviation?.replacingOccurrences(of: "(", with: "")
         timeZoneAbbreviation = timeZoneAbbreviation?.replacingOccurrences(of: ")", with: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
    }
    
    func textFiledDelegates(){
        
        dateTF.delegate = self
        timeTF.delegate = self
        
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
       // dateTF.inputView = datePicker
        dateTF.addInputViewDatePicker(target: self, selector:  #selector(doneButtonPressed))

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
       // timeTF.inputView = timePicker
        timeTF.addInputViewTimePicker(target: self, selector:  #selector(doneButtonPressedTime))
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat //  dd/MM/yyyy
        dateTF.text = dateFormatter.string(from: sender.date)
    }
    @objc func doneButtonPressed() {
        if let  datePicker = self.dateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = dateFormat
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            self.dateTF.text = dateFormatter.string(from: datePicker.date)
            print(dateTF.text!)
        }
        self.dateTF.resignFirstResponder()
    }
    
    
    @IBAction func acionNext(_ sender: UIButton) {
        
        if selectedIndex?.row == (arrPostItems.count - 2){
            
            if self.placeTF.text != ""{
                
                let collectionBounds = self.addPhotoVideoCollectionView.bounds
                let contentOffset = CGFloat(floor(self.addPhotoVideoCollectionView.contentOffset.x + collectionBounds.size.width/3))
                self.moveCollectionToFrame(contentOffset: contentOffset)
                addPhotoVideoCollectionView.reloadData()
                
            self.selectedIndex = IndexPath(item: (self.selectedIndex?.row ?? 0) + 1, section: 0)
            ActivityIndicator.shared.showActivityIndicator()
                
                self.dateTF.text = self.arrPostItems[self.selectedIndex?.row ?? 0].date
                self.placeTF.text = self.arrPostItems[self.selectedIndex?.row ?? 0].place
                self.timeTF.text = "\(self.arrPostItems[self.selectedIndex?.row ?? 0].time)"
                
                //self.showMetaDataInTextFileds(index: indexPath.row)
                ActivityIndicator.shared.hideActivityIndicator()
                
                
            self.addPhotoVideoCollectionView.reloadData()
            self.btnNext.isHidden = true
            }else{
                
                Singleton.shared.showAlert(message: "Please select address to move next.", controller: self, Title: self.errorTitle)
            }
            
        }else{
            if self.placeTF.text != ""{
                
                let collectionBounds = self.addPhotoVideoCollectionView.bounds
                let contentOffset = CGFloat(floor(self.addPhotoVideoCollectionView.contentOffset.x + collectionBounds.size.width/3))
                self.moveCollectionToFrame(contentOffset: contentOffset)
                addPhotoVideoCollectionView.reloadData()
                
                self.selectedIndex = IndexPath(item: (self.selectedIndex?.row ?? 0) + 1, section: 0)
                ActivityIndicator.shared.showActivityIndicator()
                
                self.dateTF.text = self.arrPostItems[self.selectedIndex?.row ?? 0].date
                self.placeTF.text = self.arrPostItems[self.selectedIndex?.row ?? 0].place
                self.timeTF.text = "\(self.arrPostItems[self.selectedIndex?.row ?? 0].time)"
                
                //self.showMetaDataInTextFileds(index: indexPath.row)
                ActivityIndicator.shared.hideActivityIndicator()
                
                
                self.addPhotoVideoCollectionView.reloadData()
                self.btnNext.isHidden = false
            }else{
                Singleton.shared.showAlert(message: "Please select address to move next.", controller: self, Title: self.errorTitle)
            }
        }
        
    }
    
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
            
            let frame: CGRect = CGRect(x : contentOffset ,y : self.addPhotoVideoCollectionView.contentOffset.y ,width : self.addPhotoVideoCollectionView.frame.width,height : self.addPhotoVideoCollectionView.frame.height)
            self.addPhotoVideoCollectionView.scrollRectToVisible(frame, animated: true)
        }
    
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeTF.text = "\(timeFormatter.string(from: sender.date)) \(self.timeZoneAbbreviation ?? "")"
    }
    
    @objc func doneButtonPressedTime() {
        if let  datePicker = self.timeTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "h:mm a"
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
           // self.timeTF.text = dateFormatter.string(from: datePicker.date)
            self.timeTF.text = "\(dateFormatter.string(from: datePicker.date)) \(self.timeZoneAbbreviation ?? "")"
            print(timeTF.text!)
        }
        self.timeTF.resignFirstResponder()
    }
    
    
    func disableTextFileds(){
     //   btnAddAddress.isEnabled = false
        btnTime.isUserInteractionEnabled = true
        btnDate.isUserInteractionEnabled = true
        timeTF.isUserInteractionEnabled = false
        placeTF.isUserInteractionEnabled = false
        dateTF.isUserInteractionEnabled = false
        
    }
    
    func enableTextFileds(){
     //   btnAddAddress.isEnabled = true
        btnTime.isUserInteractionEnabled = false
        btnDate.isUserInteractionEnabled = false
        timeTF.isUserInteractionEnabled = true
        placeTF.isUserInteractionEnabled = true
        dateTF.isUserInteractionEnabled = true
    }
    
    func checkEnterdData() -> Bool{
        
        for (index, post) in arrPostItems.enumerated() {
            
            if post.lat == "0.0" && post.long == "0.0"{
                  //  self.showMessage(message: "Please select address for each post item", isError: .error)
                Singleton.shared.showAlert(message: "Please select address for each post item", controller: self, Title: errorTitle)
                    return false
                }
            }
        return true
    }
    
    func checkAddressForAll() -> Bool{
        
        for (index, post) in arrPostItems.enumerated() {
            
            if post.lat != "0.0" && post.long != "0.0"{
                    return true
                }
            }
       // self.showMessage(message: "Please select address for each post item", isError: .error)
        return false
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        if self.comeFrom != "Edit" {
            popVC()
        }else{
            
        if let completion2 = completion2{
            popVC()
            completion2()
        }
        
    }
    }
    
    @IBAction func actionDate(_ sender: UIButton) {
       // Singleton.shared.showMessage(message: "Please select at least one image or video first", isError: .error)
        Singleton.shared.showAlert(message: "Please select at least one image or video first", controller: self, Title: errorTitle)
    }
    
    @IBAction func actionTime(_ sender: UIButton) {
       // Singleton.shared.showMessage(message: "Please select at least one image or video first", isError: .error)
        Singleton.shared.showAlert(message: "Please select at least one image or video first", controller: self, Title: errorTitle)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        debugPrint("selected items is --- ",self.selectedItems)
        
        let addressForAll = checkAddressForAll()
        // With validation
        
        if self.comeFrom != "Edit" {
            
            if images.count != 0{
                
                if addressForAll{
                    let postStatus = checkEnterdData()
                    if postStatus{
                        if let completion = self.completion{
                            popVC()
                            
                            if self.comeFrom == "Edit"{
                                Singleton.shared.showMessage(message: "Post item details updated successfully.", isError: .success)
                            }else{
                                Singleton.shared.showMessage(message: "Post added successfully, Now please add other details for the post.", isError: .success)
                            }
                            completion(selectedItems,arrPostItems,images)
                        }
                    }else{
                        print("Please add all text filed data")
                    }
                    
                }else{
                   // self.showMessage(message: "Please select address for each post item", isError: .error)
                    
                    Singleton.shared.showAlert(message: "Please select address for each post item", controller: self, Title: errorTitle)
                    
                    //    self.showAlert(message: "Please select address for each post item", title: "Address") {
                    
                    //   }
                }
                
            }else{
                //Singleton.shared.showMessage(message: "Please select at least one image or video first", isError: .error)
                Singleton.shared.showAlert(message: "Please select at least one image or video first", controller: self, Title: errorTitle)
            }
            
        }else{
            
            if arrPostItems.count != 0{
                
                if addressForAll{
                    let postStatus = checkEnterdData()
                    if postStatus{
                        if let completion = self.completion{
                            popVC()
                            
                            if self.comeFrom == "Edit"{
                                Singleton.shared.showMessage(message: "Post item details updated successfully.", isError: .success)
                            }else{
                                Singleton.shared.showMessage(message: "Post added successfully, Now please add other details for the post.", isError: .success)
                            }
                            completion(selectedItems,arrPostItems,images)
                        }
                    }else{
                        print("Please add all text filed data")
                    }
                    
                }else{
                    //self.showMessage(message: "Please select address for each post item", isError: .error)
                    Singleton.shared.showAlert(message: "Please select address for each post item", controller: self, Title: errorTitle)

                    //    self.showAlert(message: "Please select address for each post item", title: "Address") {
                    
                    //   }
                }
                
            }else{
              //  Singleton.shared.showMessage(message: "Please select at least one image or video first", isError: .error)
                Singleton.shared.showAlert(message: "Please select at least one image or video first", controller: self, Title: errorTitle)

            }
            
            
        }
        
        // Without validation
        
//        if let completion = self.completion{
//            popVC()
//            Singleton.shared.showMessage(message: "Post images and videos added sucsessfully, Now please enter remaning information and post ", isError: .success)
//            completion(selectedItems)
//        }

    }
    
    @IBAction func addAddress(_ sender: UIButton) {
        
        if placeTF.isUserInteractionEnabled{
            let vc = AddLocationVC()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
            //self.showMessage(message: "Please select at least one image or video", isError: .error)
            Singleton.shared.showAlert(message: "Please select at least one image or video first", controller: self, Title: errorTitle)
            
        }
        
    }
    
    func setTableviewDelegates(){
        self.addPhotoVideoCollectionView.delegate = self
        self.addPhotoVideoCollectionView.dataSource = self
        self.addPhotoVideoCollectionView.register(UINib(nibName: "AddPhotoVideoCVCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotoVideoCVCell")
    }
    
}
extension AddPhotoVideoVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.comeFrom == "Edit"{
            return self.arrPostItems.count
        }else{
            
            let count = self.arrPostItems.count
            if count > 0 {
                
                return count > 9 ? count : count + 1
                
            } else {
                return 1
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoVideoCVCell", for: indexPath) as! AddPhotoVideoCVCell
        if self.comeFrom == "Edit"{
            
            cell.btnCross.isHidden = true
            if self.arrPostItems[indexPath.row].type == "0"{
                cell.postImage.setImage(image: self.arrPostItems[indexPath.row].image)
            }else{
                cell.postImage.setImage(image: self.arrPostItems[indexPath.row].thumbNailImage)
            }
            
            if selectedIndex == indexPath{
                cell.postImage.borderWidth = 2
                cell.postImage.borderColor = UIColor(named: "OrengeAppColour")
              //  ActivityIndicator.shared.showActivityIndicator()
              //  self.showMetaDataInTextFileds(index: indexPath.row)
                
            }else{
                cell.postImage.borderWidth = 0
            }
            
            
        }else{
        
        if arrPostItems.count > 0{
            
            self.enableTextFileds()
            
            if indexPath.row == arrPostItems.count{
                print("in add photo")
                cell.btnCross.isHidden = true
                cell.postImage.image = UIImage(named: "AddImage_2")
                cell.postImage.borderWidth = 0
            }else{
               
                cell.btnCross.isHidden = false
                let post = arrPostItems[indexPath.row]
                switch post.type{
                case "0":
                    cell.postImage.image = images[indexPath.row]
                    print("Lat -- ",post.lat)
                    print("Long -- ",post.long)
                    print("Date Time -- ",post.date)
                case "1":
                    cell.postImage.image = images[indexPath.row]
                    print("Lat -- ",post.lat)
                    print("Long -- ",post.long)
                    print("Date Time -- ",post.date)
                default:
                    break
                }
                
                cell.btnCross.tag = indexPath.row
                cell.btnCross.addTarget(target: self, action: #selector(actionCross))
                
                if selectedIndex == indexPath{
                    cell.postImage.borderWidth = 2
                    cell.postImage.borderColor = UIColor(named: "OrengeAppColour")
                
                    ActivityIndicator.shared.showActivityIndicator()
                    
                    self.dateTF.text = self.arrPostItems[indexPath.row].date
                    self.placeTF.text = self.arrPostItems[indexPath.row].place
                    self.timeTF.text = "\(self.arrPostItems[indexPath.row].time)"
                    
                    if self.placeTF.text == "" && self.arrPostItems[indexPath.row].lat != ""{
                        self.showMetaDataInTextFileds(index: indexPath.row)
                    }
                   
                    ActivityIndicator.shared.hideActivityIndicator()
                    
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
    }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.comeFrom == "Edit"{
            
            if indexPath.row == (arrPostItems.count - 1){
                self.btnNext.isHidden = true
            }else{
                self.btnNext.isHidden = false
            }
            
            self.selectedIndex = indexPath
            ActivityIndicator.shared.showActivityIndicator()
            
            
            self.dateTF.text = self.arrPostItems[indexPath.row].date
            self.placeTF.text = self.arrPostItems[indexPath.row].place
            self.timeTF.text = "\(self.arrPostItems[indexPath.row].time)"
            
           
            ActivityIndicator.shared.hideActivityIndicator()
            
            self.addPhotoVideoCollectionView.reloadData()
            
        }else{
            
            if indexPath.row == arrPostItems.count{
                print("Add post")
             //   arrPostItems = []
                showPicker()
            }else{
                
                if indexPath.row == (arrPostItems.count - 1){
                    self.btnNext.isHidden = true
                }else{
                    self.btnNext.isHidden = false
                }
                
                self.selectedIndex = indexPath
                ActivityIndicator.shared.showActivityIndicator()
                
                self.dateTF.text = self.arrPostItems[indexPath.row].date
                self.placeTF.text = self.arrPostItems[indexPath.row].place
                self.timeTF.text = "\(self.arrPostItems[indexPath.row].time)"
                
                if self.placeTF.text == "" && self.arrPostItems[indexPath.row].lat != ""{
                    self.showMetaDataInTextFileds(index: indexPath.row)
                }
                
                ActivityIndicator.shared.hideActivityIndicator()
                
                self.addPhotoVideoCollectionView.reloadData()
                
            }
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
      //  self.selectedItems.remove(at: sender.tag)
        self.arrPostItems.remove(at: sender.tag)
        self.images.remove(at: sender.tag)
        // is last element
        
    
        
        if (arrPostItems.count) == sender.tag{
           
            //text filed data start
            
            self.selectedIndex = IndexPath(row: sender.tag - 1, section: 0)
            
            if arrPostItems.count != 0{
                self.showMetaDataInTextFileds(index: sender.tag - 1)
            }else{
                self.disableTextFileds()
                
            }
           
            //text filed data end
            
            self.addPhotoVideoCollectionView.reloadData()
            scrollToLastItem()
        }else{
            self.selectedIndex = IndexPath(row: arrPostItems.count - 1, section: 0)
            
            //text filed data start
            
            self.showMetaDataInTextFileds(index: arrPostItems.count - 1)

            //text filed data end
            
            self.addPhotoVideoCollectionView.reloadData()
            print("Not last Index-- Index is ",sender.tag)
        }
        
        
        if selectedItems.count == 0{
            
            placeTF.text = ""
            dateTF.text = ""
            timeTF.text = ""
            
        }
        if images.count == 0{
            
            placeTF.text = ""
            dateTF.text = ""
            timeTF.text = ""
            self.disableTextFileds()
            
        }
        
        if arrPostItems.count == 1 || arrPostItems.count == 0{
            btnNext.isHidden = true
            
        }else{
            btnNext.isHidden = false
        }
        
        if selectedIndex?.row == arrPostItems.count - 1{
            btnNext.isHidden = true
        }else{
            btnNext.isHidden = false
        }
        
    }
    
}

extension AddPhotoVideoVC{
    
    func showPicker() {
        btnBack.isHidden = true
      //  self.selectedItems = []
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10 - self.arrPostItems.count
        config.library.mediaType = .photoAndVideo
        config.shouldSaveNewPicturesToAlbum = true
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
     //   config.library.defaultMultipleSelection = true
     //   config.library.preselectedItems = selectedItems
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [weak picker] items, cancelled in
            self.btnBack.isHidden = false
            ActivityIndicator.shared.showActivityIndicator()
            if cancelled {
                print("Picker was canceled")
                ActivityIndicator.shared.hideActivityIndicator()
                picker?.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            
            self.fetchData(posts: self.selectedItems)
            
          //  self.addPhotoVideoCollectionView.reloadData()
            
            print(self.arrPostItems.count, "Posts count")
            
            if self.arrPostItems.count > 1{
                self.btnNext.isHidden = false
            }else{
                self.btnNext.isHidden = true
            }
            
            let post = self.selectedItems.first
               switch post{
               case .photo(p: let photo):
                   self.selectedIndex = IndexPath(row: 0, section: 0)
                   self.getAddressFromLatLong(latitude: photo.asset?.location?.coordinate.latitude ?? 0.0, longitude: photo.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
                       
                       if address ?? "" == "North Atlantic Ocean"{
                           
                           if self.arrPostItems.count == 0{
                               
                               self.placeTF.text = self.curruntAddress ?? ""
                               self.arrPostItems[0].country = self.curruntCountry ?? ""
                               self.arrPostItems[0].place = self.curruntAddress ?? ""
                               self.arrPostItems[0].lat = self.curruntLatitude ?? ""
                               self.arrPostItems[0].long = self.curruntLongitude ?? ""
                               
                               
                               
                           }else{
                               self.placeTF.text = self.curruntAddress ?? ""
                               self.arrPostItems[0].country = self.curruntCountry ?? ""
                               self.arrPostItems[0].place = self.curruntAddress ?? ""
                               self.arrPostItems[0].lat = self.curruntLatitude ?? ""
                               self.arrPostItems[0].long = self.curruntLongitude ?? ""
                               
                               
                              // self.placeTF.text = self.arrPostItems[0].place
                           }
                           
                       }else{
                           
                           if self.arrPostItems.count == 0{
                               self.placeTF.text = address
                           }else{
                               self.placeTF.text = self.arrPostItems[0].place
                           }
                           
                           
                       }
                       print("Got address from picker -----",address ?? "")
                         
                   })
                   print("capture pic date time",photo.asset?.creationDate as Any)
                   
                   if photo.asset?.creationDate?.dateToString(format: self.dateFormat) == nil{
                       
                       let currentDate = Date()
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = self.dateFormat
                       let formattedDate = dateFormatter.string(from: currentDate)
                       
                       if self.arrPostItems.count == 0{
                       
                       self.dateTF.text = formattedDate
                       //self.timeTF.text = "\(photo.asset?.creationDate?.dateToString(format: "h:mm a") ?? "") \(self.timeZoneAbbreviation ?? "")"
                       self.timeTF.text = "\(currentDate.dateToString(format: "h:mm a") ) \(self.timeZoneAbbreviation ?? "")"
                   }else{
                       self.dateTF.text = self.arrPostItems[0].date
                       self.timeTF.text = self.arrPostItems[0].time
                   }
                       
                   }else{
                       
                       if self.arrPostItems.count == 0{
                           
                           self.dateTF.text = photo.asset?.creationDate?.dateToString(format: self.dateFormat)
                           self.timeTF.text = "\(photo.asset?.creationDate?.dateToString(format: "h:mm a") ?? "") \(self.timeZoneAbbreviation ?? "")"
                      
                       }else{
                           
                           self.dateTF.text = self.arrPostItems[0].date
                           self.timeTF.text = self.arrPostItems[0].time
                           
                           
                       }
                   }
                   
                   ActivityIndicator.shared.hideActivityIndicator()
                  
               case .video(v: let video):
                   self.selectedIndex = IndexPath(row: 0, section: 0)
                   self.getAddressFromLatLong(latitude: video.asset?.location?.coordinate.latitude ?? 0.0, longitude: video.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
                       if address ?? "" == "North Atlantic Ocean"{
                           
                           if self.arrPostItems.count == 0{
                             //  self.placeTF.text = ""
                               self.placeTF.text = self.curruntAddress ?? ""
                               self.arrPostItems[0].country = self.curruntCountry ?? ""
                               self.arrPostItems[0].place = self.curruntAddress ?? ""
                               self.arrPostItems[0].lat = self.curruntLatitude ?? ""
                               self.arrPostItems[0].long = self.curruntLongitude ?? ""
                           }else{
                              // self.placeTF.text = self.arrPostItems[0].place
                               self.placeTF.text = self.curruntAddress ?? ""
                               self.arrPostItems[0].country = self.curruntCountry ?? ""
                               self.arrPostItems[0].place = self.curruntAddress ?? ""
                               self.arrPostItems[0].lat = self.curruntLatitude ?? ""
                               self.arrPostItems[0].long = self.curruntLongitude ?? ""
                           }
                           
                       }else{
                           
                           if self.arrPostItems.count == 0{
                               self.placeTF.text = address
                           }else{
                               self.placeTF.text = self.arrPostItems[0].place
                           }
                           
                           
                       }
                       print("Got address from picker -----",address ?? "")
                       print("capture pic date time",video.asset?.creationDate as Any)
                       
                       
                       if video.asset?.creationDate?.dateToString(format: self.dateFormat) == nil{
                           
                           let currentDate = Date()
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = self.dateFormat
                           let formattedDate = dateFormatter.string(from: currentDate)
                           
                           if self.arrPostItems.count == 0{
                               self.dateTF.text = formattedDate
                               //self.timeTF.text = "\(photo.asset?.creationDate?.dateToString(format: "h:mm a") ?? "") \(self.timeZoneAbbreviation ?? "")"
                               self.timeTF.text = "\(currentDate.dateToString(format: "h:mm a") ) \(self.timeZoneAbbreviation ?? "")"
                           }else{
                               self.dateTF.text = self.arrPostItems[0].date
                               self.timeTF.text = self.arrPostItems[0].time
                           }
                           
                       }else{
                           
                           if self.arrPostItems.count == 0{
                               
                               self.dateTF.text = video.asset?.creationDate?.dateToString(format: self.dateFormat)
                               self.timeTF.text = "\(video.asset?.creationDate?.dateToString(format: "h:mm a") ?? "") \(self.timeZoneAbbreviation ?? "")"
                          
                           }else{
                               
                               self.dateTF.text = self.arrPostItems[0].date
                               self.timeTF.text = self.arrPostItems[0].time
                               
                               
                           }
                           
                           
                       }
                     
                       
                       
                       ActivityIndicator.shared.hideActivityIndicator()
                   })
                   
               case .none:
                   print("No Photo Selected")
               }
            picker?.dismiss(animated: true)
            self.addPhotoVideoCollectionView.reloadData()
          //  self.scrollToLastItem()
            
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
        
//        picker.dismiss(animated: true) {
//            ActivityIndicator.shared.hideActivityIndicator()
//        }
        
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
                   // addressComponents.append(name)
                    print("name---", name)
                }

                if let thoroughfare = placemark.thoroughfare {
                   // addressComponents.append(thoroughfare)
                    print("thoroughfare---", thoroughfare)
                }

                if let subThoroughfare = placemark.subThoroughfare {
                   // addressComponents.append(subThoroughfare)
                    print("subThoroughfare---", subThoroughfare)
                }

                if let locality = placemark.locality {
                    addressComponents.append(locality)
                    print("locality---", locality)
                }

                if let administrativeArea = placemark.administrativeArea {
                    //addressComponents.append(administrativeArea)
                    print("administrativeArea---", administrativeArea)
                }

                if let postalCode = placemark.postalCode {
                   // addressComponents.append(postalCode)
                    print("postalCode---", postalCode)
                }

                if let country = placemark.country {
                    addressComponents.append(country)
                    print("country---", country)
                }

                // Join all the address components to get the complete address
                let address = addressComponents.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func showMetaDataInTextFileds(index:Int){
        
        if self.comeFrom == "Edit"{
            
            getAddressFromLatLong(latitude: Double(arrPostItems[index].lat) ?? 0.0, longitude: Double(arrPostItems[index].long) ?? 0.0, completion: { address in
                if address ?? "" == "North Atlantic Ocean"{
                    self.placeTF.text = ""
                }else{
                    self.placeTF.text = address
                }
                print("Got address from picker -----",address ?? "")
                self.dateTF.text = self.arrPostItems[index].date
                self.timeTF.text = "\(self.arrPostItems[index].time)"
                ActivityIndicator.shared.hideActivityIndicator()
            })
            
        }else{
            let post = arrPostItems[index]
            switch post.type{
            case "0":
                getAddressFromLatLong(latitude: Double(arrPostItems[index].lat) ?? 0.0, longitude: Double(arrPostItems[index].long) ?? 0.0, completion: { address in
                    if address ?? "" == "North Atlantic Ocean"{
                       // self.placeTF.text = ""
                        self.placeTF.text = self.curruntAddress ?? ""
                        
                    }else{
                        let addressFromLatLong = address?.components(separatedBy: ",")
                        let place = addressFromLatLong?.first
                        let country = addressFromLatLong?.last?.trim
                        self.placeTF.text = place
                        self.arrPostItems[self.selectedIndex?.row ?? 0].country = country ?? ""
                        self.arrPostItems[self.selectedIndex?.row ?? 0].place = place ?? ""
                        
                    }
                    print("Got address from picker -----",address ?? "")
                    self.dateTF.text = self.arrPostItems[index].date
                    self.timeTF.text = "\(self.arrPostItems[index].time)"
                    ActivityIndicator.shared.hideActivityIndicator()
                })
                
            case "1":
                getAddressFromLatLong(latitude: Double(arrPostItems[index].lat) ?? 0.0, longitude: Double(arrPostItems[index].long) ?? 0.0, completion: { address in
                    if address ?? "" == "North Atlantic Ocean"{
                       // self.placeTF.text = ""
                        self.placeTF.text = self.curruntAddress ?? ""
                    }else{
                        let addressFromLatLong = address?.components(separatedBy: ",")
                        let place = addressFromLatLong?.first
                        let country = addressFromLatLong?.last?.trim
                        self.placeTF.text = place
                        self.arrPostItems[self.selectedIndex?.row ?? 0].country = country ?? ""
                        self.arrPostItems[self.selectedIndex?.row ?? 0].place = place ?? ""
                    }
                    print("Got address from picker -----",address ?? "")
                    self.dateTF.text = self.arrPostItems[index].date
                    self.timeTF.text = "\(self.arrPostItems[index].time)"
                    ActivityIndicator.shared.hideActivityIndicator()
                })
            default:
                break
            }
        
    }
    }
    
    func fetchData(posts:[YPMediaItem]){
        
        for (index, post) in selectedItems.enumerated() {
            
            print("index---",index)
            
            switch post{
            case .photo(p: let photo):
                // get place
                var place = ""
                getAddressFromLatLong(latitude: photo.asset?.location?.coordinate.latitude ?? 0.0, longitude: photo.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
                    place = address ?? ""
                })
                
                if photo.asset?.creationDate?.dateToString(format: self.dateFormat) == nil || place == "North Atlantic Ocean"{
                    
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = self.dateFormat
                    let formattedDate = dateFormatter.string(from: currentDate)
                    let time = "\(currentDate.dateToString(format: "h:mm a") ) \(self.timeZoneAbbreviation ?? "")"
                    
                    let post = PostImagesVideo(id: "", postID: "", place: curruntAddress ?? "", date: formattedDate, time: time, lat: curruntLatitude ?? "", long: curruntLongitude ?? "", image: "", country: curruntCountry, videoTitle: "", videoURL: "", height: "", width: "", thumbNailImage: "", type: "0", deviceType: "", songFrom: "", songTitle: "", fullMusicURL: "", artistID: "", artistName: "", trackID: "", trackType: "", trackPicture: "", playbackSeconds: "", albumName: "", albumID: "", trackName: "", videoStartTime: "", videoEndTime: "", status: "", createdAt: "")
                    self.images.append(photo.image)
                    arrPostItems.append(post)
                    
                }else{
                    let post = PostImagesVideo(id: "", postID: "", place: place, date: photo.asset?.creationDate?.dateToString(format: dateFormat) ?? "", time: "\(photo.asset?.creationDate?.dateToString(format: "h:mm a") ?? "") \(self.timeZoneAbbreviation ?? "")", lat: "\(photo.asset?.location?.coordinate.latitude ?? 0.0)", long: "\(photo.asset?.location?.coordinate.longitude ?? 0.0)", image: "", country: "", videoTitle: "", videoURL: "", height: "", width: "", thumbNailImage: "", type: "0", deviceType: "", songFrom: "", songTitle: "", fullMusicURL: "", artistID: "", artistName: "", trackID: "", trackType: "", trackPicture: "", playbackSeconds: "", albumName: "", albumID: "", trackName: "", videoStartTime: "", videoEndTime: "", status: "", createdAt: "")
                    self.images.append(photo.image)
                    arrPostItems.append(post)
                }
                
                
            case .video(v: let video):
                var place = ""
                getAddressFromLatLong(latitude: video.asset?.location?.coordinate.latitude ?? 0.0, longitude: video.asset?.location?.coordinate.longitude ?? 0.0, completion: { address in
                    place = address ?? ""
                })
                
                if video.asset?.creationDate?.dateToString(format: self.dateFormat) == nil || place == "North Atlantic Ocean"{
                    
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = self.dateFormat
                    let formattedDate = dateFormatter.string(from: currentDate)
                    let time = "\(currentDate.dateToString(format: "h:mm a") ) \(self.timeZoneAbbreviation ?? "")"
                    
                    let post = PostImagesVideo(id: "", postID: "", place: curruntAddress ?? "", date: formattedDate, time:time, lat: curruntLatitude ?? "" , long: curruntLongitude ?? "", image: "", country: curruntCountry, videoTitle: "", videoURL: video.url.path, height: "", width: "", thumbNailImage: "", type: "1", deviceType: "", songFrom: "", songTitle: "", fullMusicURL: "", artistID: "", artistName: "", trackID: "", trackType: "", trackPicture: "", playbackSeconds: "", albumName: "", albumID: "", trackName: "", videoStartTime: "", videoEndTime: "", status: "", createdAt: "")
                    self.images.append(video.thumbnail)
                    arrPostItems.append(post)
                    
                }else{
                    
                    let post = PostImagesVideo(id: "", postID: "", place: place, date: video.asset?.creationDate?.dateToString(format: dateFormat) ?? "", time: "\(video.asset?.creationDate?.dateToString(format: "h:mm a") ?? "") \(self.timeZoneAbbreviation ?? "")", lat: "\(video.asset?.location?.coordinate.latitude ?? 0.0)", long: "\(video.asset?.location?.coordinate.longitude ?? 0.0)", image: "", country: "", videoTitle: "", videoURL: video.url.path, height: "", width: "", thumbNailImage: "", type: "1", deviceType: "", songFrom: "", songTitle: "", fullMusicURL: "", artistID: "", artistName: "", trackID: "", trackType: "", trackPicture: "", playbackSeconds: "", albumName: "", albumID: "", trackName: "", videoStartTime: "", videoEndTime: "", status: "", createdAt: "")
                    self.images.append(video.thumbnail)
                    arrPostItems.append(post)
                }
                
            }
            
        }
    }
    
}

extension AddPhotoVideoVC:AddLocationVCDelegate{
   
    func setLocation(text: String, lat: Double, long: Double, address: String,country: String) {
        DispatchQueue.main.async {
            
            self.arrPostItems[self.selectedIndex?.row ?? 0].lat = "\(lat)"
            self.arrPostItems[self.selectedIndex?.row ?? 0].long = "\(long)"
            self.placeTF.text = address
            self.arrPostItems[self.selectedIndex?.row ?? 0].place = address
            self.arrPostItems[self.selectedIndex?.row ?? 0].country = country
            
//            self.getAddressFromLatLong(latitude: lat, longitude:
//                                        long, completion: { address in
//                self.placeTF.text = address
//            })
            
        }
        
    }
    
    
    func setAddressOnSelectedItem(index:Int,lat: Double, long: Double){
        
        let post = selectedItems[index]
//       switch post{
//       case .photo(p: let photo):
//
//           photo.asset?.location?.coordinate.latitude = lat
//           photo.asset?.location?.coordinate.longitude = long
//
//       case .video(v: let video):
//
//       }
        
    }
    
}

//MARK: - text filed delegate methods -

extension AddPhotoVideoVC:UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == dateTF {
            arrPostItems[selectedIndex?.row ?? 0].date = dateTF.text ?? ""
        }else if textField == timeTF {
            arrPostItems[selectedIndex?.row ?? 0].time = timeTF.text ?? ""
        }else if textField == placeTF{
            arrPostItems[selectedIndex?.row ?? 0].place = placeTF.text ?? ""
        }
        
        return true
    }
    
}

extension AddPhotoVideoVC:CLLocationManagerDelegate{
    func getCurrentLocation(){
        if #available(iOS 14.0, *) {
            
            if locationManager.authorizationStatus == (CLAuthorizationStatus.authorizedWhenInUse) ||
                locationManager.authorizationStatus ==  (CLAuthorizationStatus.authorizedAlways)  {
                currentLocation = locationManager.location
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == (CLAuthorizationStatus.authorizedWhenInUse) ||
                locationManager.authorizationStatus ==  (CLAuthorizationStatus.authorizedAlways)  {
                currentLocation = locationManager.location
            }
        } else {
            // Fallback on earlier versions
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("**********************")
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.curruntLatitude = "\(userLocation.coordinate.latitude)"
        self.curruntLongitude = "\(userLocation.coordinate.longitude)"
        //        AppDefaults.latitude = self.latitude
        //        AppDefaults.longitude = self.longitude
        //        print(AppDefaults.latitude!)
        //        print(AppDefaults.longitude!)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
             
                self.curruntAddress = placemark.locality
                self.curruntCountry = placemark.country
                
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                //                let data = "\(placemark.timeZone!), \(placemark.administrativeArea!), \(placemark.country!), \(placemark.timeZone!)"
                let data = placemark.timeZone?.identifier ?? ""
                
                //                self.cuntry = data
                print("data :-  ****** \(data) *****   self.cuntry:-  \(TimeZone.current.identifier)")
                self.locationManager.stopUpdatingLocation()
                
            }
        }
        
    }
    
}
