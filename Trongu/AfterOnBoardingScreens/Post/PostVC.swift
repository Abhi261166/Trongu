//
//  PostVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import YPImagePicker
import CoreLocation

class PostVC: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var lblNoOfDays: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblTagPeople: UILabel!
    @IBOutlet weak var lblTripComp: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTripCat: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    
    @IBOutlet weak var vWDiscription: UIView!
    @IBOutlet weak var vWTagPeople: UIView!
    
    
    
    var arrPostYP = [YPMediaItem]()
    var finalPost:Post?
    var tagIds = ""
    var tagPeople = ""
    var tagPeopleName = ""
    var viewModel:PostVM?
    var images:[UIImage] = []
    var comeForm:String?
    var places:[String] = []
    var tripCat = 1
    var completion : (() -> Void)? = nil
    
    // cat ids
    var selectedDaysId = ""
    var selectedTripCatId = ""
    var selectedTripComplexityId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.postCollectionView.delegate = self
        self.postCollectionView.dataSource = self
        self.postCollectionView.register(UINib(nibName: "PostCVCell", bundle: nil), forCellWithReuseIdentifier: "PostCVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        
        if self.comeForm == "Edit"{
            btnPost.setTitle("Update Post", for: .normal)
        }else{
            btnPost.setTitle("Post", for: .normal)
        }
        places = []
        getPlaces()
        
        print("Places --- ",places)
        
    }
    
    func getPlaces(){
        
        for index in 0...((finalPost?.postImagesVideo.count ?? 0) - 1 ){
            getAddressFromLatLong(latitude: Double(finalPost?.postImagesVideo[index].lat ?? "") ?? 0.0, longitude: Double(finalPost?.postImagesVideo[index].long ?? "") ?? 0.0) { address in
                self.places.append(address ?? "")
            }
        }
    }
    
    func setData(){
        
        lblBudget.text = "$\(finalPost?.budget ?? "")"
        lblTagPeople.text = tagPeople
        
        if finalPost?.description == "" || finalPost?.description == nil {
            vWDiscription.isHidden = true
        }else{
            vWDiscription.isHidden = false
            lblDesc.text = finalPost?.description
        }
        
        if self.tagPeopleName == ""{
            vWTagPeople.isHidden = true
        }else{
            vWTagPeople.isHidden = false
            lblTagPeople.numberOfLines = 0
            lblTagPeople.text = tagPeopleName
        }
        
        
        lblTripCat.text = finalPost?.tripCategoryName
        lblTripComp.text = finalPost?.trip_complexity_name
        lblNoOfDays.text = finalPost?.no_of_days_name
        
    }
    
    func setViewModel(){
        self.viewModel = PostVM(observer: self)
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        
        if let completion = completion{
            self.navigationController?.popViewController(animated: true)
            completion()
        }
        
    }
    
    @IBAction func postAction(_ sender: UIButton) {
       
        if self.comeForm == "Edit"{
            
            self.viewModel?.apiUpdatePost(postId: finalPost?.id ?? "", tags: self.tagIds, budget: finalPost?.budget ?? "", noOffDays: self.selectedDaysId, tripCat: self.selectedTripCatId, disc: finalPost?.description ?? "", tripComp: self.selectedTripComplexityId, arrPosts: arrPostYP, arrPosts2: finalPost?.postImagesVideo ?? [], address: places)
            
        }else{
            
            self.viewModel?.apiCreatePost(tags: self.tagIds, budget: finalPost?.budget ?? "", noOffDays: self.selectedDaysId, tripCat: self.selectedTripCatId, disc: finalPost?.description ?? "", tripComp: self.selectedTripComplexityId, arrPosts: arrPostYP, arrPosts2: finalPost?.postImagesVideo ?? [], images: images, address: places)
        }
        
    }
    
}
extension PostVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return finalPost?.postImagesVideo.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCVCell", for: indexPath) as! PostCVCell
        
        if self.comeForm == "Edit"{
            
            if finalPost?.postImagesVideo[indexPath.row].type == "0"{
                cell.imgPost.setImage(image: finalPost?.postImagesVideo[indexPath.row].image)
            }else{
                cell.imgPost.setImage(image: finalPost?.postImagesVideo[indexPath.row].thumbNailImage)
            }
            
            cell.lblPostItemAddressDateTime.text = "\(finalPost?.postImagesVideo[indexPath.row].place ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].date ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].time ?? "")"
            
//            getAddressFromLatLong(latitude: Double(finalPost?.postImagesVideo[indexPath.row].lat ?? "") ?? 0.0, longitude: Double(finalPost?.postImagesVideo[indexPath.row].long ?? "") ?? 0.0) { address in
//
//                cell.lblPostItemAddressDateTime.text = "\(address ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].date ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].time ?? "")"
//            }
            
        }else{
            
//            let post = arrPostYP[indexPath.row]
//            switch post{
//            case .photo(p: let photo):
//                cell.imgPost.image = photo.image
//
//            case .video(v: let video):
//                cell.imgPost.image = video.thumbnail
//
//            }
            
            cell.imgPost.image = images[indexPath.row]
            
            
            cell.lblPostItemAddressDateTime.text = "\(finalPost?.postImagesVideo[indexPath.row].place ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].date ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].time ?? "")"
            
//            getAddressFromLatLong(latitude: Double(finalPost?.postImagesVideo[indexPath.row].lat ?? "") ?? 0.0, longitude: Double(finalPost?.postImagesVideo[indexPath.row].long ?? "") ?? 0.0) { address in
//
//                cell.lblPostItemAddressDateTime.text = "\(address ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].date ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].time ?? "")"
//            }
            
        }
        
        cell.btnLeft.tag = indexPath.row
        cell.btnRight.tag = indexPath.row
        cell.btnLeft.addTarget(self, action: #selector(actionLeft), for: .touchUpInside)
        cell.btnRight.addTarget(self, action: #selector(actionRight), for: .touchUpInside)
        
        if indexPath.row == 0{
            cell.btnLeft.isHidden = true
        }else{
            cell.btnLeft.isHidden = false
        }
        
        if indexPath.row == (finalPost?.postImagesVideo.count ?? 0) - 1{
            cell.btnRight.isHidden = true
        }else{
            cell.btnRight.isHidden = false
        }
           
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 350)
    }
    
    @objc func actionLeft(sender:UIButton){
        
        let collectionBounds = self.postCollectionView.bounds
                        let contentOffset = CGFloat(floor(self.postCollectionView.contentOffset.x - collectionBounds.size.width))
                        self.moveCollectionToFrame(contentOffset: contentOffset)
                          postCollectionView.reloadData()
        
       // postCollectionView.scrollToItem(at: IndexPath(item: sender.tag - 1, section: 0), at: .right, animated: true)
        
    }
    
    @objc func actionRight(sender:UIButton){
        
        let collectionBounds = self.postCollectionView.bounds
                        let contentOffset = CGFloat(floor(self.postCollectionView.contentOffset.x + collectionBounds.size.width))
                        self.moveCollectionToFrame(contentOffset: contentOffset)
                          postCollectionView.reloadData()
                        
        
       // postCollectionView.scrollToItem(at: IndexPath(item: sender.tag + 1, section: 0), at: .right, animated: true)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
            
            let frame: CGRect = CGRect(x : contentOffset ,y : self.postCollectionView.contentOffset.y ,width : self.postCollectionView.frame.width,height : self.postCollectionView.frame.height)
            self.postCollectionView.scrollRectToVisible(frame, animated: true)
        }
    
}

extension PostVC{
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

                if let locality = placemark.locality {
                  //  addressComponents.append(locality)
                }
                
                if let country = placemark.country {
                    addressComponents.append(country)
                }

                // Join all the address components to get the complete address
                let address = addressComponents.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
}

extension PostVC:PostVMObserver{
    func observePostAddedSucessfull() {
        
        if self.comeForm == "Edit"{
            self.showMessage(message: "Post updated successfully", isError: .success)
        }else{
            self.showMessage(message: "Post added successfully", isError: .success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
           
            let window: UIWindow? = HEIGHT.window
            let vc = TabBarController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            window?.rootViewController = navVC
            window?.frame = UIScreen.main.bounds
            window?.makeKeyAndVisible()
           
        })
        
    }
     
}

