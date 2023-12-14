//
//  FollowersVC.swift
//  Trongu
//
//  Created by apple on 03/07/23.
//

import UIKit
class FollowersVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var followersTableView: UITableView!
    @IBOutlet weak var userNameLable: UILabel!
    
    var followers = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    
    var following = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Krish"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Uddin"),("LikesImage_6","mahesh_z","Mahesh"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Uddin")]
    
    var isSelected:String?
    var viewModel:FollowersVM?
    var comeFrom:String? = "ownProfile"
    var userId:String?
    var timer: Timer?
    var followersCount = 0
    var followingCount = 0
    var userName = ""
    var completion : (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        self.followersTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        setFollowerFollowing()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setcountsAndUserName()
    }
    
    func setcountsAndUserName(){
        userNameLable.text = userName
        if followersCount == 1{
            followersButton.setTitle("\(followersCount) Follower", for: .normal)
        }else{
            followersButton.setTitle("\(followersCount) Followers", for: .normal)
        }
        followingButton.setTitle("\(followingCount) Following", for: .normal)
    }
    
    
    func setFollowerFollowing(){
        
        if isSelected == "Followers"{
            followersApiCall()
            followersView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            followingView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            followersButton.setTitleColor(.black, for: .normal)
            followingButton.setTitleColor(.gray, for: .normal)
        }else{
            followingApiCall()
            followingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            followersView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            followingButton.setTitleColor(.black, for: .normal)
            followersButton.setTitleColor(.gray, for: .normal)
            
        }
        
    }
    
    
    func setViewModel(){
         self.viewModel = FollowersVM(observer: self)
    }
    
    func apiCall(){
        self.viewModel?.arrUser = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiFollowFollowingList(search: "", userID: self.userId ?? "")
    }
    
    func followersApiCall(){
        self.viewModel?.arrUser = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiFollowFollowingList(search: "", userID: self.userId ?? "")
    }
    
    func followingApiCall(){
        self.viewModel?.arrUser = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiFollowFollowingList(search: "", userID: self.userId ?? "",isFollower:false)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
        
      //  if searchText.trim.count > 0 {
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            self.viewModel?.arrUser = []
            if isSelected == "Followers"{
                self.viewModel?.apiFollowFollowingList(search: searchText, userID: self.userId ?? "")
            }else{
                self.viewModel?.apiFollowFollowingList(search: searchText, userID: self.userId ?? "",isFollower: false)
            }
       // }
    }
    
    func updateCrossButtonVisibility() {
        crossButton.isHidden = false
        crossButton.isHidden = searchTF.text?.isEmpty ?? true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        if let completion = completion{
            popVC()
            completion()
        }
    }
    
    @IBAction func followersAction(_ sender: UIButton) {
        self.isSelected = "Followers"
        followersApiCall()
        followersView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        followingView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        followersButton.setTitleColor(.black, for: .normal)
        followingButton.setTitleColor(.gray, for: .normal)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        self.isSelected = "Following"
        followingApiCall()
        followingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        followersView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        followingButton.setTitleColor(.black, for: .normal)
        followersButton.setTitleColor(.gray, for: .normal)
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        searchTF.text = ""
        crossButton.isHidden = true
        setFollowerFollowing()
    }
}
extension FollowersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelected == "Followers"{
            if self.viewModel?.arrUser.count == 0{
                self.followersTableView.setBackgroundView(message: "No followers found")
                return 0
            }else{
                self.followersTableView.setBackgroundView(message: "")
                return self.viewModel?.arrUser.count ?? 0
            }
        }else{
            if self.viewModel?.arrUser.count == 0{
                self.followersTableView.setBackgroundView(message: "No followings found")
                return 0
            }else{
                self.followersTableView.setBackgroundView(message: "")
                return self.viewModel?.arrUser.count ?? 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if comeFrom == "ownProfile"{
            
            if isSelected == "Followers"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
                let dict = self.viewModel?.arrUser[indexPath.row]
                cell.profileImage.setImage(image: dict?.userImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                cell.userNameLabel.text = dict?.userName
                cell.nameLabel.text = dict?.name
                cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
                cell.followButton.setTitle("Remove", for: .normal)
                cell.followButton.setTitleColor(.black, for: .normal)
                cell.followButton.tag = indexPath.row
                cell.followButton.addTarget(self, action: #selector(actionRemove), for: .touchUpInside)
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
                let dict = self.viewModel?.arrUser[indexPath.row]
                cell.profileImage.setImage(image: dict?.userImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                cell.userNameLabel.text = dict?.userName
                cell.nameLabel.text = dict?.name
                cell.followedByView.isHidden = true
                cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
                cell.followButton.setTitle("Unfollow", for: .normal)
                cell.followButton.setTitleColor(.black, for: .normal)
                cell.followButton.tag = indexPath.row
                cell.followButton.addTarget(self, action: #selector(actionRemoveFromFollowing), for: .touchUpInside)
                return cell
            }
        }else{
            if isSelected == "Followers"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
                let dict = self.viewModel?.arrUser[indexPath.row]
                cell.profileImage.setImage(image: dict?.userImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                cell.userNameLabel.text = dict?.userName
                cell.nameLabel.text = dict?.name
                
                //                cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
                //                cell.followButton.setTitle("Remove", for: .normal)
                cell.followButton.setTitleColor(.black, for: .normal)
                
                switch Int(dict?.isFollow ?? ""){
                case 0:
                    cell.followButton.setTitle("Requested", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "followingBackground")
                case 1:
                    cell.followButton.setTitle("Unfollow", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "followingBackground")
                case 2:
                    cell.followButton.setTitle("Follow", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "OrengeAppColour")
                case 3:
                    cell.followButton.setTitle("Follow", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "OrengeAppColour")
                default:
                    break
                }
                
                if dict?.userID == UserDefaultsCustom.getUserData()?.id{
                    cell.followButton.isHidden = true
                }else{
                    cell.followButton.isHidden = false
                }
                
                cell.followButton.tag = indexPath.row
                cell.followButton.addTarget(self, action: #selector(actionFollowUnfollow), for: .touchUpInside)
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
                let dict = self.viewModel?.arrUser[indexPath.row]
                cell.profileImage.setImage(image: dict?.userImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                cell.userNameLabel.text = dict?.userName
                cell.nameLabel.text = dict?.name
                
                cell.followedByView.isHidden = true
                //                cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
                //                cell.followButton.setTitle("Following", for: .normal)
                cell.followButton.setTitleColor(.black, for: .normal)
                
                switch Int(dict?.isFollow ?? ""){
                case 0:
                    cell.followButton.setTitle("Requested", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "followingBackground")
                case 1:
                    cell.followButton.setTitle("Unfollow", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "followingBackground")
                case 2:
                    cell.followButton.setTitle("Follow", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "OrengeAppColour")
                case 3:
                    cell.followButton.setTitle("Follow", for: .normal)
                    cell.followButton.backgroundColor = UIColor(named: "OrengeAppColour")
                default:
                    break
                }
                
                if dict?.otherID == UserDefaultsCustom.getUserData()?.id{
                    cell.followButton.isHidden = true
                }else{
                    cell.followButton.isHidden = false
                }
                
                cell.followButton.tag = indexPath.row
                cell.followButton.addTarget(self, action: #selector(actionRemoveFromFollowing), for: .touchUpInside)
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if comeFrom == "ownProfile"{
            
            if isSelected == "Followers"{
                
                
                if self.viewModel?.arrUser[indexPath.row].userID == UserDefaultsCustom.getUserData()?.id{
                    
                    let vc = UserProfileVC()
                    vc.comeFrom = "Comment"
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc, true)
                    print("Own Profile")
                    
                }else{
                    let vc = OtherUserProfileVC()
                    vc.userId = self.viewModel?.arrUser[indexPath.row].userID
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc, true)
                }
                
            }else{
                if self.viewModel?.arrUser[indexPath.row].otherID == UserDefaultsCustom.getUserData()?.id{
                    
                    let vc = UserProfileVC()
                    vc.comeFrom = "Comment"
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc, true)
                    print("Own Profile")
                    
                }else{
                    let vc = OtherUserProfileVC()
                    vc.userId = self.viewModel?.arrUser[indexPath.row].otherID
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            if isSelected == "Followers"{
                
                
                if self.viewModel?.arrUser[indexPath.row].userID == UserDefaultsCustom.getUserData()?.id{
                    
                    let vc = UserProfileVC()
                    vc.comeFrom = "Comment"
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc, true)
                    print("Own Profile")
                    
                }else{
                    let vc = OtherUserProfileVC()
                    vc.userId = self.viewModel?.arrUser[indexPath.row].userID
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc, true)
                }
                
                
            }else{
                if self.viewModel?.arrUser[indexPath.row].otherID == UserDefaultsCustom.getUserData()?.id{
                    
                    let vc = UserProfileVC()
                    vc.comeFrom = "Comment"
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc, true)
                    print("Own Profile")
                    
                }else{
                    let vc = OtherUserProfileVC()
                    vc.userId = self.viewModel?.arrUser[indexPath.row].otherID
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
    }
    
    
    
    @objc func actionRemove(sender:UIButton){
        
        if comeFrom == "ownProfile"{
            
            if isSelected == "Followers"{
                
                self.viewModel?.apiRemoveFromFollower(userId: self.viewModel?.arrUser[sender.tag].userID ?? "")
                
            }
        }
    }
    
    @objc func actionRemoveFromFollowing(sender:UIButton){
        
        if comeFrom == "ownProfile"{
            
            if isSelected == "Followers"{
                
            }else{
                self.viewModel?.apiUnfollow(userID: self.viewModel?.arrUser[sender.tag].otherID ?? "")
            }
        }else{
            
            if isSelected == "Followers"{
                
            }else{
                self.viewModel?.apiUnfollow(userID: self.viewModel?.arrUser[sender.tag].otherID ?? "")
            }
            
        }
        
    }
    
    @objc func actionFollowUnfollow(sender:UIButton){
        
        if comeFrom == "ownProfile"{
            
            
        }else{
            
            if isSelected == "Followers"{
                self.viewModel?.apiUnfollow(userID: self.viewModel?.arrUser[sender.tag].userID ?? "")
            }
            
        }
        
        
    }
    
    
}

extension FollowersVC:FollowersVMObserver{
    
    func observeGetProfileSucessfull() {
        
        userNameLable.text = self.viewModel?.userData?.user_name
        if self.viewModel?.userData?.Followers == "1"{
            followersButton.setTitle("\(self.viewModel?.userData?.Followers ?? "") Follower", for: .normal)
        }else{
            followersButton.setTitle("\(self.viewModel?.userData?.Followers ?? "") Followers", for: .normal)
        }
        followingButton.setTitle("\(self.viewModel?.userData?.Following ?? "") Following", for: .normal)
        
    }
    
    
    func observeUnfollowSucessfull() {
        
        if comeFrom == "ownProfile"{
            self.viewModel?.apiGetProfile(userId: "", isOtherUser: false)
        }else{
            self.viewModel?.apiGetProfile(userId: "\(self.userId ?? "")", isOtherUser: true)
        }
        
        setFollowerFollowing()
    }
    
    func observeRemoveFromListSucessfull() {
        
        if comeFrom == "ownProfile"{
            self.viewModel?.apiGetProfile(userId: "", isOtherUser: false)
        }else{
            self.viewModel?.apiGetProfile(userId: "\(self.userId ?? "")", isOtherUser: true)
        }
        
        apiCall()
    }
    
    func observeFollowingListSucessfull() {
        self.followersTableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
}


