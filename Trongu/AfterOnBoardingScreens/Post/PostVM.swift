//
//  PostVM.swift
//  Trongu
//
//  Created by Abhi on 15/08/23.
//

import UIKit
import YPImagePicker
import CoreLocation

protocol PostVMObserver: NSObjectProtocol {
    func observePostAddedSucessfull()
}

class PostVM: NSObject {

    var observer: PostVMObserver?
    var address = ""

    init(observer: PostVMObserver?) {
        self.observer = observer
    }
    
    func apiCreatePost(tags:String,budget:String,noOffDays:String,tripCat:String,disc:String,tripComp:String,arrPosts:[YPMediaItem],arrPosts2:[PostImagesVideo]){
        
        var arrImagesDict = [[String:Any]]()
        
        for index in 0..<arrPosts.count{
            
            let post = arrPosts[index]
            
           switch post{
           case .photo(p: let photo):
               getAddressFromLatLong(latitude: Double(arrPosts2[index].lat) ?? 0.0, longitude: Double(arrPosts2[index].long) ?? 0.0) { address in
                   self.address  = address ?? ""
               }
               
               let dictLat : [String:Any] = [
                 "key": "image[\(index)][lat]",
                 "value": arrPosts2[index].lat,
                 "type": "text"
               ]
               arrImagesDict.append(dictLat)
               
               let dictLong : [String:Any] = [
                 "key": "image[\(index)][long]",
                 "value": arrPosts2[index].long,
                 "type": "text"
               ]
               arrImagesDict.append(dictLong)
               
               let dictDate : [String:Any] = [
                 "key": "image[\(index)][date]",
                 "value":arrPosts2[index].date,
                 "type": "text"
               ]
               arrImagesDict.append(dictDate)
               
               let dictTime : [String:Any] = [
                 "key": "image[\(index)][time]",
                 "value": arrPosts2[index].time,
                 "type": "text"
               ]
               arrImagesDict.append(dictTime)
               
               let dictPlace : [String
                           :Any] = [
                 "key": "image[\(index)][place]",
                 "value": self.address,
                 "type": "text"
               ]
               arrImagesDict.append(dictPlace)
               
               let dictImageUrl : [String
                           :Any] = [
                 "key": "image[\(index)][image]",
                 "src": photo.image,
                 "type": "file"
               ]
               arrImagesDict.append(dictImageUrl) //type
               
               // start for thumb
               
//               let dictThumbImage : [String
//                           :Any] = [
//                 "key": "image[\(index)][thumb_nail_image]",
//                 "src": UIImage(),
//                 "type": "file"
//               ]
//               arrImagesDict.append(dictThumbImage)
               
               //end for thumb
               
               
               let dictType : [String
                           :Any] = [
                 "key": "image[\(index)][type]",
                 "value": "0",
                 "type": "text"
               ]
               arrImagesDict.append(dictType)
               
               
           case .video(v: let video):
               getAddressFromLatLong(latitude: Double(arrPosts2[index].lat) ?? 0.0, longitude: Double(arrPosts2[index].long) ?? 0.0) { address in
                   self.address  = address ?? ""
               }
               
               let dictLat : [String:Any] = [
                 "key": "image[\(index)][lat]",
                 "value": arrPosts2[index].lat,
                 "type": "text"
               ]
               arrImagesDict.append(dictLat)
               
               let dictLong : [String:Any] = [
                 "key": "image[\(index)][long]",
                 "value": arrPosts2[index].long,
                 "type": "text"
               ]
               arrImagesDict.append(dictLong)
               
               let dictDate : [String:Any] = [
                 "key": "image[\(index)][date]",
                 "value": arrPosts2[index].date,
                 "type": "text"
               ]
               arrImagesDict.append(dictDate)
               
               let dictTime : [String:Any] = [
                 "key": "image[\(index)][time]",
                 "value": arrPosts2[index].time,
                 "type": "text"
               ]
               arrImagesDict.append(dictTime)
               
               let dictPlace : [String
                           :Any] = [
                 "key": "image[\(index)][place]",
                 "value": self.address,
                 "type": "text"
               ]
               arrImagesDict.append(dictPlace)
               
               let dictImageUrl : [String
                           :Any] = [
                 "key": "image[\(index)][image]",
                 "src": video.url.path,
                 "type": "file"
               ]
               arrImagesDict.append(dictImageUrl)
               
               // start for thumb
               
               let dictThumbImage : [String
                           :Any] = [
                 "key": "image[\(index)][thumb_nail_image]",
                 "src": video.thumbnail,
                 "type": "file"
               ]
               arrImagesDict.append(dictThumbImage)
               
               let dictType : [String
                           :Any] = [
                 "key": "image[\(index)][type]",
                 "value": "1",
                 "type": "text"
               ]
               arrImagesDict.append(dictType)

           }
            
        }
        
        var parameters = [
          [
            "key": "tag_id",
            "value": tags,
            "type": "text"
          ],
          [
            "key": "budget",
            "value": budget,
            "type": "text"
          ],
          [
            "key": "no_of_days",
            "value": noOffDays,
            "type": "text"
          ],
          [
            "key": "trip_category",
            "value": tripCat,
            "type": "text"
          ],
          [
            "key": "description",
            "value": disc,
            "type": "text"
          ],
          [
            "key": "trip_complexity",
            "value": tripComp,
            "type": "text"
          ]] as [[String: Any]]

        parameters.append(contentsOf: arrImagesDict)
        let boundary:NSString = "----WebKitFormBoundarycC4YiaUFwM44F6rT"
                print("parameters --- ",parameters)
                
                //var body = ""
                     let body:NSMutableData = NSMutableData()
                     
                     do {
                        
                         var error: Error? = nil
                         for param in parameters {
                             let paramName = param["key"]!
                            // body += "--\(boundary)\r\n"
                             body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                          //   body += "Content-Disposition:form-data; name=\"\(paramName)\""
//                             body.append("Content-Disposition: form-data; name=\"\(paramName)\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                             

//                             if param["contentType"] != nil {
//                               //  body += "\r\nContent-Type: \(param["contentType"] as! String)"
////                                 body.append("\r\nContent-Type: \(param["contentType"] as! String)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//
//
//                             }
                             let paramType = param["type"] as! String
                             if paramType == "text" {
                                 let paramValue = param["value"] as! String
                               //  body += "\r\n\r\n\(paramValue)\r\n"
//                                 body.append("\(paramValue)\r\n" .data(using: String.Encoding.utf8 , allowLossyConversion: true)!)
//                                 body.append("Content-Disposition: form-data; name=\"\(paramName); filename=\"mm.png\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                                 
                                 body.append("Content-Disposition: form-data; name=\"\(paramName)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                                 body.append("\(paramValue)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)

                             } else {
                                 if let img = param["src"] as? UIImage{
                                    // let paramSrc = param["src"] as! String
                                     let fileName = "IMG_\(Date().miliseconds().inInt).png"
//                                     body.append(" filename=\"\(fileName)\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                                     body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)

                                     body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)

                                    
                                     if  let data = img.jpegData(compressionQuality: 0.5){
                                       //  print("cover data \(data.count)")
                                         body.append(data)
                                     }
                                     body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                                 }
                                 else{
                                     var paramSrc = param["src"] as! String
                                     var fileName = ""
                                     if paramSrc.contains(".mov") {
                                         fileName = paramSrc.replacingOccurrences(of: ".mov", with: ".mp4")
                                     }
                                     
                                     body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                                     body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                                     let fileData = try NSData(contentsOfFile: paramSrc, options: []) as Data
                                     body.append(fileData)
                                     body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                              
                                 }
                                
                             }
                         }
                        // body += "--\(boundary)--\r\n";
                         body.append("--\(boundary)--\r\n" .data(using: String.Encoding.utf8 , allowLossyConversion: true)! )
                     }catch{
                         print("error----",error.localizedDescription)
                     }
                         //let postData = body.data(using: .utf8)
                         let postData = body as Data
                
               
        var request = URLRequest(url: URL(string: "http://161.97.132.85/j1/trongu/api/v1/users/create-new-post")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(UserDefaultsCustom.getUserData()?.access_token ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        ActivityIndicator.shared.showActivityIndicator()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            ActivityIndicator.shared.hideActivityIndicator()

          print(String(data: data, encoding: .utf8)!)
            self.observer?.observePostAddedSucessfull()
        }

        task.resume()
   
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
