//
//  AddLocationVC.swift
//  Findr
//
//  Created by apple on 10/04/23.
//

import UIKit
import CoreMIDI
import MapKit
import CoreLocation

protocol AddLocationVCDelegate: NSObjectProtocol {
    func setLocation(text: String,lat: Double,long: Double,address:String,country:String)
}
class AddLocationVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var searchLocationTF: UITextField!
    
    
    var delegate: AddLocationVCDelegate?
    var city : [Cities] = []
    var labelLat :String?
    var labelLongi:String?
    var locationManager: CLLocationManager?
    var cuntry:String?
    var address:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchLocationTF.delegate = self
        locationTableView.delegate = self
        locationTableView.dataSource = self
       // getCurrentLocation()
        locationTableView.register(UINib(nibName: "AddLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "AddLocationTableViewCell")
    }
    
    func getCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AddLocationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationTableViewCell", for: indexPath) as? AddLocationTableViewCell else {return UITableViewCell()}
        cell.shortNameLable.text = city[indexPath.row].city
        cell.addressLable.text = city[indexPath.row].shortName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SearchGooglePlaces.details(place_id: city[indexPath.row].placeId) { coordinates in
            self.delegate?.setLocation(text: self.city[indexPath.row].city, lat: coordinates?.lat ?? 0.0, long: coordinates?.lng ?? 0.0 , address: self.city[indexPath.row].city, country: self.city[indexPath.row].shortName)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddLocationVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print("updatedText text is :-\(updatedText)")
            SearchGooglePlaces.findAutocompletePredictions(fromQuery: updatedText) { data in
                DispatchQueue.main.async {
                    self.city = data
                    print("city:- \(self.city.count)")
                    self.locationTableView.reloadData()
                }
            }
        }
        return true
    }
}
//MARK: - location delegate methods
extension AddLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.labelLat = "\(userLocation.coordinate.latitude)"
        self.labelLongi = "\(userLocation.coordinate.longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                let data = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
             //   self.currentLocationButton.setTitle(data, for: .normal)
              //  self.delegate?.currentLocatioAction(button:data)
                self.cuntry = data
                print("data :-  ******* \(data) ******   self.cuntry:-  \(self.cuntry ?? "")")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Error \(error)")
    }
}
