//
//  HomeVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
import CoreLocation
class HomeVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var btnNotification: UIButton!
    
    var viewModel:HomeVM?
    var lastContentOffset: CGFloat = 0
    var timer: Timer?
    var comeFrom = false
    var index:IndexPath?
    var arrPostList:[Post] = []
    var comeFromFilter = false
    
    var place:String?
    var budget:String?
    var noOfDays:String?
    var tripCat:String?
    var ethnicity:String?
    var complexity:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        setViewModel()
        
        if comeFromFilter{
            
            print("Come from filter")
            
        }else{
            
            if comeFrom{
                btnBack.isHidden = false
                stackView.isHidden = true
                imgLogo.isHidden = true
                lblTitle.isHidden = false
                self.viewModel?.arrPostList = self.arrPostList
                homeTableView.scrollToRow(at: self.index!, at: .top, animated: false)
                
            }else{
                btnBack.isHidden = true
                stackView.isHidden = false
                imgLogo.isHidden = false
                lblTitle.isHidden = true
                apiCall()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // self.tabBarController?.tabBar.isHidden = false
        
        self.homeTableView.reloadData()
        
        if comeFromFilter{
            
            print("Come from filter")
            
        }else{
            
            if comeFrom{
                btnBack.isHidden = false
                stackView.isHidden = true
                imgLogo.isHidden = true
                lblTitle.isHidden = false
                self.viewModel?.arrPostList = self.arrPostList
                homeTableView.scrollToRow(at: self.index!, at: .top, animated: false)
                
            }else{
                btnBack.isHidden = true
                stackView.isHidden = false
                imgLogo.isHidden = false
                lblTitle.isHidden = true
                addRefreshControl()
              //  apiCall()
            }
        }
        
       
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        comeFromFilter = false
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            if DAVideoPlayerView.player != nil {
                DAVideoPlayerView.player?.pause()
                DAVideoPlayerView.player = nil
            }
        }
    }
    
    func addRefreshControl() {
        self.homeTableView.addRefreshControl { [self] refresh in
            
            DispatchQueue.main.async {
                self.apiCall()
            }
            
            refresh.endRefreshing()
            
            }
    }
    
    func setViewModel(){
        self.viewModel = HomeVM(observer: self)
    }
    
    func apiCall(){
        self.viewModel?.pageNo = 0
        self.viewModel?.arrPostList = []
        self.viewModel?.apiHomePostList()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        let vc = SearchVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = NotificationVC()
        vc.completion = {
            if isfromAppDelegates{
                self.btnNotification.setImage(UIImage(named: "ic_Notification"), for: .normal)
                
            }else{
                self.viewModel?.notificationCount = 0
                if self.viewModel?.notificationCount == 0{
                    self.btnNotification.setImage(UIImage(named: "ic_Notification"), for: .normal)
                }else{
                    self.btnNotification.setImage(UIImage(named: "ic_notificationWithBages"), for: .normal)
                }
            }
            
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = FilterScreenVC()
        
        vc.completion = {place,budget,noOfDays,tripCat,ethnicity,complexity in
            
            print("place - ",place ?? "")
            print("budget - ",budget ?? "")
            print("noOfDays - ",noOfDays ?? "")
            print("tripCat - ",tripCat ?? "")
            print("ethnicity - ",ethnicity ?? "")
            print("complexity - ",complexity ?? "")
            
            self.place = place
            self.budget = budget
            self.noOfDays = noOfDays
            self.tripCat = tripCat
            self.ethnicity = ethnicity
            self.complexity = complexity
            
            self.comeFromFilter = true
            self.viewModel?.pageNo = 0
            self.viewModel?.apiFilterHomePostList(place: place, budget: budget, noOfDays: noOfDays, tripCat: tripCat, ethnicity: ethnicity, complexity: complexity)
            
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UItableView Delegates and DataSource -

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
        if (self.viewModel?.arrPostList.count ?? 0) > 0 {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        cell.delegate = self
        cell.tableDelegate = self
        cell.controller = self
        cell.homeCollectionView.reloadData()
        
            let dict = self.viewModel?.arrPostList[indexPath.row]
            
            cell.otherUserProfileImage.setImage(image: dict?.userDetail.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
            cell.lblName.text = dict?.userDetail.name
            cell.lblTripComplexity.text = dict?.trip_complexity_name
            cell.lblDesc.text = dict?.description
            
            //        getAddressFromLatLong(latitude: Double(dict?.postImagesVideo.first?.lat ?? "") ?? 0.0, longitude: Double(dict?.postImagesVideo.first?.long ?? "") ?? 0.0) { address in
            //            cell.lblTimeAddress.text = "\(dict?.postImagesVideo.first?.time ?? "") \(address ?? "")"
            //           // cell.lblTopAddress.text = "\(address ?? "")"
            //            cell.lblAddressPriceDays.text = " $\(dict?.budget ?? "") \(dict?.noOfDays ?? "")"
            //        }
            cell.lblTimeAddress.text = "\(dict?.postImagesVideo.first?.date ?? "") \(dict?.postImagesVideo.first?.time ?? "") \(dict?.postImagesVideo.first?.place ?? "")"
            cell.lblTopAddress.text = "\(dict?.postImagesVideo.first?.country ?? "")"
            
            if dict?.no_of_days_name == "1"{
                cell.lblAddressPriceDays.text = " $\(dict?.budget ?? "") (\(dict?.no_of_days_name ?? "") day)"
            }else{
                cell.lblAddressPriceDays.text = " $\(dict?.budget ?? "") (\(dict?.noOfDays ?? "") days)"
            }
            
            if dict?.isLike == "1"{
                cell.btnLike.isSelected = true
                cell.btnDislike.isSelected = false
            }else if dict?.isLike == "0"{
                cell.btnLike.isSelected = false
                cell.btnDislike.isSelected = false
            }else{
                cell.btnDislike.isSelected = true
                cell.btnLike.isSelected = false
            }
            
            if dict?.post_like_count == "1"{
                cell.btnLikeCount.setTitle("\(dict?.post_like_count ?? "0") like", for: .normal)
                cell.btnLikeCount.isHidden = false
            }else if dict?.post_like_count == "0"{
                cell.btnLikeCount.isHidden = true
            }else {
                cell.btnLikeCount.isHidden = false
                cell.btnLikeCount.setTitle("\(dict?.post_like_count ?? "0") likes", for: .normal)
            }
            
            //        let date = getDate(dateStr: dict?.createdAt ?? "")
            //        print(date as Any,"Post date is")
            //        cell.lblPostCreatedTime.text = date?.timeAgoSinceDate()
            
            let timestamp = Int(dict?.createdAt ?? "") ?? 0
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            cell.lblPostCreatedTime.text = date.timeAgoSinceDate()
            
            cell.setPostData(postData: self.viewModel?.arrPostList[indexPath.row].postImagesVideo ?? [],budget: dict?.budget ?? "",noOfDays: dict?.noOfDays ?? "")
            
            
            if dict?.commentCount ?? "" == "0"{
                cell.btnViewAllComments.isHidden = true
            }else if dict?.commentCount ?? "" == "1"{
                cell.btnViewAllComments.isHidden = false
                cell.btnViewAllComments.setTitle("View \(dict?.commentCount ?? "") comment", for: .normal)
                
                cell.lblLatestComments.setAttributed2(str1: dict?.latestComments?.first?.user_name ?? "", font1: UIFont.setCustom(.Poppins_Medium, 12), color1: .black, str2: dict?.latestComments?.first?.comment ?? "", font2: UIFont.setCustom(.Poppins_Regular, 12), color2: .systemGray)
            }else{
                cell.btnViewAllComments.isHidden = false
                cell.btnViewAllComments.setTitle("View all \(dict?.commentCount ?? "") comments", for: .normal)
                cell.lblLatestComments.setAttributed3(str1: dict?.latestComments?.first?.user_name ?? "", font1: UIFont.setCustom(.Poppins_Medium, 12), color1: .black, str2: dict?.latestComments?.first?.comment ?? "", font2: UIFont.setCustom(.Poppins_Regular, 12), color2: .systemGray,str3: "\n\(dict?.latestComments?.last?.user_name ?? "")", font3: UIFont.setCustom(.Poppins_Medium, 12), color3: .black, str4: dict?.latestComments?.last?.comment ?? "", font4: UIFont.setCustom(.Poppins_Regular, 12), color4: .systemGray)
            }
            cell.btnViewAllComments.tag = indexPath.row
            cell.btnViewAllComments.addTarget(target: self, action: #selector(actionViewAllComments))
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let postsCount = self.viewModel?.arrPostList.count else { return }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
       
        cell.homeCollectionView.reloadData()
        
        if indexPath.row == postsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
            if comeFrom{
                
            }else{
                self.viewModel?.apiHomePostList()
            }
        }
        
        if (self.lastContentOffset > tableView.contentOffset.y) {
            print("scrolling up")
//            self.view.sendSubviewToBack(cell)
            self.homeTableView.sendSubviewToBack(cell)
        } else if (self.lastContentOffset < tableView.contentOffset.y) {
            print("scrolling Down")
//            self.view.sendSubviewToBack(cell)
            self.homeTableView.bringSubviewToFront(cell)
        }
        self.lastContentOffset = tableView.contentOffset.y
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let player = DAVideoPlayerView.player {
            player.pause()
            DAVideoPlayerView.player = nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func getDate(dateStr:String) -> Date? {
        
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()

        // Set the date format to match the format of the input string
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust this format according to your input string
       // dateFormatter.timeZone = TimeZone.current
        // The string you want to convert to a Date
        let dateString = dateStr // Replace this with your input string

        // Convert the string to a Date
        if let date = dateFormatter.date(from: dateString) {
            print(date)
            return date
        } else {
            print("Failed to convert string to date")
            return Date()
        }
       
    }
    
    @objc func actionViewAllComments(sender:UIButton){
        
        let vc = CommentVC()
        vc.postId = self.viewModel?.arrPostList[sender.tag].id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
 
}


extension HomeVC: HomeTVCellDelegate{
    
    func didTapProfileBtn(_ indexPath: IndexPath) {
        
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            if self.viewModel?.arrPostList[indexPath.row].userDetail.id == UserDefaultsCustom.getUserData()?.id{
                
                self.navigationController?.tabBarController?.selectedIndex = 4
                
            }else{
                let vc = OtherUserProfileVC()
                vc.userId = self.viewModel?.arrPostList[indexPath.row].userDetail.id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func didTapMenu(_ indexPath: IndexPath) {
        
        if self.viewModel?.arrPostList[indexPath.row].userDetail.id == UserDefaultsCustom.getUserData()?.id{
            
            let vc = ReportPopUpVC()
             vc.controller = self
             vc.objMyPost = self.viewModel?.arrPostList[indexPath.row]
             vc.completion = {
                 self.apiCall()
             }
             vc.modalPresentationStyle = .overFullScreen
             self.present(vc, true)
            
        }else {
            let vc = BlockReportPopUpVC()
             vc.controller = self
            vc.isReported = self.viewModel?.arrPostList[indexPath.row].is_report ?? ""
            vc.userID = self.viewModel?.arrPostList[indexPath.row].userDetail.id
            vc.postId = self.viewModel?.arrPostList[indexPath.row].id
            vc.comeFrom = "Home"
            vc.completion = {
                self.apiCall()
            }
             vc.modalPresentationStyle = .overFullScreen
             self.present(vc, true)
        }
        
    }
    
    func didTapLike(_ indexPath: IndexPath, likeCount: String?) {
        
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            
           // self.viewModel?.apiLikePost(postId: self.viewModel?.arrPostList[indexPath.row].id ?? "", type: "1")
            
            self.viewModel?.apiLikePost(indexPath, postId: self.viewModel?.arrPostList[indexPath.row].id ?? "", type: "1", likeCount: likeCount)
            
        }
    }
    
    func didTapComment(_ indexPath: IndexPath) {
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            
            let vc = CommentVC()
            vc.postId = self.viewModel?.arrPostList[indexPath.row].id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapShare(_ indexPath: IndexPath) {
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            
            let vc = ShareProfilePopUpVC()
            vc.postid = self.viewModel?.arrPostList[indexPath.row].id
            vc.controller = self
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, true)
        }
        
    }
    
    func didTapmap(_ indexPath: IndexPath) {
//        let vc = MapVC()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
    //    Singleton.shared.showErrorMessage(error: "Not implemented yet", isError: .message)
    }
    
    func didTapBucketList(_ indexPath: IndexPath) {
        
//        let vc = BucketListVC()
//        vc.hidesBottomBarWhenPushed = true
//        vc.comeFrom = "NotFromTabbar"
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            
            
            self.viewModel?.apiAddTobucket(postId: self.viewModel?.arrPostList[indexPath.row].id ?? "")
        }
    }
    
    func didTapDislike(_ indexPath: IndexPath, likeCount: String?) {
        
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            
          //  self.viewModel?.apiLikePost(postId: self.viewModel?.arrPostList[indexPath.row].id ?? "", type: "2")
            self.viewModel?.apiLikePost(indexPath, postId: self.viewModel?.arrPostList[indexPath.row].id ?? "", type: "2", likeCount: likeCount)

            
        }
    }
    
    func didTapLikecountList(_ indexPath: IndexPath) {
        if self.viewModel?.arrPostList.count == 0{
            
            Singleton.shared.showErrorMessage(error: "Unable to connect with the server. Check your internet connection and try again.", isError: .error)
            
        }else{
            
            let vc = LikesVC()
            vc.controller = self
            vc.postId = self.viewModel?.arrPostList[indexPath.row].id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
   
}

// Play Video

extension HomeVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lastContentOffset = homeTableView.contentOffset.y
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        let indexPaths = self.homeTableView.visibleCells.map({$0.indexPath!}).sorted(by: {$0.item < $1.item})
        indexPaths.forEach { index in
            if let cell = self.homeTableView.cellForRow(at: index) {
                self.homeTableView.bringSubviewToFront(cell)
            }
        }
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.playCurrentVideo), userInfo: nil, repeats: false)
        
    }
    
    @objc func playCurrentVideo() {
       print("timer running")
        let visibleRect = CGRect(origin: self.homeTableView.contentOffset, size: self.homeTableView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.homeTableView.indexPathForRow(at: visiblePoint) else { return }
        guard let cell = self.homeTableView.cellForRow(at: indexPath) as? HomeTVCell else { return }
        guard let videoCell = cell.homeCollectionView?.visibleCells.first as? AddPostCVC else { return }
        if videoCell.urlString?.isImageType == false {
            if DAVideoPlayerView.player != nil {
                DAVideoPlayerView.player?.pause()
                DAVideoPlayerView.player?.isPlaying = false
                DAVideoPlayerView.player = nil
            }
            videoCell.videoPlayerView.isMuted = isMuted
            videoCell.volumeButton.isSelected = isMuted
            videoCell.videoPlayerView.play()
        }else{
            if let player = DAVideoPlayerView.player {
                player.pause()
                DAVideoPlayerView.player = nil
            }
        }
        
    }
    
    
    func getAddressFromLatLong(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error geocoding location: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                // Create a dictionary to hold the address components
                var addressComponents = [String]()

                if let country = placemark.country {
                    addressComponents.append(country)
                }

                // Join all the address components to get the complete address
                let address = addressComponents.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    
}

extension HomeVC:HomeVMObserver{
    
    
    func observeAddedToBucket() {
        
        print("Added or Removed from bucket list.")
        
    }
    
    func observeGetProfilePostsSucessfull() {
        
        self.homeTableView.reloadData()
        if DAVideoPlayerView.player?.isPlaying != true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.playCurrentVideo()
            }
        }
        
    }
    
    func observeLikedSucessfull(_ indexPath: IndexPath, likeCount: String?, type: String) {
        if comeFrom{
//            self.viewModel?.arrPostList = []
//            self.viewModel?.pageNo = 0
//            self.viewModel?.apiProfilePostDetails(type: "1", userId: "")
            
            if type == "1"{
                if self.viewModel?.arrPostList[indexPath.row].isLike == "0"{
                    self.viewModel?.arrPostList[indexPath.row].isLike = "1"
                }else{
                    self.viewModel?.arrPostList[indexPath.row].isLike = "0"
                }
                self.viewModel?.arrPostList[indexPath.row].post_like_count = likeCount ?? ""
           
            }else{
                
                if self.viewModel?.arrPostList[indexPath.row].isLike == "2"{
                    self.viewModel?.arrPostList[indexPath.row].isLike = "0"
                }else{
                    self.viewModel?.arrPostList[indexPath.row].isLike = "2"
                }
                
                self.viewModel?.arrPostList[indexPath.row].post_like_count = likeCount ?? ""
                
            }
            
            
        }else{
            if comeFromFilter{
//                print("Data not changed")
//                self.viewModel?.pageNo = 0
//                self.viewModel?.apiFilterHomePostList(place: place, budget: budget, noOfDays: noOfDays, tripCat: tripCat, ethnicity: ethnicity, complexity: complexity)
                
                if type == "1"{
                    if self.viewModel?.arrPostList[indexPath.row].isLike == "0"{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "1"
                    }else{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "0"
                    }
                    self.viewModel?.arrPostList[indexPath.row].post_like_count = likeCount ?? ""
               
                }else{
                    
                    if self.viewModel?.arrPostList[indexPath.row].isLike == "2"{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "0"
                    }else{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "2"
                    }
                    
                    self.viewModel?.arrPostList[indexPath.row].post_like_count = likeCount ?? ""
                    
                }

                
            }else{
                
               // self.apiCall()
                if type == "1"{
                    if self.viewModel?.arrPostList[indexPath.row].isLike == "0"{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "1"
                    }else{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "0"
                    }
                    self.viewModel?.arrPostList[indexPath.row].post_like_count = likeCount ?? ""
               
                }else{
                    
                    if self.viewModel?.arrPostList[indexPath.row].isLike == "2"{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "0"
                    }else{
                        self.viewModel?.arrPostList[indexPath.row].isLike = "2"
                    }
                    
                    self.viewModel?.arrPostList[indexPath.row].post_like_count = likeCount ?? ""
                    
                }
                
            }
        }
    }
    
    func observeGetHomeDataSucessfull() {
        
        self.homeTableView.reloadData()
        
        if isfromAppDelegates{
        isfromAppDelegates = false
        
        }else{
            if self.viewModel?.notificationCount == 0{
                self.btnNotification.setImage(UIImage(named: "ic_Notification"), for: .normal)
            }else{
                self.btnNotification.setImage(UIImage(named: "ic_notificationWithBages"), for: .normal)
            }
        }
        
        if DAVideoPlayerView.player?.isPlaying != true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.playCurrentVideo()
            }
        }
        
    }
}

extension HomeVC:TabBarRefreshDel {
    func scrollToTopRefresh () {
       
        if (self.viewModel?.arrPostList.count ?? 0) > 0{
            let indexPath = IndexPath(row: 0, section: 0)
            self.homeTableView?.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        self.apiCall()
        
    }
}

extension HomeVC:CellDelegate{
    func reloadCell(_ cell: HomeTVCell) {
        if let indexPath = homeTableView.indexPath(for: cell) {
            
            homeTableView.beginUpdates()
            homeTableView.reloadRows(at: [indexPath], with: .automatic)
            
            guard let cell = homeTableView.visibleCells.first as? HomeTVCell else{ return }
            
    //        cell.homeCollectionView.scrollToItem(at: IndexPath(item: cell.arrPostImagesVideosList.count, section: 0), at: .right, animated: false)
            
            homeTableView.endUpdates()
        }
    }
    
}
