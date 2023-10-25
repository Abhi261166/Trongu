

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
    func observeGetCategoriesListSucessfull()
    func observerSendMessages(json:JSON,roomId:String?,sender:UIButton?)
    
}

class TagListVM: NSObject {
    
    
    
    var perPage = 100
    var pageNo = 0
    var isLastPage: Bool = false
    var observer: TagListVMObserver?
    var arrTagList:[Userdetail] = []
    
    var arrNoOfDays:[Category] = []
    var arrTripComplexity:[Category] = []
    var arrTripCategory:[Category] = []
    var Title = "Create Post"
    
    init(observer: TagListVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Share post -
    
    
    func apiSendMessages(message: String,type:Int,sender: UIButton?,postId:String,roomId:String) {
       var params = JSON()
        params["message"] = message
        params["type"] = type
        params["room_id"] = roomId
        params["post_id"] = postId
        print("params : ", params)
     
//        add loader
      // ActivityIndicator.shared.showActivityIndicator()
       ApiHandler.callWithMultipartForm(apiName: API.Name.sendMessage, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                sender?.isUserInteractionEnabled = true
               if succeeded == true {
                   if let message = DataDecoder.decodeData(data, type: SendMessageModel.self)?.data,
                       let json = response["data"] as? JSON {
                       self.showMessage(message: "Sent" as? String ?? "", isError: .error)
                       self.observer?.observerSendMessages(json: json, roomId: roomId, sender: sender)
                   }
               } else {
                   self.showMessage(message: response["message"] as? String ?? "", isError: .error)
               }
           }
       }
   }
    
    //MARK: - Get Categories -
    
    func apiGetCategoriesList(type:Int) {
        
        arrNoOfDays = []
        arrTripComplexity = []
        arrTripCategory = []
        
        var params = JSON()
        params["type"] = type
        print("params : ", params)
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.getCategories, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(CategoriesModel.self, from: data)
                        self.arrNoOfDays.append(contentsOf: decoded.numberOfDays)
                        self.arrTripCategory.append(contentsOf: decoded.tripCategory)
                        self.arrTripComplexity.append(contentsOf: decoded.tripComplexity)
                        self.observer?.observeGetCategoriesListSucessfull()
                    } catch {
                        print("error", error)
                    }
                }
            }
        }
    }
    
    
    //MARK: Tag List Api
    func apiTagList(text:String?) {
        var params = JSON()
        
        if UserDefaultsCustom.getUserData()?.is_private == "0"{
            params["type"] = "2"
            params["search"] = text
            
        }else{
            params["type"] = "1"
            params["search"] = text
        }
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        //        add loader
       // ActivityIndicator.shared.showActivityIndicator()
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.tagList, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
            //    ActivityIndicator.shared.hideActivityIndicator()
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
    
    
    func validateCreatePostDetails(imageSelected:Bool,budget:String,noOfDays:String,tripCat:String,desc:String,tripComp:String,controller:UIViewController?) -> Bool {
        let isvalidUsername = Validator.validatePrice(price: budget)
        let isvalidEmail = Validator.validateNoOffDays(days: noOfDays)
        let isvalidPhoneNumber = Validator.validateTripCat(tripCat: tripCat)
      //  let isValidPassword = Validator.validateDescs(caption: desc)
        let isValidConfirmPassword = Validator.validateTripComplex(tripComp: tripComp)

        guard imageSelected == true else {
            //Singleton.showMessage(message: "Please select at leaset one video or image to post", isError: .error)
            Singleton.shared.showAlert(message: "Please select at leaset one video or image to post", controller: controller, Title: self.Title)
            return false
        }
        guard isvalidUsername.0 == true else {
            
            Singleton.shared.showAlert(message: "\(isvalidUsername.1)", controller: controller, Title: self.Title)
            
            print("isvalidUsername  \(isvalidUsername)")
            return false
        }
        guard isvalidEmail.0 == true else {
          //  Singleton.showMessage(message: "\(isvalidEmail.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidEmail.1)", controller: controller, Title: self.Title)
            print("isvalidEmail  \(isvalidEmail)")
            return false
        }
        guard isvalidPhoneNumber.0 == true else {
           // Singleton.showMessage(message: "\(isvalidPhoneNumber.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidPhoneNumber.1)", controller: controller, Title: self.Title)
            
            print("isvalidPhoneNumber  \(isvalidPhoneNumber)")
            return false
        }
//        guard isValidPassword.0 == true else {
//            Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
//            print("isValidPassword  \(isValidPassword)")
//            return false
//        }
        guard isValidConfirmPassword.0 == true else {
           // Singleton.showMessage(message: "\(isValidConfirmPassword.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isValidConfirmPassword.1)", controller: controller, Title: self.Title)

            print("isValidConfirmPassword  \(isValidConfirmPassword)")
            return false
        }
        
        return true
    }
    
}
