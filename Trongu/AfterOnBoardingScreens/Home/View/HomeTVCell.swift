//
//  HomeTVCell.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//
import UIKit
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
    
    @IBOutlet weak var otherUserProfileImage: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var profileBGButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddressPriceDays: UILabel!
    @IBOutlet weak var lblTripComplexity: UILabel!
    @IBOutlet weak var lblPostCreatedTime: UILabel!
    @IBOutlet weak var lblHashTags: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var lblTimeAddress: UILabel!
    
    
    var image = ["PostFirstImage","PostSecondImage"]
    var delegate: HomeTVCellDelegate?
    var controller:UIViewController?
    var arrPostImagesVideosList : [PostImagesVideo] = []
    var lastContentOffset: CGFloat = 0
    var timer: Timer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(UINib(nibName: "HomeCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeCVCell")
        homeCollectionView.register(UINib(nibName: "AddPostCVC", bundle: nil), forCellWithReuseIdentifier: "AddPostCVC")
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
        if let indexPath = self.indexPath {
            self.delegate?.didTapmap(indexPath)
        }
    }
    
    @IBAction func bucketListAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapBucketList(indexPath)
        }
    }
    
    @IBAction func dislikeAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapDislike(indexPath)
        }
    }
    
    @IBAction func likeCountListAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapLikecountList(indexPath)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPostImagesVideosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCVC", for: indexPath) as! AddPostCVC
        let dict = arrPostImagesVideosList[indexPath.row]
        
        switch dict.type {
        case "0":
            cell.setPostData(dict.image, thumbnail_image: dict.thumbNailImage)
        case "1":
            cell.setPostData(dict.videoURL, thumbnail_image: dict.thumbNailImage)
        default:
            break
        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
//        let vc = DetailVC()
//        vc.hidesBottomBarWhenPushed = true
//        controller?.navigationController?.pushViewController(vc, animated: true)
  
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageController.currentPage = Int(roundedIndex)
        
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
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.playCurrentVideo), userInfo: nil, repeats: false)
    }
    
    @objc func playCurrentVideo() {
//        print("timer running")
      //  let visibleRect = CGRect(origin: self.homeCollectionView.contentOffset, size: self.homeCollectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        guard let indexPath = self.homeCollectionView.indexPathForItem(at: visiblePoint) else { return }
//        guard let cell = self.homeCollectionView.cellForItem(at: indexPath) as? HomeTVCell else { return }
//        guard let videoCell = cell.homeCollectionView?.visibleCells.first as? AddPostCVC else { return }
        
        guard let visibleCell = homeCollectionView.visibleCells.first as? AddPostCVC else { return }
        
        if visibleCell.urlString?.isImageType == false {
            if DAVideoPlayerView.player != nil {
                DAVideoPlayerView.player?.pause()
                DAVideoPlayerView.player?.isPlaying = false
                DAVideoPlayerView.player = nil
            }
           // cell.volumButton.isSelected = Singleton.isMuted
           // videoCell.videoPlayerView.isMuted = Singleton.isMuted
            visibleCell.videoPlayerView.play()
        }else{
            if let player = DAVideoPlayerView.player {
                player.pause()
                DAVideoPlayerView.player = nil
            }
        }
        
    }
    
    func setPostData(postData : [PostImagesVideo]) {
        
        self.arrPostImagesVideosList = postData
         self.pageController.numberOfPages = arrPostImagesVideosList.count

    }
    
   
}
