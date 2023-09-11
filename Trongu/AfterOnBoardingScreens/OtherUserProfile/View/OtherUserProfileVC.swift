//
//  OtherUserProfileVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit
import CoreLocation

class OtherUserProfileVC: UIViewController {
    
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var OtherUserCollectionView: UICollectionView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblPosts: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblBio: UILabel!
    
    var image = ["OtherUserImage_1","OtherUserImage_3","OtherUserImage_3","OtherUserImage_4","OtherUserImage_5","OtherUserImage_6","OtherUserImage_7","OtherUserImage_8","OtherUserImage_9","OtherUserImage_7","OtherUserImage_8","OtherUserImage_9"]
    
    var userId:String?
    var viewModel:ProfileVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.OtherUserCollectionView.delegate = self
        self.OtherUserCollectionView.dataSource = self
        self.OtherUserCollectionView.register(UINib(nibName: "OtherUserProfileCVCell", bundle: nil), forCellWithReuseIdentifier: "OtherUserProfileCVCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewModel()
        apiCall()
        hitGetProfilePostsApi()
    }
    
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
    }
    
    func apiCall(){
        self.viewModel?.apiGetProfile(userId: userId ?? "",isOtherUser: true)
        
    }
    
    func hitGetProfilePostsApi(){
        self.viewModel?.arrPostList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiProfilePostDetails(type: "1", userId: userId ?? "")
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: UIButton) {
        let vc = BlockReportPopUpVC()
        vc.completion = {
            self.sideMenuButton.isHidden = false
        }
        self.sideMenuButton.isHidden = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    
    @IBAction func followersAction(_ sender: UIButton) {
        let vc = FollowersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        let vc = FollowersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        let vc = ChatVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followAction(_ sender: UIButton) {
        
        self.viewModel?.apiFollowUnfollow(userID: userId ?? "")
        
    }
    
}
extension OtherUserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.viewModel?.arrPostList.count == 0{
            self.OtherUserCollectionView.setBackgroundView(message: "No posts yet")
            return 0
        }else{
            self.OtherUserCollectionView.setBackgroundView(message: "")
            return self.viewModel?.arrPostList.count ?? 0
        }
        
        
       // return image.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCVCell", for: indexPath) as! OtherUserProfileCVCell
            
            let dict = self.viewModel?.arrPostList[indexPath.row]
            
            if dict?.postImagesVideo.first?.type == "0"{
                cell.postImage.setImage(image: dict?.postImagesVideo.first?.image)
            }else{
                cell.postImage.setImage(image: dict?.postImagesVideo.first?.thumbNailImage)
            }
            
            getAddressFromLatLong(latitude: Double(dict?.postImagesVideo.first?.lat ?? "") ?? 0.0, longitude: Double(dict?.postImagesVideo.first?.long ?? "") ?? 0.0) { address in
               
                cell.lblAddress.text = address
                
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let vc = HomeVC()
//        vc.comeFrom = true
//        vc.index = indexPath
//        vc.arrPostList = self.viewModel!.arrPostList
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let postsCount = self.viewModel?.arrPostList.count else { return }
        if indexPath.row == postsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
            self.viewModel?.apiProfilePostDetails(type: "1", userId: userId ?? "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3), height:120)
    }
    
    
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

                if let country = placemark.country {
                    addressComponents.append(country)
                }
                
                let address = addressComponents.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    
}

extension OtherUserProfileVC:ProfileVMObserver{
    
    
    func observeFollowUnfollowSucessfull() {
        
    }
    
    func observeGetProfileSucessfull() {
        DispatchQueue.main.async {
            self.setProfileData()
        }
    }
    
    func observeGetProfilePostsSucessfull() {
        
        self.OtherUserCollectionView.reloadData()
    }
    
    func setProfileData(){
        let dict = self.viewModel?.userData
        self.imgProfilePic.setImage(image: dict?.image ?? "",placeholder: UIImage(named: "ic_profilePlaceHolder"))
        self.lblName.text = dict?.name
        self.lblUserName.text = dict?.user_name
        self.lblEmail.text = dict?.email
        self.lblPosts.text = dict?.posts
        self.lblFollowers.text = dict?.Followers
        self.lblFollowing.text = dict?.Following
        self.lblBio.text = dict?.bio
        self.lblAddress.text = dict?.place
    }
    
}
