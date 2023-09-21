

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
    
    
    
    var perPage = 100
    var pageNo = 0
    var isLastPage: Bool = false
    var observer: TagListVMObserver?
    var arrTagList:[Userdetail] = []
    
    init(observer: TagListVMObserver?) {
        self.observer = observer
    }
    
    //MARK: Tag List Api
    func apiTagList() {
            var params = JSON()
        
        if UserDefaultsCustom.getUserData()?.is_private == "0"{
            params["type"] = "2"
        }else{
            params["type"] = "2"
        }
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)

    //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.tagList, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(TagListModel.self, from: data)
                            
                            if self.pageNo == 0 {
                                self.arrTagList.removeAll()
                            }
//
                            if let users = decoded.usersListing {
                                self.isLastPage = users.count < (self.perPage)
                                self.arrTagList.append(contentsOf: users)
                                print("SearchUsers:-\(users.count)")
                            }
                            self.pageNo += 1
                            self.observer?.observeGetTagListSucessfull()
                        } catch {
                            print("error", error)
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
      //  let isValidPassword = Validator.validateDescs(caption: desc)
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
//        guard isValidPassword.0 == true else {
//            Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
//            print("isValidPassword  \(isValidPassword)")
//            return false
//        }
        guard isValidConfirmPassword.0 == true else {
            Singleton.showMessage(message: "\(isValidConfirmPassword.1)", isError: .error)
            print("isValidConfirmPassword  \(isValidConfirmPassword)")
            return false
        }
        
        return true
    }
    
}
