//
//  BlockedVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit
class BlockedVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var blockedTableView: UITableView!
    
    var blockedProfile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blockedTableView.delegate = self
        self.blockedTableView.dataSource = self
        self.blockedTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
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
extension BlockedVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
        cell.profileImage.image = UIImage(named: blockedProfile[indexPath.row].0)
        cell.userNameLabel.text = "\(blockedProfile[indexPath.row].1)"
        cell.nameLabel.text = "\(blockedProfile[indexPath.row].2)"
        cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
        cell.followButton.setTitle("Unblock", for: .normal)
        cell.followButton.setTitleColor(.black, for: .normal)
        return cell
    }
    
}
