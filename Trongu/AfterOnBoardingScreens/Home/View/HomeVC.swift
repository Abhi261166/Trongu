//
//  HomeVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
import CoreLocation
class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var viewModel:HomeVM?
    var lastContentOffset: CGFloat = 0
    var timer: Timer?

    
    
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
        cell.homeCollectionView.reloadData()
        let dict = self.viewModel?.arrPostList[indexPath.row]
        cell.otherUserProfileImage.setImage(image: dict?.userDetail.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        cell.lblName.text = dict?.userDetail.name
        cell.lblTripComplexity.text = dict?.tripComplexity
       
        cell.btnLikeCount.setTitle("0 likes", for: .normal)
        cell.lblDesc.text = dict?.description
        
        getAddressFromLatLong(latitude: Double(dict?.postImagesVideo.first?.lat ?? "") ?? 0.0, longitude: Double(dict?.postImagesVideo.first?.long ?? "") ?? 0.0) { address in
            
            cell.lblAddressPriceDays.text = "\(address ?? "") . $\(dict?.budget ?? "") . \(dict?.noOfDays ?? "")"
        }
        
//        let date = getDate(dateStr: dict?.createdAt ?? "")
//        print(date as Any,"Post date is")
//        cell.lblPostCreatedTime.text = date?.timeAgoSinceDate()
        
        let timestamp = Int(dict?.createdAt ?? "") ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        cell.lblPostCreatedTime.text = date.timeAgoSinceDate()
        
        cell.setPostData(postData: self.viewModel?.arrPostList[indexPath.row].postImagesVideo ?? [])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let postsCount = self.viewModel?.arrPostList.count else { return }
        if indexPath.row == postsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
            self.viewModel?.apiHomePostList()
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
//        print("timer running")
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
           // cell.volumButton.isSelected = Singleton.isMuted
           // videoCell.videoPlayerView.isMuted = Singleton.isMuted
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

                if let name = placemark.name {
                    addressComponents.append(name)
                }

//                if let thoroughfare = placemark.thoroughfare {
//                    addressComponents.append(thoroughfare)
//                }

//                if let subThoroughfare = placemark.subThoroughfare {
//                    addressComponents.append(subThoroughfare)
//                }

                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }

//                if let administrativeArea = placemark.administrativeArea {
//                    addressComponents.append(administrativeArea)
//                }

//                if let postalCode = placemark.postalCode {
//                    addressComponents.append(postalCode)
//                }

//                if let country = placemark.country {
//                    addressComponents.append(country)
//                }

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
    
    func observeGetHomeDataSucessfull() {
        self.homeTableView.reloadData()
        if DAVideoPlayerView.player?.isPlaying != true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.playCurrentVideo()
            }
        }
        
    }
}
