//
//  MapVC.swift
//  Trongu
//
//  Created by apple on 05/07/23.
//

import UIKit
import MapKit
//import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
   // var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        mapView.overrideUserInterfaceStyle = .dark
//        locationManager = CLLocationManager()
//        locationManager.requestWhenInUseAuthorization()
        
      

        }


    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
