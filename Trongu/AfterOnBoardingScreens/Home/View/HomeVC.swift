//
//  HomeVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        
    }

    @IBAction func searchAction(_ sender: UIButton) {
        let vc = SearchVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = NotificationVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = FilterScreenVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        cell.delegate = self
        cell.controller = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
}
extension HomeVC: HomeTVCellDelegate{
    
    func didTapProfileBtn(_ indexPath: IndexPath) {
        let vc = OtherUserProfileVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapMenu(_ indexPath: IndexPath) {
       let vc = ReportPopUpVC()
        vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    func didTapLike(_ indexPath: IndexPath) {
        
    }
    
    func didTapComment(_ indexPath: IndexPath) {
        let vc = CommentVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapShare(_ indexPath: IndexPath) {
        let vc = ShareProfilePopUpVC()
        vc.hidesBottomBarWhenPushed = true
       // vc.gbView?.backgroundColor = .gray
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    func didTapmap(_ indexPath: IndexPath) {
        let vc = MapVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapBucketList(_ indexPath: IndexPath) {
        let vc = BucketListVC()
        vc.hidesBottomBarWhenPushed = true
        vc.comeFrom = "NotFromTabbar"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapDislike(_ indexPath: IndexPath) {
        
    }
    
    func didTapLikecountList(_ indexPath: IndexPath) {
        let vc = LikesVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
