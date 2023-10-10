//
//  EditVM.swift
//  Trongu
//
//  Created by dr mac on 20/07/23.
//

protocol EditVMObserver: NSObjectProtocol {
    func observeGetEditProfileSucessfull()
    func observeGetCategoriesListSucessfull()
}

import UIKit

class EditVM: NSObject {
    
    var observer: EditVMObserver?
    var userData:UserData?
    var editImage: PickerData?
    var imagePicker = GetImageFromPicker()
    var edit_cover_Image: PickerData?
    var arrGender:[SignUpCatItem] = []
    var arrEthnicity:[SignUpCatItem] = []
    
    init(observer: EditVMObserver?) {
        self.observer = observer
    }
    
    func apiEditProfile(name:String,username:String,pswrd:String,place:String,birthDate:String,gender:String,ethnicity:String,
                        lat :String, long:String,bio:String){
        var params = JSON()
        params["name"] = name
        params["user_name"] = username
        params["dob"] = birthDate
//        params["password"] = pswrd
        params["gender"] = gender
        params["place"] = place
        params["ethnicity"] = ethnicity
        params["lat"] = lat
        params["long"] = long
//        params["image"] = img
        params["bio"] = bio
        print("params :", params)
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.updateProfile(apiName: API.Name.editProfile, params: params, profilePhoto: editImage) { succeeded, response, data in
    ActivityIndicator.shared.hideActivityIndicator()
            DispatchQueue.main.async {
                print("api responce in Home screen : \(response)")
                if succeeded == true {
                    self.showMessage(message: "Your profile has been updated successfully.", isError: .success)
                    if let userData = DataDecoder.decodeData(data, type: UserModel.self) {
                        UserDefaultsCustom.saveUserData(userData: userData.data!)
                        
                        if let editImage = self.editImage?.image,
                            let url = userData.data?.image {
                            editImage.setCacheAt(url: url)
                        }
                    }
                    NotificationCenter.default.post(name: .init("updateUserImage"), object: nil)
                    self.observer?.observeGetEditProfileSucessfull()
                } else {
                    self.showMessage(message: response["message"] as? String ?? "" , isError: .error)
                }
            }
  
        }
        
        
    }
    
    
    //MARK: - Get Categories -
    
    func apiGetCategoriesList(type:Int) {
        
        arrGender = []
        arrEthnicity = []
        
        var params = JSON()
        params["type"] = type
        print("params : ", params)
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.getCategories, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(SignUpCatModel.self, from: data)
                        self.arrGender.append(contentsOf: decoded.gender)
                        self.arrEthnicity.append(contentsOf: decoded.ethnicity)
                        self.observer?.observeGetCategoriesListSucessfull()
                    } catch {
                        print("error", error)
                    }
                }
            }
        }
    }
    
}
