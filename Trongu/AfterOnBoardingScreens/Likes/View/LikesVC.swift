//
//  LikesVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit
class LikesVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var likesTableView: UITableView!
    
    var likes = [("LikesImage_1","_rebeka_99","Reveka","Followed by _akshara_1..."),("LikesImage_2","mr.krish_021","Reveka","Followed by _akshara_1..."),("LikesImage_3","dessertsoul_09_","Reveka","Followed by _akshara_1..."),("LikesImage_4","_nishwan_009","Nishwan","Followed by _rebeka_1..."),("LikesImage_5","_uddin509","Reveka","Followed by _akshara_1..."),("LikesImage_6","mahesh_z","Reveka","Followed by _akshara_1..."),("LikesImage_7","_nishwan_009","Nishwan","Followed by _rebeka_1..."),("LikesImage_8","_uddin509","Reveka","Followed by _akshara_1...")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.likesTableView.delegate = self
        self.likesTableView.dataSource = self
        self.likesTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    
    @IBAction func crossAction(_ sender: UIButton) {
        searchTF.text = ""
        crossButton.isHidden = true
    }
    
}
extension LikesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
        cell.profileImage.image = UIImage(named: likes[indexPath.row].0)
        cell.userNameLabel.text = "\(likes[indexPath.row].1)"
        cell.nameLabel.text = "\(likes[indexPath.row].2)"
        cell.followedByLabel.text = "\(likes[indexPath.row].3)"
        cell.followedByView.isHidden = false
        if indexPath.row == 0 || indexPath.row ==  1 || indexPath.row == 2 {
            cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
        }
        return cell
    }
    
    
}
