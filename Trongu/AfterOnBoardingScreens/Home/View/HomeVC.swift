//
//  HomeVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var viewModel:HomeVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       apiCall()
    }
    
    func setViewModel(){
        self.viewModel = HomeVM(observer: self)
    }
    
    func apiCall(){
        self.viewModel?.apiHomePostList()
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
        
        if self.viewModel?.arrPostList.count == 0{
            self.homeTableView.setBackgroundView(message: "No data found")
            return 0
        }else{
            self.homeTableView.setBackgroundView(message: "")
            return self.viewModel?.arrPostList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        cell.delegate = self
        cell.controller = self
        cell.pageController.numberOfPages =  self.viewModel?.arrPostList[indexPath.row].postImagesVideo.count ?? 0
        cell.arrPostImagesVideosList = self.viewModel?.arrPostList[indexPath.row].postImagesVideo ?? []
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let postsCount = self.viewModel?.arrPostList.count else { return }
        if indexPath.row == postsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
            self.viewModel?.apiHomePostList()
        }
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

extension HomeVC:HomeVMObserver{
    
    func observeGetHomeDataSucessfull() {
        self.homeTableView.reloadData()
    }
}
