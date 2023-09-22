//
//  MapCVC.swift
//  Trongu
//
//  Created by apple on 22/08/23.
//

import UIKit
import MapKit
import CoreLocation

class MapCVC: UICollectionViewCell,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnGoToPost: UIButton!
    
    var post: [PostImagesVideo] = []
    var initialLat = 0.0
    var initialLong = 0.0
    var address:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.delegate = self
        mapView.mapType = .hybrid
    }
    
    
    //    case standard = 0
    //
    //    case satellite = 1
    //
    //    case hybrid = 2
    //
    //    @available(iOS 9.0, *)
    //    case satelliteFlyover = 3
    //
    //    @available(iOS 9.0, *)
    //    case hybridFlyover = 4
    //
    //    @available(iOS 11.0, *)
    //    case mutedStandard = 5
    
    
    func setLatLongData(post:[PostImagesVideo]){
        self.post = post
        
        for index in 0...post.count - 1{
            getAddressFromLatLong(latitude: Double(post[index].lat) ?? 0.0, longitude: Double(post[index].long) ?? 0.0) { address in
                self.address.append(address ?? "")
            }
        }
        
        self.initialLat = Double(post[0].lat) ?? 0.0
        self.initialLong = Double(post[0].long) ?? 0.0
        
        // Define multiple locations with coordinates and titles
        
        var locations: [(CLLocationCoordinate2D, String)] = []
        
        for index in 0...post.count - 1{
            
            let data = (CLLocationCoordinate2D(latitude: Double(post[index].lat) ?? 0.0, longitude: Double(post[index].long) ?? 0.0), "\(post[index].time), \(post[index].place)")
            
            locations.append(data)
            
        }
        
        // Add annotations for each location
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.0
            annotation.title = location.1
            mapView.addAnnotation(annotation)
        }
        
        let coordinates: [CLLocationCoordinate2D] = locations.map { $0.0 }
        // Create a polyline from the coordinates and add it to the map
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        // Set initial map region
        let initialLocation = CLLocationCoordinate2D(latitude: self.initialLat, longitude: self.initialLong)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    // MKMapViewDelegate method to customize annotation views
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Set a custom image for the annotation
            annotationView?.image = UIImage(named: "ic_LocationOnMap")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemOrange
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
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
