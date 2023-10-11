//
//  UserProfileVC.swift
//  Trongu
//
//  Created by apple on 01/07/23.
//

import UIKit
import CoreLocation
import MapKit

class UserProfileVC: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var bucketListButton: UIButton!
    @IBOutlet weak var bucketListView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var userProfileCollectionView: UICollectionView!
    @IBOutlet weak var backButtonWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var btnback: UIButton!
    
    var gallery = ["OtherUserImage_1","OtherUserImage_2","OtherUserImage_3","OtherUserImage_4","OtherUserImage_5","OtherUserImage_6","OtherUserImage_7","OtherUserImage_8","OtherUserImage_9"]
    var bucketList = ["OtherUserImage_1","OtherUserImage_2","BucketListImage_3","BucketListImage_4","BucketListImage_5","OtherUserImage_6","OtherUserImage_7","BucketListImage_8","OtherUserImage_9"]
    var isSelected:String?
    var viewModel:ProfileVM?
    var filterBy:String?
    var initialLat = 0.0
    var initialLong = 0.0
    var isSelfCreatedPosts = true
    var isFromFilter = false
    var comeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        mapKitView.mapType = .hybrid
        self.userProfileCollectionView.reloadData()
        galleryButton.isUserInteractionEnabled = false
        self.userProfileCollectionView.delegate = self
        self.userProfileCollectionView.dataSource = self
        self.userProfileCollectionView.register(UINib(nibName: "OtherUserProfileCVCell", bundle: nil), forCellWithReuseIdentifier: "OtherUserProfileCVCell")
        setViewModel()
    }
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        
        hideShowBackButton()
       // self.navigationController?.tabBarController?.selectedIndex = 4
        if isFromFilter{
        }else{
            setData2()
        }
    }
    
    func hideShowBackButton(){
        
        print("comeFrom ",comeFrom)
        
        if comeFrom == "Comment"{
            backButtonWidthConstant.constant = 25
        }else{
            self.tabBarController?.tabBar.isHidden = false
            backButtonWidthConstant.constant = 0
        }
    }
    
    
    func setData2(){
        galleryView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mapView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        galleryButton.isSelected = true
        
        self.isSelected = "Gallery"
        hitGetProfileApi()
        hitGetProfilePostsApi()
        locationView.isHidden = true
        galleryButton.isUserInteractionEnabled = false
        bucketListButton.isUserInteractionEnabled = true
        mapButton.isUserInteractionEnabled = true
        bucketListButton.isSelected = false
        mapButton.isSelected = false
        locationView.isHidden = true
        
    }
    
    
    func hitGetProfileApi(){
        
        self.viewModel?.apiGetProfile(userId: "")
        
    }
    
    func hitGetProfilePostsApi(){
        self.viewModel?.arrPostList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiProfilePostDetails(type: "1", userId: "")
        
    }
    
    func hitBucketPostsApi(){
        self.viewModel?.arrPostList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiBucketList(type: "2", userId: "")
        
    }
    
    
    @IBAction func settingsAction(_ sender: UIButton) {
        let vc = SettingsVC()
       if UserDefaultsCustom.getUserData()?.is_private == "1"{
           vc.isprivate = true
       }else{
           vc.isprivate = false
       }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func galleryAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        hitGetProfilePostsApi()
        self.isSelected = "Gallery"
        self.userProfileCollectionView.reloadData()
        galleryButton.isUserInteractionEnabled = false
        bucketListButton.isUserInteractionEnabled = true
        mapButton.isUserInteractionEnabled = true
        galleryView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mapView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListButton.isSelected = false
        mapButton.isSelected = false
        locationView.isHidden = true
    }
    
    @IBAction func bucketListAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.isSelected = "BucketList"
        hitBucketPostsApi()
        self.userProfileCollectionView.reloadData()
        bucketListView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        galleryView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        mapView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        galleryButton.isSelected = false
        mapButton.isSelected = false
        galleryButton.isUserInteractionEnabled = true
        bucketListButton.isUserInteractionEnabled = false
        mapButton.isUserInteractionEnabled = true
        locationView.isHidden = true
    }
    
    @IBAction func mapAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.viewModel?.arrBucketList = []
        self.viewModel?.arrSelfCreatedPosts = []
        self.viewModel?.apiShowDataOnMap(filterBy: self.filterBy ?? "")
        
        mapView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        galleryView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        bucketListButton.isSelected = false
        galleryButton.isSelected = false
        galleryButton.isUserInteractionEnabled = true
        bucketListButton.isUserInteractionEnabled = true
        mapButton.isUserInteractionEnabled = false
        locationView.isHidden = false
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = MapFilterVC()
        
        mapKitView.removeAnnotations(mapKitView.annotations)
        vc.completion = { filterBy in
            self.isFromFilter = true
            self.viewModel?.arrBucketList = []
            self.viewModel?.arrSelfCreatedPosts = []
            self.viewModel?.apiShowDataOnMap(filterBy: filterBy)
            self.mapView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.bucketListView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            self.galleryView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            self.bucketListButton.isSelected = false
            self.galleryButton.isSelected = false
            self.galleryButton.isUserInteractionEnabled = true
            self.bucketListButton.isUserInteractionEnabled = true
            self.mapButton.isUserInteractionEnabled = false
            self.locationView.isHidden = false
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followersAction(_ sender: UIButton) {
        let vc = FollowersVC()
        vc.isSelected = "Followers"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        let vc = FollowersVC()
        vc.isSelected = "Following"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editProfileAction(_ sender: UIButton) {
        let vc = EditProfileVC()
        vc.completion = {
         //   self.navigationController?.tabBarController?.selectedIndex = 3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
               
                self.navigationController?.tabBarController?.selectedIndex = 4
               
            })
           
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareProfileAction(_ sender: UIButton) {
         
        let profileLink = URL(string: "https://www.example.com/profile")!

               let activityViewController = UIActivityViewController(activityItems: [profileLink], applicationActivities: nil)

               if let popoverController = activityViewController.popoverPresentationController {
                   popoverController.sourceView = self.view
                   popoverController.sourceRect = sender.frame
               }
               present(activityViewController, animated: true, completion: nil)
           }
    
    @IBAction func actionBack(_ sender: UIButton) {
        popVC()
    }
    
}
extension UserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSelected == "Gallery"{
            if self.viewModel?.arrPostList.count == 0{
                self.userProfileCollectionView.setBackgroundView(message: "No posts yet")
                return 0
            }else{
                self.userProfileCollectionView.setBackgroundView(message: "")
                return self.viewModel?.arrPostList.count ?? 0
            }
        }else{
            if self.viewModel?.arrPostList.count == 0{
                self.userProfileCollectionView.setBackgroundView(message: "No posts yet")
                return 0
            }else{
                self.userProfileCollectionView.setBackgroundView(message: "")
                return self.viewModel?.arrPostList.count ?? 0
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      //  if isSelected == "Gallery"{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCVCell", for: indexPath) as! OtherUserProfileCVCell
            
            let dict = self.viewModel?.arrPostList[indexPath.row]
            
            if dict?.postImagesVideo.first?.type == "0"{
                cell.postImage.setImage(image: dict?.postImagesVideo.first?.image)
            }else{
                cell.postImage.setImage(image: dict?.postImagesVideo.first?.thumbNailImage)
            }
            
            getAddressFromLatLong(latitude: Double(dict?.postImagesVideo.first?.lat ?? "") ?? 0.0, longitude: Double(dict?.postImagesVideo.first?.long ?? "") ?? 0.0) { address in
               
                cell.lblAddress.text = address
                
            }
            
           
            return cell
            
      //  }
//        else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCVCell", for: indexPath) as! OtherUserProfileCVCell
//
//                cell.postImage.image = UIImage(named: bucketList[indexPath.row])
//
//                return cell
//
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       if self.isSelected == "BucketList"{
           let vc = DetailVC()
           vc.comeFrom = "bucket"
           vc.completion = {
               
           }
           vc.postDetails = self.viewModel?.arrPostList[indexPath.row]
           vc.postId = self.viewModel?.arrPostList[indexPath.row].id
           vc.hidesBottomBarWhenPushed = true
           self.pushViewController(vc, true)
        }else{
            let vc = HomeVC()
            vc.comeFrom = true
            vc.index = indexPath
            vc.arrPostList = self.viewModel!.arrPostList
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3), height:120)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let postsCount = self.viewModel?.arrPostList.count else { return }
        if indexPath.row == postsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
            self.viewModel?.apiProfilePostDetails(type: "1", userId: "")
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

extension UserProfileVC : ProfileVMObserver{
    
    
    func observeGetMapDataSucessfull() {
        self.initialLat = Double(self.viewModel?.arrFinalList.first?.lat ?? "") ?? 0.0
        self.initialLong = Double(self.viewModel?.arrFinalList.first?.long ?? "") ?? 0.0
        
//        setLatLongData()
//        setLatLongData2()
        addAnnotations()
        isFromFilter = false
    }
    
    func observeFollowUnfollowSucessfull() {
        
    }
    
    
    func observeGetProfilePostsSucessfull() {
        
        self.userProfileCollectionView.reloadData()
        
    }
    
    func observeGetProfileSucessfull() {
        DispatchQueue.main.async {
            self.setProfileData()
        }
    }
    
    func setProfileData(){
        let dict = self.viewModel?.userData
        self.profileImg.setImage(image: dict?.image ?? "",placeholder: UIImage(named: "ic_profilePlaceHolder"))
        self.nameLbl.text = dict?.name
        self.userNameLbl.text = dict?.user_name
        self.emailLbl.text = dict?.email
        self.postLbl.text = dict?.posts
        self.followerLbl.text = dict?.Followers
        self.followingLbl.text = dict?.Following
        self.bioLbl.text = dict?.bio
        self.addressLbl.text = dict?.place
    }
}


class CustomAnnotation1: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage? // Store the custom image
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, image: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}

class CustomAnnotation2: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage? // Store the custom image
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, image: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}

