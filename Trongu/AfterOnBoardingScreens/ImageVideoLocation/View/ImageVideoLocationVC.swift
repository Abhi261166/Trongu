//
//  ImageVideoLocationVC.swift
//  Trongu
//
//  Created by apple on 05/07/23.
//

import UIKit

class ImageVideoLocationVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageVideoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.hidesForSinglePage = true
        self.pageControl.numberOfPages = 3
        imageVideoCollectionView.delegate = self
        imageVideoCollectionView.dataSource = self
        imageVideoCollectionView.register(UINib(nibName: "ImageVideoCVCell", bundle: nil), forCellWithReuseIdentifier: "ImageVideoCVCell")
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
}

extension ImageVideoLocationVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageVideoCVCell", for: indexPath) as! ImageVideoCVCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
