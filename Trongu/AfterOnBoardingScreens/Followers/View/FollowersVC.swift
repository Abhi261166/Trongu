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
    
    var followers = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    
    var following = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Krish"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Uddin"),("LikesImage_6","mahesh_z","Mahesh"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Uddin")]
    
    var isSelected:String?
    var viewModel:FollowersVM?
    var comeFrom:String? = "ownProfile"
    var userId:String?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        self.followersTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFollowerFollowing()
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
        
        if searchText.trim.count > 0 {
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            if isSelected == "Followers"{
                self.viewModel?.apiFollowFollowingList(search: searchText, userID: self.userId ?? "")
            }else{
                self.viewModel?.apiFollowFollowingList(search: searchText, userID: self.userId ?? "",isFollower: false)
            }
        }
    }
    
    func updateCrossButtonVisibility() {
        crossButton.isHidden = false
        crossButton.isHidden = searchTF.text?.isEmpty ?? true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    }
}
extension FollowersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelected == "Followers"{
            if self.viewModel?.arrUser.count == 0{
                self.followersTableView.setBackgroundView(message: "No followers yet")
                return 0
            }else{
                self.followersTableView.setBackgroundView(message: "")
                return self.viewModel?.arrUser.count ?? 0
            }
        }else{
            if self.viewModel?.arrUser.count == 0{
                self.followersTableView.setBackgroundView(message: "No followings yet")
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
                cell.profileImage.setImage(image: dict?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
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
                cell.followButton.setTitle("Following", for: .normal)
                cell.followButton.setTitleColor(.black, for: .normal)
                cell.followButton.tag = indexPath.row
                cell.followButton.addTarget(self, action: #selector(actionRemoveFromFollowing), for: .touchUpInside)
                return cell
            }
        }else{
            if isSelected == "Followers"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
                let dict = self.viewModel?.arrUser[indexPath.row]
                cell.profileImage.setImage(image: dict?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
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
                    cell.followButton.setTitle("Following", for: .normal)
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
                    cell.followButton.setTitle("Following", for: .normal)
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
                
                cell.followButton.tag = indexPath.row
                cell.followButton.addTarget(self, action: #selector(actionFollowUnfollow), for: .touchUpInside)
                return cell
            }
            
        }
        
    }
    
    @objc func actionRemove(sender:UIButton){
        
        self.viewModel?.apiRemoveFromFollower(userId: self.viewModel?.arrUser[sender.tag].userID ?? "")
    }
    
    @objc func actionRemoveFromFollowing(sender:UIButton){
        
        self.viewModel?.apiUnfollow(userID: self.viewModel?.arrUser[sender.tag].otherID ?? "")
    }
    
    @objc func actionFollowUnfollow(sender:UIButton){
        
        self.viewModel?.apiUnfollow(userID: self.viewModel?.arrUser[sender.tag].otherID ?? "")
    }
    
    
}

extension FollowersVC:FollowersVMObserver{
    
    func observeUnfollowSucessfull() {
        setFollowerFollowing()
    }
    
    func observeRemoveFromListSucessfull() {
        apiCall()
    }
    
    func observeFollowingListSucessfull() {
        self.followersTableView.reloadData()
    }
    
}
