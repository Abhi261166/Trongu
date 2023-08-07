//
//  BucketListVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit

class BucketListVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bucketListTableView: UITableView!
    
    var bucketList = [("BucketListImage_1","Christian","Lorem Ipsum is simply dummy text of the printing and typesetting industry."),("BucketListImage_2","Apollonia","Lorem Ipsum is simply dummy text of the printing and typesetting industry. ")]
    
    var comeFrom:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bucketListTableView.delegate = self
        self.bucketListTableView.dataSource = self
        self.bucketListTableView.register(UINib(nibName: "BucketListTVCell", bundle: nil), forCellReuseIdentifier: "BucketListTVCell")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.comeFrom == "NotFromTabbar"{
            backButton.isHidden = false
        }
            
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension BucketListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListTVCell", for: indexPath) as! BucketListTVCell
        cell.profileImage.image = UIImage(named: bucketList[indexPath.row].0)
        cell.nameLabel.text = "\(bucketList[indexPath.row].1)"
        cell.discriptionLabel.text = "\(bucketList[indexPath.row].2)"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
