//
//  DetailVC.swift
//  Trongu
//
//  Created by apple on 05/07/23.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddressPriceNoOfDays: UILabel!
    @IBOutlet weak var btnShowProfile: UIButton!
    @IBOutlet weak var lblTripComplexity: UILabel!
    @IBOutlet weak var vwBucket: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTimeAndAddress: UILabel!
    @IBOutlet weak var lblCreatedTime: UILabel!
    @IBOutlet weak var heightConsLikeButton: NSLayoutConstraint!
    
    @IBOutlet weak var lblItinerary: UILabel!
    @IBOutlet weak var btnViewAllComments: UIButton!
    @IBOutlet weak var lblLatestComments: UILabel!
    
    
    
    var image = ["PostFirstImage","PostSecondImage"]
    var postId:String?
    var viewModel:DetailsVM?
    var comeFrom = ""
    var postDetails:Post?
    var postIdFromApi = ""
    var completion : (() -> Void)? = nil
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.register(UINib(nibName: "AddPostCVC", bundle: nil), forCellWithReuseIdentifier: "AddPostCVC")
        detailCollectionView.register(UINib(nibName: "MapCVC", bundle: nil), forCellWithReuseIdentifier: "MapCVC")
        pageControl.hidesForSinglePage = true
        setViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall()
        hideShowBucket()
       // setPostData(post: postDetails)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let player = DAVideoPlayerView.player {
            player.pause()
            DAVideoPlayerView.player = nil
        }
        
    }
    
    func hideShowBucket(){
        
        if comeFrom == "bucket"{
            
            self.vwBucket.isHidden = true
        }else{
            
            self.vwBucket.isHidden = false
        }
        
    }
    
    func setViewModel(){
        
        self.viewModel = DetailsVM(observer: self)
    }
    
    func apiCall(){
        
        self.viewModel?.apiPostDetails(postId: self.postId)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        let indexPaths = self.detailCollectionView.visibleCells.map({$0.indexPath!}).sorted(by: {$0.item < $1.item})
        indexPaths.forEach { index in
            
            if let cell = self.detailCollectionView.cellForItem(at: index){
                self.detailCollectionView.bringSubviewToFront(cell)
                
            }
            
        }
        
        let visibleRect = CGRect(origin: self.detailCollectionView.contentOffset, size: self.detailCollectionView.frame.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let VisibleIndexpath = self.detailCollectionView.indexPathForItem(at: visiblePoint) {
            print("VisibleIndexpath:- \(VisibleIndexpath)")
            
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.playCurrentVideo), userInfo: nil, repeats: false)
        
    }
    
    
    @objc func playCurrentVideo() {
        
        guard let visibleCell = detailCollectionView.visibleCells.first as? AddPostCVC else { return }
        let dict = self.viewModel?.postDetails?.postImagesVideo
        if visibleCell.urlString?.isImageType == false {
            if DAVideoPlayerView.player != nil {
                DAVideoPlayerView.player?.pause()
                DAVideoPlayerView.player?.isPlaying = false
                DAVideoPlayerView.player = nil
            }
            visibleCell.volumeButton.isSelected = isMuted
            visibleCell.videoPlayerView.isMuted = isMuted
            visibleCell.videoPlayerView.play()
            
//            let tableView = self.getTable()
//            tableView?.beginUpdates()
//            UIView.animate(
//                withDuration: 0.3,
//                delay: 0,
//                animations: {
                    self.lblItinerary.text = ""
            self.lblTimeAndAddress.text = "\(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].date ?? "" ) \(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].time ?? "" ) \(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].place ?? "" )"
            self.lblAddressPriceNoOfDays.text = "\(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].country ?? "")"
            
//                    self.contentView.layoutIfNeeded()
//                }, completion: { completed in
//                    self.contentView.layoutIfNeeded()
//                }
//            )
//            tableView?.endUpdates()
                    
        }else if visibleCell.urlString?.isImageType == true {
            
//            let tableView = self.getTable()
//            tableView?.beginUpdates()
//            UIView.animate(
//                withDuration: 0.3,
//                delay: 0,
//                animations: {
            
            self.lblItinerary.text = ""
    self.lblTimeAndAddress.text = "\(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].date ?? "" ) \(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].time ?? "" ) \(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].place ?? "" )"
    self.lblAddressPriceNoOfDays.text = "\(dict?[self.detailCollectionView.visibleCells.first?.indexPath?.row ?? 0].country ?? "")"
            
//            self.contentView.layoutIfNeeded()
//        }, completion: { completed in
//            self.contentView.layoutIfNeeded()
//        }
//    )
//    tableView?.endUpdates()
            
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
     
        if comeFrom == "Push"{
            
            let window: UIWindow? = HEIGHT.window
             let vc = TabBarController()
             window?.rootViewController = vc
             window?.frame = UIScreen.main.bounds
             window?.makeKeyAndVisible()
            
        }else{
            if let completion = completion{
                popVC()
                completion()
            }
        }
       
    }
    
    @IBAction func sideMenuAction(_ sender: UIButton) {
        let vc = ReportPopUpVC()
        // vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        let vc = CommentVC()
        vc.postId = postIdFromApi
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let vc = ShareProfilePopUpVC()
        vc.postid = self.viewModel?.postDetails?.id
        vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    
    
    
    @IBAction func mapAction(_ sender: UIButton) {
//        let vc = MapVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        Singleton.shared.showErrorMessage(error: "Not implemented yet", isError: .message)
    }
    
    @IBAction func bucketListAction(_ sender: UIButton) {
        
        self.viewModel?.apiAddTobucket(postId: self.postId ?? "")
        
    }
    
    @IBAction func likeCountAction(_ sender: UIButton) {
        let vc = LikesVC()
        vc.postId = postIdFromApi
        vc.controller = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionShowProfile(_ sender: UIButton) {
        
        
    }
    
    @IBAction func actionLike(_ sender: UIButton) {
        
      
        self.viewModel?.apiLikePost(postId: postIdFromApi, type: "1")
    }
    
    @IBAction func actionDislike(_ sender: UIButton) {
        
        self.viewModel?.apiLikePost(postId: postIdFromApi, type: "2")
    }
}

extension DetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.postDetails?.postImagesVideo.count ?? 0 + 1
        
       // return self.postDetails?.postImagesVideo.count ?? 0 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCVC", for: indexPath) as! AddPostCVC
        let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCVC", for: indexPath) as! MapCVC
        
        let dict = self.viewModel?.postDetails?.postImagesVideo
        //let dict = self.postDetails?.postImagesVideo
        
        print("inSide cell -- ",indexPath.row)
        
        if indexPath.row == dict?.count{
            mapCell.setLatLongData(post: dict!)
            mapCell.btnGoToPost.tag = indexPath.row
            mapCell.btnGoToPost.addTarget(self, action: #selector(actionGoToPost),for: .touchUpInside)
            return mapCell
        }else{
            let dict = dict?[indexPath.row]
            switch dict?.type {
            case "0":
                cell.setPostData(dict?.image, thumbnail_image: dict?.thumbNailImage)
                cell.btnDetail.tag = indexPath.row
                cell.btnDetail.addTarget(self, action: #selector(actionPostDetails),for: .touchUpInside)
            case "1":
                cell.setPostData(dict?.videoURL, thumbnail_image: dict?.thumbNailImage)
                cell.btnDetail.tag = indexPath.row
                cell.btnDetail.addTarget(self, action: #selector(actionPostDetails),for: .touchUpInside)
            default:
                break
            }
                return cell
        }
       
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 430)
  
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageVideoLocationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func actionGoToPost(sender:UIButton){
        
        detailCollectionView.scrollToItem(at: IndexPath(item: sender.tag - 1, section: 0), at: .right, animated: true)
    }
    
    @objc func actionPostDetails(sender:UIButton){
        
//        let vc = ImageVideoLocationVC()
//        vc.index = sender.tag
//        vc.arrPost = arrPostImagesVideosList
//        vc.completion = {
//            self.isReloadHome = false
//        }
//        vc.hidesBottomBarWhenPushed = true
//        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

extension DetailVC:DetailsVMObserver{
    
    func observeAddedToBucket() {
        print("Added or Removed from bucket list.")
    }
    
    
    func observeLikedSucessfull() {
        apiCall()
    }
    
    
    func observeGetPostDetailsSucessfull() {
        
        DispatchQueue.main.async {
            self.setPostData(post: self.viewModel?.postDetails)
        }
        
    }
    
    func setPostData(post:Post?){
        
        let dict = post
        self.postIdFromApi = dict?.id ?? ""
        self.pageControl.numberOfPages = (dict?.postImagesVideo.count ?? 0)
        self.imgUserProfile.setImage(image: dict?.userDetail.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        self.lblName.text = dict?.userDetail.name
        self.lblTripComplexity.text = dict?.trip_complexity_name
        self.lblDescription.text = dict?.description
        self.lblTimeAndAddress.text = "\(dict?.postImagesVideo.first?.date ?? "") \(dict?.postImagesVideo.first?.time ?? "") \(dict?.postImagesVideo.first?.place ?? "")"
        
        if dict?.noOfDays == "1"{
            self.lblAddressPriceNoOfDays.text = "\(dict?.postImagesVideo.first?.country ?? "") $\(dict?.budget ?? "") (\(dict?.noOfDays ?? "") day)"
        }else{
            
            self.lblAddressPriceNoOfDays.text = "\(dict?.postImagesVideo.first?.country ?? "") $\(dict?.budget ?? "") (\(dict?.noOfDays ?? "") days)"
        }
        
        if dict?.isLike == "1"{
            self.btnLike.isSelected = true
            self.btnDislike.isSelected = false
        }else if dict?.isLike == "0"{
            self.btnLike.isSelected = false
            self.btnDislike.isSelected = false
        }else{
            self.btnDislike.isSelected = true
            self.btnLike.isSelected = false
        }
        
        if dict?.post_like_count == "1"{
            self.btnLikeCount.setTitle("\(dict?.post_like_count ?? "0") like", for: .normal)
            self.btnLikeCount.isHidden = false
        }else if dict?.post_like_count == "0"{
            self.btnLikeCount.isHidden = true
            self.btnLikeCount.setTitle("", for: .normal)
        }else {
            self.btnLikeCount.isHidden = false
            self.btnLikeCount.setTitle("\(dict?.post_like_count ?? "0") likes", for: .normal)
        }
        
        let timestamp = Int(dict?.createdAt ?? "") ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        self.lblCreatedTime.text = date.timeAgoSinceDate()
        self.detailCollectionView.reloadData()
        
        
        if dict?.commentCount ?? "" == "0"{
            btnViewAllComments.isHidden = true
        }else if dict?.commentCount ?? "" == "1"{
            btnViewAllComments.isHidden = false
            btnViewAllComments.setTitle("View \(dict?.commentCount ?? "") comment", for: .normal)
            
            lblLatestComments.setAttributed2(str1: dict?.latestComments?.first?.user_name ?? "", font1: UIFont.setCustom(.Poppins_Medium, 12), color1: .black, str2: dict?.latestComments?.first?.comment ?? "", font2: UIFont.setCustom(.Poppins_Regular, 12), color2: .systemGray)
        }else{
            btnViewAllComments.isHidden = false
            btnViewAllComments.setTitle("View all \(dict?.commentCount ?? "") comments", for: .normal)
           lblLatestComments.setAttributed3(str1: dict?.latestComments?.first?.user_name ?? "", font1: UIFont.setCustom(.Poppins_Medium, 12), color1: .black, str2: dict?.latestComments?.first?.comment ?? "", font2: UIFont.setCustom(.Poppins_Regular, 12), color2: .systemGray,str3: "\n\(dict?.latestComments?.last?.user_name ?? "")", font3: UIFont.setCustom(.Poppins_Medium, 12), color3: .black, str4: dict?.latestComments?.last?.comment ?? "", font4: UIFont.setCustom(.Poppins_Regular, 12), color4: .systemGray)
        }
        
    }
    
    
    
    
}
