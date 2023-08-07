//
//  NotificationVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    var notification = [("NotificationImage_1","James Perry, are requested to follow you","4h"),("NotificationImage_2","Kevin Lowe, Started following you","5h"),("NotificationImage_3","Kevin Lowe, Started following you","12h"),("NotificationImage_4","Jasmine Blake, liked your post","13h")]
    
    var boldname = ["James Perry,","Kevin Lowe,","Kevin Lowe,","Jasmine Blake,"]
    
    var following = [" are requested to follow you"," Started following you"," Started following you"," liked your post"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: "NotificationTVCell")
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension NotificationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        cell.profileImage.image = UIImage(named: notification[indexPath.row].0)
        cell.nameLabel.text = "\(notification[indexPath.row].1)"
        cell.timeLabel.text = "\(notification[indexPath.row].2)"
        cell.nameLabel.setAttributed(str1: "\(boldname[indexPath.row])", font1: UIFont.setCustom(.Poppins_Medium, 16), color1: .black, str2: "\(following[indexPath.row])", font2: UIFont.setCustom(.Poppins_Regular, 16), color2: .gray)
        if indexPath.row == 0{
            cell.buttonStackView.isHidden = false
            cell.stackViewHeightConst.constant = 30
        }
        else{
            cell.buttonStackView.isHidden = true
            cell.stackViewHeightConst.constant = 0
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
