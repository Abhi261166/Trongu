//
//  OtherUserProfileVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit
import CoreLocation
import SDWebImage

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
//        hitGetProfilePostsApi()
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
        vc.completion = { isBlocked in
            self.sideMenuButton.isHidden = false
            
            if isBlocked{
                self.popVC()
            }
        }
        vc.userID = self.userId
        self.sideMenuButton.isHidden = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    
    @IBAction func followersAction(_ sender: UIButton) {
        let vc = FollowersVC()
        
        vc.completion = {
            
        }
        vc.isSelected = "Followers"
        vc.userId = self.viewModel?.userData?.id
        vc.comeFrom = "otherUser"
        vc.userName = self.viewModel?.userData?.user_name ?? ""
        vc.followersCount = Int(self.viewModel?.userData?.Followers ?? "") ?? 0
        vc.followingCount = Int(self.viewModel?.userData?.Following ?? "") ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        let vc = FollowersVC()
        vc.completion = {
            
        }
        vc.isSelected = "Following"
        vc.userId = self.viewModel?.userData?.id
        vc.comeFrom = "otherUser"
        vc.userName = self.viewModel?.userData?.user_name ?? ""
        vc.followersCount = Int(self.viewModel?.userData?.Followers ?? "") ?? 0
        vc.followingCount = Int(self.viewModel?.userData?.Following ?? "") ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        
      //  ChatVM.apiCreateRoom(otherUserId: userId ?? "", observer: self)
        
        let vc = ChatVC(roomId: self.viewModel?.roomId ?? "", otherUserName: self.viewModel?.userData?.name ?? "", otherUserId: self.viewModel?.userData?.id ?? "", otherUserProfileImage: self.viewModel?.userData?.image ?? "" )
        vc.comeFrom = "Profile"
        self.pushViewController(vc, true)
       
    }
    
    @IBAction func followAction(_ sender: UIButton) {
        btnFollow.isUserInteractionEnabled = false
        self.viewModel?.apiFollowUnfollow(userID: userId ?? "")
        
    }
    
}
extension OtherUserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.viewModel?.arrPostList.count == 0{
            self.OtherUserCollectionView.setBackgroundView(message: "This account is private.")
            return 0
        }else{
            self.OtherUserCollectionView.setBackgroundView(message: "")
            return self.viewModel?.arrPostList.count ?? 0
        }
        
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
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = DetailVC()
        
        vc.completion = {
            
        }
        
        vc.postDetails = self.viewModel?.arrPostList[indexPath.row]
        vc.postId = self.viewModel?.arrPostList[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        
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
    func observeGetMapDataSucessfull() {
        
    }
    
    func observeFollowUnfollowSucessfull() {
        apiCall()
        
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
        
        self.imgProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfilePic.sd_imageIndicator?.startAnimatingIndicator()
        self.imgProfilePic.sd_setImage(with: URL(string: dict?.image ?? ""), placeholderImage: UIImage(named: PlaceHolderImages.profilePlaceholder), context: nil)
        
       // self.imgProfilePic.setImage(image: dict?.image ?? "",placeholder: UIImage(named: "ic_profilePlaceHolder"))
      
        
        self.lblName.text = dict?.name
        self.lblUserName.text = dict?.user_name
        self.lblEmail.text = dict?.email
        self.lblPosts.text = dict?.posts
        self.lblFollowers.text = dict?.Followers
        self.lblFollowing.text = dict?.Following
        self.lblBio.text = dict?.bio
        self.lblAddress.text = dict?.place
        
        //0=>requested,1=>accept,2=>reject,3=>not requested
        
        let followStatus = Int(dict?.is_follow ?? "")
        
        switch followStatus{
        case 0:
            self.btnFollow.setTitle("Requested", for: .normal)
            self.btnFollow.backgroundColor = UIColor(named: "followingBackground")
        case 1:
            self.btnFollow.setTitle("Unfollow", for: .normal)//Unfollow
            self.btnFollow.backgroundColor = UIColor(named: "followingBackground")
        case 2:
            self.btnFollow.setTitle("Follow", for: .normal)
            self.btnFollow.backgroundColor = UIColor(named: "OrengeAppColour")
        case 3:
            self.btnFollow.setTitle("Follow", for: .normal)
            self.btnFollow.backgroundColor = UIColor(named: "OrengeAppColour")
        default:
            break
        }
        
        btnFollow.isUserInteractionEnabled = true
        
        if dict?.is_private == "1"{
            if followStatus == 1{
                viewMessage.isHidden = false
                hitGetProfilePostsApi()
            }else if followStatus == 0{
                viewMessage.isHidden = true
                self.viewModel?.arrPostList = []
                self.OtherUserCollectionView.reloadData()
                self.OtherUserCollectionView.setBackgroundView(message: "This account is private.")
            }else if followStatus == 2{
                viewMessage.isHidden = true
                self.viewModel?.arrPostList = []
                self.OtherUserCollectionView.reloadData()
                self.OtherUserCollectionView.setBackgroundView(message: "This account is private.")
            } else{
                self.OtherUserCollectionView.setBackgroundView(message: "This account is private.")
                viewMessage.isHidden = true
            }
        }else{
            viewMessage.isHidden = false
            hitGetProfilePostsApi()
        }
        
    }
    
}

extension OtherUserProfileVC: CreateRoomObserver{
    
    func observeCreateRoom(model: ChatUserData, sender: UIButton?) {
        //        let vc = ChatVC(roomId: model.roomID, otherUserName: self.viewModel?.userData?.name ?? "", otherUserId: model.userID, otherUserProfileImage: self.viewModel?.userData?.image ?? "" )
        //        vc.comeFrom = "Profile"
        //        self.pushViewController(vc, true)
    }
   
}

