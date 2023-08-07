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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        self.followersTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        self.isSelected = "Followers"
        followersView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        followingView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        followersButton.setTitleColor(.black, for: .normal)
        followingButton.setTitleColor(.gray, for: .normal)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
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
        self.followersTableView.reloadData()
        followersView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        followingView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        followersButton.setTitleColor(.black, for: .normal)
        followingButton.setTitleColor(.gray, for: .normal)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        self.isSelected = "Following"
        self.followersTableView.reloadData()
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
            return followers.count
        }else{
            return following.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSelected == "Followers"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
            cell.profileImage.image = UIImage(named: followers[indexPath.row].0)
            cell.userNameLabel.text = "\(followers[indexPath.row].1)"
            cell.nameLabel.text = "\(followers[indexPath.row].2)"
            cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
            cell.followButton.setTitle("Remove", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
            cell.profileImage.image = UIImage(named: following[indexPath.row].0)
            cell.userNameLabel.text = "\(following[indexPath.row].1)"
            cell.nameLabel.text = "\(following[indexPath.row].2)"
            cell.followedByView.isHidden = true
            cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            return cell
        }
    }
    
}