extension UserProfileVC {
    func addAnnotations() {
        // Create arrays of coordinates and images
        var coordinatesArray1 :[CLLocationCoordinate2D] =  []
        
        let dict = self.viewModel?.arrSelfCreatedPosts
        
        if dict?.count ?? 0 > 0{
            
            for index in 0...(dict?.count ?? 0) - 1{
                
                let data = (CLLocationCoordinate2D(latitude: Double(dict?[index].lat ?? "") ?? 0.0, longitude: Double(dict?[index].long ?? "") ?? 0.0))
                
                coordinatesArray1.append(data)
                
            }
            
        }
        
        let imagesArray1 = [
            UIImage(named: "ic_orangePin"),
            // Add more images corresponding to each coordinate
        ]
        
        var coordinatesArray2:[CLLocationCoordinate2D] =  []
        
        let dict2 = self.viewModel?.arrBucketList
        
        if dict2?.count ?? 0 > 0{
            
            for index in 0...(dict2?.count ?? 0) - 1{
                
                let data = (CLLocationCoordinate2D(latitude: Double(dict2?[index].lat ?? "") ?? 0.0, longitude: Double(dict2?[index].long ?? "") ?? 0.0))
                
                coordinatesArray2.append(data)
                
            }
            
        }
        
        let imagesArray2 = [
            UIImage(named: "ic_redPin"),
            // Add more images corresponding to each coordinate
        ]
        
        // Create annotations and add them to the map
//        for (coordinate, image) in zip(coordinatesArray1, imagesArray1) {
//            let annotation = CustomAnnotation1(coordinate: coordinate, title: "", subtitle: "", image: image)
//            mapKitView.addAnnotation(annotation)
//
//            print("drow self created anotation")
//        }
        
        for coordinate in coordinatesArray1{
            let annotation = CustomAnnotation1(coordinate: coordinate, title: "", subtitle: "", image: UIImage(named: "ic_orangePin"))
            mapKitView.addAnnotation(annotation)
            print("drow self created anotation")
        }
        
        for coordinate in coordinatesArray2{
            let annotation = CustomAnnotation2(coordinate: coordinate, title: "", subtitle: "", image: UIImage(named: "ic_redPin"))
            mapKitView.addAnnotation(annotation)
            print("drow self bucket anotation")
        }
        
//        for (coordinate, image) in zip(coordinatesArray2, imagesArray2) {
//            let annotation = CustomAnnotation2(coordinate: coordinate, title: "", subtitle: "", image: image)
//            mapKitView.addAnnotation(annotation)
//            print("drow self bucket anotation")
//        }
        
        // Adjust the map's region to fit all annotations
        mapKitView.showAnnotations(mapKitView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation1 {
            let identifier = "CustomAnnotation1"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = customAnnotation
            }
            
            annotationView?.image = customAnnotation.image
            return annotationView
        } else if let customAnnotation = annotation as? CustomAnnotation2 {
            let identifier = "CustomAnnotation2"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = customAnnotation
            }
            
            annotationView?.image = customAnnotation.image
            return annotationView
        }
        
