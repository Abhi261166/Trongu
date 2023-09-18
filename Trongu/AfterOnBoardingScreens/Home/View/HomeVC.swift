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
    
    
    var viewModel:HomeVM?
    var lastContentOffset: CGFloat = 0
    var timer: Timer?
    var comeFrom = false
    var index:IndexPath?
    var arrPostList:[Post] = []
    var comeFromFilter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // self.tabBarController?.tabBar.isHidden = false
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            if DAVideoPlayerView.player != nil {
                DAVideoPlayerView.player?.pause()
                DAVideoPlayerView.player = nil
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        cell.delegate = self
        cell.controller = self
        cell.homeCollectionView.reloadData()
        let dict = self.viewModel?.arrPostList[indexPath.row]
        cell.otherUserProfileImage.setImage(image: dict?.userDetail.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        cell.lblName.text = dict?.userDetail.name
        cell.lblTripComplexity.text = dict?.tripComplexity
        
        cell.lblDesc.text = dict?.description
        
//        getAddressFromLatLong(latitude: Double(dict?.postImagesVideo.first?.lat ?? "") ?? 0.0, longitude: Double(dict?.postImagesVideo.first?.long ?? "") ?? 0.0) { address in
//            cell.lblTimeAddress.text = "\(dict?.postImagesVideo.first?.time ?? "") \(address ?? "")"
//           // cell.lblTopAddress.text = "\(address ?? "")"
//            cell.lblAddressPriceDays.text = " $\(dict?.budget ?? "") \(dict?.noOfDays ?? "")"
//        }
        cell.lblTimeAddress.text = "\(dict?.postImagesVideo.first?.time ?? "") \(dict?.postImagesVideo.first?.place ?? "")"
        cell.lblTopAddress.text = "\(dict?.postImagesVideo.first?.place ?? "")"
        cell.lblAddressPriceDays.text = " $\(dict?.budget ?? "") \(dict?.noOfDays ?? "")"
        
        
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
            cell.heightConsLikeButton.constant = 30
        }else if dict?.post_like_count == "0"{
            cell.heightConsLikeButton.constant = 0
            cell.btnLikeCount.setTitle("", for: .normal)
        }else {
            cell.heightConsLikeButton.constant = 30
            cell.btnLikeCount.setTitle("\(dict?.post_like_count ?? "0") likes", for: .normal)
        }
        
//        let date = getDate(dateStr: dict?.createdAt ?? "")
//        print(date as Any,"Post date is")
//        cell.lblPostCreatedTime.text = date?.timeAgoSinceDate()
        
        let timestamp = Int(dict?.createdAt ?? "") ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        cell.lblPostCreatedTime.text = date.timeAgoSinceDate()
        
        cell.setPostData(postData: self.viewModel?.arrPostList[indexPath.row].postImagesVideo ?? [],budget: dict?.budget ?? "",noOfDays: dict?.noOfDays ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let postsCount = self.viewModel?.arrPostList.count else { return }
        if indexPath.row == postsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
           // self.viewModel?.apiHomePostList()
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
 
}


extension HomeVC: HomeTVCellDelegate{
    
    func didTapProfileBtn(_ indexPath: IndexPath) {
//        let vc = OtherUserProfileVC()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
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
            vc.userID = self.viewModel?.arrPostList[indexPath.row].userDetail.id
            vc.postId = self.viewModel?.arrPostList[indexPath.row].id
            vc.completion = {
                self.apiCall()
            }
             vc.modalPresentationStyle = .overFullScreen
             self.present(vc, true)
        }
        
    }
    
    func didTapLike(_ indexPath: IndexPath) {
        
        self.viewModel?.apiLikePost(postId: self.viewModel?.arrPostList[indexPath.row].id ?? "", type: "1")
        
    }
    
    func didTapComment(_ indexPath: IndexPath) {
        let vc = CommentVC()
        vc.postId = self.viewModel?.arrPostList[indexPath.row].id
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
        
//        let vc = BucketListVC()
//        vc.hidesBottomBarWhenPushed = true
//        vc.comeFrom = "NotFromTabbar"
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.viewModel?.apiAddTobucket(postId: self.viewModel?.arrPostList[indexPath.row].id ?? "")
 
    }
    
    func didTapDislike(_ indexPath: IndexPath) {
        
        self.viewModel?.apiLikePost(postId: self.viewModel?.arrPostList[indexPath.row].id ?? "", type: "2")
        
    }
    
    func didTapLikecountList(_ indexPath: IndexPath) {
        let vc = LikesVC()
        vc.postId = self.viewModel?.arrPostList[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func observeLikedSucessfull() {
        if comeFrom{
            self.viewModel?.arrPostList = []
            self.viewModel?.pageNo = 0
            self.viewModel?.apiProfilePostDetails(type: "1", userId: "")
        }else{
            self.apiCall()
        }
       
    }
    
    func observeGetHomeDataSucessfull() {
        comeFromFilter = false
        self.homeTableView.reloadData()
        if DAVideoPlayerView.player?.isPlaying != true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.playCurrentVideo()
            }
        }
        
    }
}
