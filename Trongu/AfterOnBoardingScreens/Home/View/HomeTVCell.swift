//
//  HomeTVCell.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//
import UIKit
import CoreLocation

extension UITableViewCell{
    func getTable() -> UITableView?{
        var view = self.superview
        while (view != nil && (view as? UITableView) == nil) {
            view = view?.superview
        }
        return  view as? UITableView
    }
}


protocol CellDelegate: AnyObject {
    func reloadCell(_ cell: HomeTVCell)
}

protocol HomeTVCellDelegate: NSObjectProtocol {
    //func viewUserProfile(_ indexPath: IndexPath)
    func didTapProfileBtn(_ indexPath: IndexPath)
    func didTapMenu(_ indexPath: IndexPath)
    func didTapLike(_ indexPath: IndexPath)
    func didTapComment(_ indexPath: IndexPath)
    func didTapShare(_ indexPath: IndexPath)
    func didTapmap(_ indexPath: IndexPath)
    func didTapBucketList(_ indexPath: IndexPath)
    func didTapDislike(_ indexPath: IndexPath)
    func didTapLikecountList(_ indexPath: IndexPath)
}

class HomeTVCell: UITableViewCell {
    
    //MARK: - IB Outlets -
    @IBOutlet weak var lblTopAddress: UILabel!
    @IBOutlet weak var otherUserProfileImage: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var profileBGButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddressPriceDays: UILabel!
    @IBOutlet weak var lblTripComplexity: UILabel!
    @IBOutlet weak var lblPostCreatedTime: UILabel!
    @IBOutlet weak var lblItinerary: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnViewAllComments: UIButton!
    @IBOutlet weak var lblLatestComments: UILabel!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var lblTimeAddress: UILabel!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var heightConsLikeButton: NSLayoutConstraint!
    
    //MARK: - Variables -
    
