//
//  EditVM.swift
//  Trongu
//
//  Created by dr mac on 20/07/23.
//

protocol EditVMObserver: NSObjectProtocol {
    func observeGetEditProfileSucessfull()
    
}


import UIKit

class EditVM: NSObject {
    
    var observer: EditVMObserver?
    var userData:UserData?
    var editImage: PickerData?
    var imagePicker = GetImageFromPicker()
    var edit_cover_Image: PickerData?
    init(observer: EditVMObserver?) {
        self.observer = observer
    }
    
//    func validatePersnalDetails(name: String,userNamme:String,dob: String,gender: String, paswrd: String,place:String,ethnicity:String,bio:String) -> Bool {
//        let isvalidname = Validator.validateName(name: name)
//        let isvalidusername = Validator.validateName(name: userNamme)
//
//        let isvalidLearnReason = Validator.validateLearnReson(learnReason: learnReason)
//        let isvalidLearningGoal = Validator.validateDailyLearningGoal(lerningGoal: lerningGoal)
//        let isvalidEnglishLevel = Validator.validateEnglishLevel(englishLevel: englishLevel)
//
//        guard isvalidname.0 == true else {
//            Singleton.showMessage(message: "\(isvalidname.1)", isError: .error)
//            print("isvalidname  \(isvalidname)")
//            return false
//        }
//        guard isvalidLearnReason.0 == true else {
//            Singleton.showMessage(message: "\(isvalidLearnReason.1)", isError: .error)
//            print("isvalidAge  \(isvalidLearnReason)")
//            return false
//        }
//        guard isvalidLearningGoal.0 == true else {
//            Singleton.showMessage(message: "\(isvalidLearningGoal.1)", isError: .error)
//            print("isvalidGender  \(isvalidLearningGoal)")
//            return false
//        }
//        guard isvalidEnglishLevel.0 == true else {
//            Singleton.showMessage(message: "\(isvalidEnglishLevel.1)", isError: .error)
//            print("isValidBio  \(isvalidEnglishLevel)")
//            return false
//        }
//        return true
//    }
    
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
}
