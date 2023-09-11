

//
//  TagListVM.swift
//  Trongu
//
//  Created by apple on 08/08/23.
//

import UIKit
import YPImagePicker
import CoreLocation

protocol TagListVMObserver: NSObjectProtocol {
    func observeGetTagListSucessfull()
    
}

class TagListVM: NSObject {
    
    var observer: TagListVMObserver?
    var arrTagList:[TagList] = []
    
    init(observer: TagListVMObserver?) {
        self.observer = observer
    }
    
    //MARK: Tag List Api
    func apiTagList() {
            var params = JSON()
             params = [:]
            print("params : ", params)

    //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        
        ApiHandler.call(apiName: API.Name.tagList, params: params, httpMethod: API.HttpMethod.GET) { [weak self] succeeded, response, data in
                DispatchQueue.main.async {
    //        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
                    
                    if let self = self {
                        if succeeded == true, let data {
                            let decoder = JSONDecoder()
                            do {
                                let decoded = try decoder.decode(TagListModel.self, from: data)
                                let tagList = decoded.followers
                                self.arrTagList.append(contentsOf: tagList ?? [])
                                let tagList2 = decoded.followings
                                self.arrTagList.append(contentsOf: tagList2 ?? [])
                                self.observer?.observeGetTagListSucessfull()
                            } catch {
                                print("error", error)
                            }
                        } else {
                            if let message = response["message"] as? String {
                              //  self.showMessage(message: message, isError: .error)
                            }
                        }
                    }
                }
            }
        }
    
    


    
    
    func getPath(for fileName: String) -> String? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentDirectoryURL = urls.first {
            let filePath = documentDirectoryURL.appendingPathComponent(fileName).path
            if fileManager.fileExists(atPath: filePath) {
                return filePath
            } else {
                return nil
            }
        }
        
        return nil
    }
    


    func getFileURL(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        
        // Get the document directory URL
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Search for the file in the document directory
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                return fileURL
            }
        }
        
        return nil
    }
    
    
    func validateCreatePostDetails(imageSelected:Bool,budget:String,noOfDays:String,tripCat:String,desc:String,tripComp:String) -> Bool {
        let isvalidUsername = Validator.validatePrice(price: budget)
        let isvalidEmail = Validator.validateNoOffDays(days: noOfDays)
        let isvalidPhoneNumber = Validator.validateTripCat(tripCat: tripCat)
        let isValidPassword = Validator.validateDescs(caption: desc)
        let isValidConfirmPassword = Validator.validateTripComplex(tripComp: tripComp)

        guard imageSelected == true else {
            Singleton.showMessage(message: "Please select at leaset one video or image to post", isError: .error)
            return false
        }
        guard isvalidUsername.0 == true else {
            Singleton.showMessage(message: "\(isvalidUsername.1)", isError: .error)
            print("isvalidUsername  \(isvalidUsername)")
            return false
        }
        guard isvalidEmail.0 == true else {
            Singleton.showMessage(message: "\(isvalidEmail.1)", isError: .error)
            print("isvalidEmail  \(isvalidEmail)")
            return false
        }
        guard isvalidPhoneNumber.0 == true else {
            Singleton.showMessage(message: "\(isvalidPhoneNumber.1)", isError: .error)
            print("isvalidPhoneNumber  \(isvalidPhoneNumber)")
            return false
        }
        guard isValidPassword.0 == true else {
            Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
            print("isValidPassword  \(isValidPassword)")
            return false
        }
        guard isValidConfirmPassword.0 == true else {
            Singleton.showMessage(message: "\(isValidConfirmPassword.1)", isError: .error)
            print("isValidConfirmPassword  \(isValidConfirmPassword)")
            return false
        }
        
        return true
    }
    
}