    var image = ["PostFirstImage","PostSecondImage"]
    var delegate: HomeTVCellDelegate?
    var controller:UIViewController?
    var arrPostImagesVideosList : [PostImagesVideo] = []
    var lastContentOffset: CGFloat = 0
    var timer: Timer?
    var budget = ""
    var noOfDays = ""
    var address : [String] = []
    var isReloadHome = true
    weak var tableDelegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(UINib(nibName: "HomeCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeCVCell")
        homeCollectionView.register(UINib(nibName: "AddPostCVC", bundle: nil), forCellWithReuseIdentifier: "AddPostCVC")
        homeCollectionView.register(UINib(nibName: "MapCVC", bundle: nil), forCellWithReuseIdentifier: "MapCVC")
        pageController.hidesForSinglePage = true
        
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapProfileBtn(indexPath)
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapMenu(indexPath)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let indexPath = self.indexPath {
            self.delegate?.didTapLike(indexPath)
        }
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapComment(indexPath)
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapShare(indexPath)
        }
        
    }
    
    @IBAction func mapAction(_ sender: UIButton) {
        
//        if let indexPath = self.indexPath {
//            self.delegate?.didTapmap(indexPath)
//        }
        
        homeCollectionView.scrollToItem(at: IndexPath(item: arrPostImagesVideosList.count, section: 0), at: .right, animated: true)
        
    }
    
    @IBAction func bucketListAction(_ sender: UIButton) {
        
        if let indexPath = self.indexPath {
            self.delegate?.didTapBucketList(indexPath)
        }
        
    }
    
    @IBAction func dislikeAction(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        if let indexPath = self.indexPath {
            self.delegate?.didTapDislike(indexPath)
        }
        
    }
    
    @IBAction func likeCountListAction(_ sender: UIButton) {
        
        if let indexPath = self.indexPath {
            self.delegate?.didTapLikecountList(indexPath)
        }
        
    }
    
    @IBAction func PageCotrolAction(_ sender: UIPageControl) {
        var indexPath: IndexPath!
        let current = pageController.currentPage
        indexPath = IndexPath(item: current, section: 0)
        homeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrPostImagesVideosList.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCVC", for: indexPath) as! AddPostCVC
        let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCVC", for: indexPath) as! MapCVC
        
        if indexPath.row == arrPostImagesVideosList.count{
            mapCell.setLatLongData(post: arrPostImagesVideosList)
            mapCell.btnGoToPost.tag = indexPath.row
            mapCell.btnGoToPost.addTarget(self, action: #selector(actionGoToPost),for: .touchUpInside)
            return mapCell
        }else{
            let dict = arrPostImagesVideosList[indexPath.row]
            switch dict.type {
            case "0":
                cell.setPostData(dict.image, thumbnail_image: dict.thumbNailImage)
                cell.btnDetail.tag = indexPath.row
                cell.btnDetail.addTarget(self, action: #selector(actionPostDetails),for: .touchUpInside)
            case "1":
                cell.setPostData(dict.videoURL, thumbnail_image: dict.thumbNailImage)
                cell.btnDetail.tag = indexPath.row
                cell.btnDetail.addTarget(self, action: #selector(actionPostDetails),for: .touchUpInside)
            default:
                break
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrPostImagesVideosList.count{
            print("In Map Cell")
            let vc = MapVC()
            vc.post = arrPostImagesVideosList
            vc.initialLat = Double(arrPostImagesVideosList.first?.lat ?? "") ?? 0.0
            vc.initialLong = Double(arrPostImagesVideosList.first?.long ?? "") ?? 0.0
            
            vc.hidesBottomBarWhenPushed = true
            controller?.navigationController?.pushViewController(vc, animated: true)
        }else{
            //            let vc = ImageVideoLocationVC()
            //            vc.arrPost = arrPostImagesVideosList
            //            vc.hidesBottomBarWhenPushed = true
            //            controller?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if (self.lastContentOffset > homeCollectionView.contentOffset.x) {
            print("scrolling up")
            //            self.view.sendSubviewToBack(cell)
            self.homeCollectionView.sendSubviewToBack(cell)
        } else if (self.lastContentOffset < homeCollectionView.contentOffset.x) {
            print("scrolling Down")
            //            self.view.sendSubviewToBack(cell)
            self.homeCollectionView.bringSubviewToFront(cell)
        }
        self.lastContentOffset = homeCollectionView.contentOffset.x
    }
    
    @objc func actionGoToPost(sender:UIButton){
        
        homeCollectionView.scrollToItem(at: IndexPath(item: sender.tag - 1, section: 0), at: .right, animated: true)
    }
    
    @objc func actionPostDetails(sender:UIButton){
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        self.lastContentOffset = homeCollectionView.contentOffset.x
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        let indexPaths = self.homeCollectionView.visibleCells.map({$0.indexPath!}).sorted(by: {$0.item < $1.item})
        indexPaths.forEach { index in
            
            if let cell = self.homeCollectionView.cellForItem(at: index){
                self.homeCollectionView.bringSubviewToFront(cell)
                
            }
            
        }
        
        let visibleRect = CGRect(origin: self.homeCollectionView.contentOffset, size: self.homeCollectionView.frame.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let VisibleIndexpath = self.homeCollectionView.indexPathForItem(at: visiblePoint) {
            print("VisibleIndexpath:- \(VisibleIndexpath)")
            self.pageController.currentPage = VisibleIndexpath.item
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.playCurrentVideo), userInfo: nil, repeats: false)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.pauseOnMapCell), userInfo: nil, repeats: false)
        
    }
    
    @objc func pauseOnMapCell() {
        guard let visibleCell = self.homeCollectionView.visibleCells.first as? MapCVC else { return }
        
        let tableView = self.getTable()
        tableView?.beginUpdates()
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: {
                self.lblItinerary.text = "Itinerary"
                let address = self.arrPostImagesVideosList.map({"\($0.date) \($0.time) \($0.place)"}).joined(separator: "\n")
                self.lblTimeAddress.text = address
                self.contentView.layoutIfNeeded()
            }, completion: { completed in
                self.contentView.layoutIfNeeded()
            }
        )
        tableView?.endUpdates()
        
        if let player = DAVideoPlayerView.player {
            player.pause()
            DAVideoPlayerView.player = nil
        }
        
    }
    
    @objc func playCurrentVideo() {
        
        guard let visibleCell = homeCollectionView.visibleCells.first as? AddPostCVC else { return }
        
        if visibleCell.urlString?.isImageType == false {
            if DAVideoPlayerView.player != nil {
                DAVideoPlayerView.player?.pause()
                DAVideoPlayerView.player?.isPlaying = false
                DAVideoPlayerView.player = nil
            }
            visibleCell.volumeButton.isSelected = isMuted
            visibleCell.videoPlayerView.isMuted = isMuted
            visibleCell.videoPlayerView.play()
            
            let tableView = self.getTable()
            tableView?.beginUpdates()
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.lblItinerary.text = ""
            self.lblTimeAddress.text = "\(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].date ) \(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].time ) \(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].place )"
            self.lblTopAddress.text = "\(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].country ?? "")"
            
                    self.contentView.layoutIfNeeded()
                }, completion: { completed in
                    self.contentView.layoutIfNeeded()
                }
            )
            tableView?.endUpdates()
                    
        }else if visibleCell.urlString?.isImageType == true {
            
            let tableView = self.getTable()
            tableView?.beginUpdates()
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
            
                    self.lblItinerary.text = ""
                    
            self.lblTimeAddress.text = "\(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].date ) \(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].time ) \(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].place )"
            self.lblTopAddress.text = "\(self.arrPostImagesVideosList[self.homeCollectionView.visibleCells.first?.indexPath?.row ?? 0].country ?? "")"
            
            self.contentView.layoutIfNeeded()
        }, completion: { completed in
            self.contentView.layoutIfNeeded()
        }
    )
    tableView?.endUpdates()
            
            if let player = DAVideoPlayerView.player {
                player.pause()
                DAVideoPlayerView.player = nil
            }
            
        }else{
            print("In map cell")
            
            if let player = DAVideoPlayerView.player {
                player.pause()
                DAVideoPlayerView.player = nil
            }
        }
        
    }
    
    func setPostData(postData : [PostImagesVideo], budget:String , noOfDays:String) {
        
        self.arrPostImagesVideosList = postData
        self.pageController.numberOfPages = arrPostImagesVideosList.count + 1
        
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
