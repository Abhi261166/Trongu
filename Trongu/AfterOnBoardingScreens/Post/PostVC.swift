//
//  PostVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import YPImagePicker
import CoreLocation

class PostVC: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var lblNoOfDays: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblTagPeople: UILabel!
    @IBOutlet weak var lblTripComp: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTripCat: UILabel!
    
    var arrPostYP = [YPMediaItem]()
    var finalPost:Post?
    var tagIds = ""
    var tagPeople = ""
    var viewModel:PostVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.postCollectionView.delegate = self
        self.postCollectionView.dataSource = self
        self.postCollectionView.register(UINib(nibName: "PostCVCell", bundle: nil), forCellWithReuseIdentifier: "PostCVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    func setData(){
        
        lblBudget.text = finalPost?.budget
        lblTagPeople.text = tagPeople
        lblDesc.text = finalPost?.description
        lblTripCat.text = finalPost?.tripCategory
        lblTripComp.text = finalPost?.tripComplexity
        lblNoOfDays.text = finalPost?.noOfDays
        
    }
    
    func setViewModel(){
        
        self.viewModel = PostVM(observer: self)
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
       
        self.viewModel?.apiCreatePost(tags: self.tagIds, budget: finalPost?.budget ?? "", noOffDays: finalPost?.noOfDays ?? "", tripCat: "1", disc: finalPost?.description ?? "", tripComp: finalPost?.tripComplexity ?? "", arrPosts: arrPostYP, arrPosts2: finalPost?.postImagesVideo ?? [])
        
    }
    
}
extension PostVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalPost?.postImagesVideo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCVCell", for: indexPath) as! PostCVCell
        
        let post = arrPostYP[indexPath.row]
       switch post{
       case .photo(p: let photo):
           cell.imgPost.image = photo.image
          
       case .video(v: let video):
           cell.imgPost.image = video.thumbnail
           
       }
        
        getAddressFromLatLong(latitude: Double(finalPost?.postImagesVideo[indexPath.row].lat ?? "") ?? 0.0, longitude: Double(finalPost?.postImagesVideo[indexPath.row].long ?? "") ?? 0.0) { address in
            
            cell.lblPostItemAddressDateTime.text = "\(address ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].date ?? ""), \(self.finalPost?.postImagesVideo[indexPath.row].time ?? "")"
        }
           
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 290)
    }
}


extension PostVC{
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

extension PostVC:PostVMObserver{
    func observePostAddedSucessfull() {
        
        self.showMessage(message: "Post added successfully", isError: .success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
           
            let window: UIWindow? = HEIGHT.window
            let vc = TabBarController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            window?.rootViewController = navVC
            window?.frame = UIScreen.main.bounds
            window?.makeKeyAndVisible()
           
        })
        
    }
     
}

