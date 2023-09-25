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
    
    var image = ["PostFirstImage","PostSecondImage"]
    var postId:String?
    var viewModel:DetailsVM?
    var comeFrom = ""
    var postDetails:Post?
    var postIdFromApi = ""
    
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
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    @IBAction func mapAction(_ sender: UIButton) {
        let vc = MapVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bucketListAction(_ sender: UIButton) {
        let vc = BucketListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func likeCountAction(_ sender: UIButton) {
        let vc = LikesVC()
        vc.postId = postIdFromApi
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
        self.lblTripComplexity.text = dict?.tripComplexity
        self.lblDescription.text = dict?.description
        self.lblTimeAndAddress.text = "\(dict?.postImagesVideo.first?.time ?? "") \(dict?.postImagesVideo.first?.place ?? "")"
        self.lblAddressPriceNoOfDays.text = "\(dict?.postImagesVideo.first?.place ?? "") $\(dict?.budget ?? "") (\(dict?.noOfDays ?? ""))"
        
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
            self.heightConsLikeButton.constant = 30
        }else if dict?.post_like_count == "0"{
            self.heightConsLikeButton.constant = 0
            self.btnLikeCount.setTitle("", for: .normal)
        }else {
            self.heightConsLikeButton.constant = 30
            self.btnLikeCount.setTitle("\(dict?.post_like_count ?? "0") likes", for: .normal)
        }
        
        let timestamp = Int(dict?.createdAt ?? "") ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        self.lblCreatedTime.text = date.timeAgoSinceDate()
        
        self.detailCollectionView.reloadData()
    }
    
    
}
