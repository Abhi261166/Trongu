//
//  SearchGooglePlaces.swift
//  Nodat
//
//  Created by apple on 10/05/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

struct Cities {
    var lat: Double
    var long: Double
    var city: String
    var shortName: String
    var placeId: String
    
    init(lat: Double, long: Double, city: String, shortName: String, placeId: String) {
        self.lat        = lat
        self.long       = long
        self.city       = city
        self.shortName  = shortName
        self.placeId    = placeId
    }
    
    init(dict: [String:Any]) {
        let description = (dict["description"] as? String)
        self.city       = description?.components(separatedBy: ", ").first ?? ""
        self.shortName  = description ?? ""
        self.placeId    = dict["place_id"] as? String ?? ""
        self.lat = 0.0
        self.long = 0.0
    }
    
}



class SearchGooglePlaces: NSObject {
    
    typealias coordinates = (lat: Double, lng: Double)
   
//    https://maps.googleapis.com/maps/api/place/autocomplete/json?
//    input=%@
//    &types=establishment|geocode&location=%@,%@
//    &radius=500
//    &language=en
//    &key=
    
    static let apiKey          = "AIzaSyAfI25bSC3rD6gteJIHFCZ7vBCglGl6OkE"
    static let autocompleteApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
    static let detailsApi      = "https://maps.googleapis.com/maps/api/place/details/json?place_id="
    static let skuAutocomp     = "&fields=name,address_component,place_id"
    static let skuDetails      = "&fields=name,geometry&types=establishment"
    
    class func findAutocompletePredictions(fromQuery: String, callback: @escaping(([Cities])->())) {
        
        let urlString = "\(autocompleteApi)\(fromQuery)\(skuAutocomp)&key=\(apiKey)"
        print("full api name is \(urlString)")
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        print(url)
        let request = URLRequest(url: url)
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    
                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    let results = jSONresult["predictions"] as! [[String:Any]]
                    let status = jSONresult["status"] as! String
                    print("google result \(results)")
                    if status == "NOT_FOUND" || status == "REQUEST_DENIED" {
                        let userInfo: NSDictionary = ["error": jSONresult["status"]!]
                        
//   let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as? [String : AnyObject])
                        
                        print("google result userInfo error \(userInfo)")
                        callback([])
                    } else {
                        let cities = results.map({Cities(dict: $0)})
                        callback(cities)
                        
                    }
                } catch {
                    print("json error: \(error)")
                    callback([])
                }
            } else if let error = error {
                print("getting error \(error)")
                callback([])
            }
        }
        task.resume()
    }
   
    class func details(place_id: String, callback: @escaping((coordinates?) -> Void)) {
        
        let urlString = "\(detailsApi)\(place_id)\(skuDetails)&key=\(apiKey)"
        print("full api name is \(urlString)")
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        print(url)
        let request = URLRequest(url: url)
        
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            var lat: Double = 0.0
            var lng: Double = 0.0
            
            if let data = data {
                do {
                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                    print("result is *** \(jSONresult)")
                    if let results = jSONresult["result"] as? [String:Any],
                       let geometry = results["geometry"] as? [String:Any],
                       let location = geometry["location"] as? [String:Any] {
                        
                        if let longitude = location["lng"] as? Double {
                            lng = longitude
                        }
                        if let latitude = location["lat"] as? Double {
                            lat = latitude
                        }
                        callback((lat: lat, lng: lng))
                    }
                } catch {
                    print("json error: \(error)")
                    callback(nil)
                }
            } else if let error = error {
                print("getting error \(error)")
                callback(nil)
            }
        }
        task.resume()
    }
   
}
