//
//  ShareProfilePopUpVC.swift
//  Trongu
//
//  Created by apple on 03/07/23.
//

import UIKit

class ShareProfilePopUpVC: PannableViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var shareTableView: UITableView!
    var profile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.shareTableView.delegate = self
        self.shareTableView.dataSource = self
        self.shareTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       // setPopUpDismiss()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
    }
    func updateCrossButtonVisibility() {
        crossButton.isHidden = false
        crossButton.isHidden = searchTF.text?.isEmpty ?? true
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
       
        searchTF.text = ""
        crossButton.isHidden = true
    }

}
extension ShareProfilePopUpVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
            cell.profileImage.image = UIImage(named: profile[indexPath.row].0)
            cell.userNameLabel.text = "\(profile[indexPath.row].1)"
            cell.nameLabel.text = "\(profile[indexPath.row].2)"
            cell.followButton.setTitle("Send", for: .normal)
            cell.followWidthCons.constant = 80
            return cell
            
        
    }
    
}
