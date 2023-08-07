//
//  UserProfileVC.swift
//  Trongu
//
//  Created by apple on 01/07/23.
//

import UIKit

class UserProfileVC: UIViewController {
    
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var bucketListButton: UIButton!
    @IBOutlet weak var bucketListView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var userProfileCollectionView: UICollectionView!
    
    var gallery = ["OtherUserImage_1","OtherUserImage_2","OtherUserImage_3","OtherUserImage_4","OtherUserImage_5","OtherUserImage_6","OtherUserImage_7","OtherUserImage_8","OtherUserImage_9"]
    var bucketList = ["OtherUserImage_1","OtherUserImage_2","BucketListImage_3","BucketListImage_4","BucketListImage_5","OtherUserImage_6","OtherUserImage_7","BucketListImage_8","OtherUserImage_9"]
    var isSelected:String?
    var viewModel:ProfileVM?
    override func viewDidLoad() {
        super.viewDidLoad()

        galleryView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mapView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        galleryButton.isSelected = true
        self.isSelected = "Gallery"
        self.userProfileCollectionView.reloadData()
        galleryButton.isUserInteractionEnabled = false
        self.userProfileCollectionView.delegate = self
        self.userProfileCollectionView.dataSource = self
        self.userProfileCollectionView.register(UINib(nibName: "OtherUserProfileCVCell", bundle: nil), forCellWithReuseIdentifier: "OtherUserProfileCVCell")
        setViewModel()
    }
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        hitGetProfileApi()
   
    }
    func hitGetProfileApi(){
        
        self.viewModel?.apiGetProfile()
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        let vc = SettingsVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func galleryAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.isSelected = "Gallery"
        self.userProfileCollectionView.reloadData()
        galleryButton.isUserInteractionEnabled = false
        bucketListButton.isUserInteractionEnabled = true
        mapButton.isUserInteractionEnabled = true
        galleryView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mapView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListButton.isSelected = false
        mapButton.isSelected = false
        locationView.isHidden = true
        
    }
    
    @IBAction func bucketListAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.isSelected = "BucketList"
        self.userProfileCollectionView.reloadData()
        bucketListView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        galleryView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        mapView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        galleryButton.isSelected = false
        mapButton.isSelected = false
        galleryButton.isUserInteractionEnabled = true
        bucketListButton.isUserInteractionEnabled = false
        mapButton.isUserInteractionEnabled = true
        locationView.isHidden = true
    }
    
    @IBAction func mapAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        mapView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        galleryView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListButton.isSelected = false
        galleryButton.isSelected = false
        galleryButton.isUserInteractionEnabled = true
        bucketListButton.isUserInteractionEnabled = true
        mapButton.isUserInteractionEnabled = false
        locationView.isHidden = false
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = MapFilterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followersAction(_ sender: UIButton) {
        let vc = FollowersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        let vc = FollowersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editProfileAction(_ sender: UIButton) {
        let vc = EditProfileVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareProfileAction(_ sender: UIButton) {
        let vc = ShareProfilePopUpVC()
         vc.modalPresentationStyle = .overFullScreen
         self.present(vc, true)
    }
    
}
extension UserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSelected == "Gallery"{
            return gallery.count
        }else{
            return bucketList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSelected == "Gallery"{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCVCell", for: indexPath) as! OtherUserProfileCVCell
            cell.postImage.image = UIImage(named: gallery[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCVCell", for: indexPath) as! OtherUserProfileCVCell
                cell.postImage.image = UIImage(named: bucketList[indexPath.row])
                return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3), height:120)
    }
    
}

extension UserProfileVC : ProfileVMObserver{
    func observeGetProfileSucessfull() {
        DispatchQueue.main.async {
            self.setProfileData()
        }
    }
    
    func setProfileData(){
        let dict = self.viewModel?.userData
        self.profileImg.setImage(image: dict?.image ?? "",placeholder: UIImage(named: "ic_profilePlaceHolder"))
        self.nameLbl.text = dict?.name
        self.userNameLbl.text = dict?.user_name
        self.emailLbl.text = dict?.email
        self.postLbl.text = dict?.posts
        self.followerLbl.text = dict?.Followers
        self.followingLbl.text = dict?.Following
        self.bioLbl.text = dict?.bio
        self.addressLbl.text = dict?.place
    }
}