        return nil
    }
}



//extension UserProfileVC{
//
//    func setLatLongData(){
//
//        isSelfCreatedPosts = true
//        var locations: [(CLLocationCoordinate2D, String)] = []
//
//        let dict = self.viewModel?.arrSelfCreatedPosts
//
//        if dict?.count ?? 0 > 0{
//
//
//            for index in 0...(dict?.count ?? 0) - 1{
//
//                let data = (CLLocationCoordinate2D(latitude: Double(dict?[index].lat ?? "") ?? 0.0, longitude: Double(dict?[index].long ?? "") ?? 0.0), "\(dict?[index].time ?? ""), \(dict?[index].place ?? "")")
//
//                locations.append(data)
//
//            }
//
//            // Add annotations for each location
//            for location in locations {
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = location.0
//                annotation.title = location.1
//                mapKitView.addAnnotation(annotation)
//            }
//
//            let coordinates: [CLLocationCoordinate2D] = locations.map { $0.0 }
//            // Create a polyline from the coordinates and add it to the map
//            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//          //  mapKitView.addOverlay(polyline)
//
//            // Set initial map region
//            let initialLocation = CLLocationCoordinate2D(latitude: self.initialLat, longitude: self.initialLong)
//            let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
//            mapKitView.setRegion(region, animated: true)
//        }
//    }
//
//
//    func setLatLongData2(){
//
//        isSelfCreatedPosts = false
//
//
//
//        var locations: [(CLLocationCoordinate2D, String)] = []
//
//        let dict = self.viewModel?.arrBucketList
//
//        if dict?.count ?? 0 > 0{
//
//            for index in 0...(dict?.count ?? 0) - 1{
//
//                let data = (CLLocationCoordinate2D(latitude: Double(dict?[index].lat ?? "") ?? 0.0, longitude: Double(dict?[index].long ?? "") ?? 0.0), "\(dict?[index].time ?? ""), \(dict?[index].place ?? "")")
//
//                locations.append(data)
//
//            }
//
//            // Add annotations for each location
//            for location in locations {
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = location.0
//                annotation.title = location.1
//                mapKitView.addAnnotation(annotation)
//            }
//
//            let coordinates: [CLLocationCoordinate2D] = locations.map { $0.0 }
//            // Create a polyline from the coordinates and add it to the map
//            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//           // mapKitView.addOverlay(polyline)
//
//            // Set initial map region
//            let initialLocation = CLLocationCoordinate2D(latitude: self.initialLat, longitude: self.initialLong)
//            let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
//            mapKitView.setRegion(region, animated: true)
//        }
//    }
//
//
//    // MKMapViewDelegate method to customize annotation views
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
//
//        let identifier = "AnnotationIdentifier"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//
//            // Set a custom image for the annotation
//
//            if isSelfCreatedPosts{
//                print("in self created posts")
//                annotationView?.image = UIImage(named: "ic_orangePin")
//            }else{
//                print("in bucket")
//                annotationView?.image = UIImage(named: "ic_redPin")
//            }
//
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        return annotationView
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .systemOrange
//            renderer.lineWidth = 4
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//
//
//    func getAddressFromLatLongForMap(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//            if let error = error {
//                print("Error geocoding location: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//
//            if let placemark = placemarks?.first {
//                // Create a dictionary to hold the address components
//                var addressComponents = [String]()
//
//                if let name = placemark.name {
//                    addressComponents.append(name)
//                }
//
//                if let locality = placemark.locality {
//                    addressComponents.append(locality)
//                }
//
//                if let country = placemark.country {
//                    addressComponents.append(country)
//                }
//
//                // Join all the address components to get the complete address
//                let address = addressComponents.joined(separator: ", ")
//                completion(address)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//
//
//}
