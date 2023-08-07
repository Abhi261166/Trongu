//
//  MentionVC.swift
//  Trongu
//
//  Created by Abhi on 06/08/23.
//

import UIKit

class MentionVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var profile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
    }    

    func setTableViewDelegates(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MentionTVC", bundle: nil), forCellReuseIdentifier: "MentionTVC")
    }
    
}
extension MentionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MentionTVC", for: indexPath) as! MentionTVC
            cell.profileImage.image = UIImage(named: profile[indexPath.row].0)
            cell.userNameLabel.text = "\(profile[indexPath.row].1)"
            cell.nameLabel.text = "\(profile[indexPath.row].2)"
            return cell
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
