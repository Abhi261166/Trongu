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
    
    var image = ["PostFirstImage","PostSecondImage"]
    var delegate: HomeTVCellDelegate?
    var controller:UIViewController?
    var arrPostImagesVideosList : [PostImagesVideo] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(UINib(nibName: "HomeCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeCVCell")
        
        pageController.hidesForSinglePage = true
       // self.pageController.numberOfPages = arrPostImagesVideosList.count
        
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageController.currentPage = Int(roundedIndex)
    }
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        
        let dict = arrPostImagesVideosList[indexPath.row]
        cell.postImage.setImage(image: dict.image)
        
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
   
}
