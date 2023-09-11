//
//  ImageVideoLocationVC.swift
//  Trongu
//
//  Created by apple on 05/07/23.
//

import UIKit
import CoreLocation

class ImageVideoLocationVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageVideoCollectionView: UICollectionView!
    @IBOutlet weak var btnAddress: UIButton!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    var completion : (() -> Void)? = nil
    var arrPost:[PostImagesVideo]? = []
    var index:Int?
    
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
        
        if let completion = completion{
            self.navigationController?.popViewController(animated: true)
            completion()
        }
        
    }
}

extension ImageVideoLocationVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageVideoCVCell", for: indexPath) as! ImageVideoCVCell
        
        let dict = arrPost?[self.index ?? 0]
        
        if dict?.type == "0"{
            cell.imgPost.setImage(image: dict?.image)
            getAddressFromLatLong(latitude: Double(dict?.lat ?? "") ?? 0.0, longitude: Double(dict?.long ?? "") ?? 0.0) { address in
                self.lblAddress.text = address
            }
        }else{
            cell.imgPost.setImage(image: dict?.thumbNailImage)
            getAddressFromLatLong(latitude: Double(dict?.lat ?? "") ?? 0.0, longitude: Double(dict?.long ?? "") ?? 0.0) { address in
                self.lblAddress.text = address
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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
