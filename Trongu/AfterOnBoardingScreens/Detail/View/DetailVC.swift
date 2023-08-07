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
    var image = ["PostFirstImage","PostSecondImage"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.register(UINib(nibName: "HomeCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeCVCell")
        pageControl.hidesForSinglePage = true
        self.pageControl.numberOfPages = 2
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        cell.postImage.image = UIImage(named: image[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 430)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageVideoLocationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
