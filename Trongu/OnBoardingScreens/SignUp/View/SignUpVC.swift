//
//  SignUpVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
import CoreLocation
//import GooglePlaces
import SafariServices


class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var confirmEyeBtn: UIButton!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordHideBtn: UIButton!
    @IBOutlet weak var confirmPasswordHideBtn: UIButton!
    @IBOutlet weak var addPlaceTF: UITextField!
    @IBOutlet weak var dateOFbirthTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var ethnicityTF: UITextField!
    @IBOutlet weak var termAndConditionBtn: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    
    
    var viewModel: SignUpVM?
    var selectGender = String()
    var selectEthnicity = String()
    var latitude :String?
    var longitude:String?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var genderPicker = ["Male","Female"]
    var ethnicityPicker = ["American","Australian"]
    var imagePickerController = UIImagePickerController()
    let pickerView = UIPickerView()
    var name = String()
    var email = String()
    var comeFrom = Bool()
    var googleId = String()
    var fbId = String()
    var appleID = String()
    var iconClick = true
    var iconClick2 = true
    override func viewDidLoad() {
        super.viewDidLoad()
        dateOFbirthTF.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        setPicker()
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        setViewModel()
        setData()
        //        txtData()
        if googleId != ""{
            passwordTF.isUserInteractionEnabled = false
            confirmPasswordTF.isUserInteractionEnabled = false
        }else if appleID != ""{
            passwordTF.isUserInteractionEnabled = false
            confirmPasswordTF.isUserInteractionEnabled = false
            nameTF.isUserInteractionEnabled = false
            emailAddressTF.isUserInteractionEnabled = false
        }else if fbId != ""{
            passwordTF.isUserInteractionEnabled = false
            confirmPasswordTF.isUserInteractionEnabled = false
        } else{
            passwordTF.isUserInteractionEnabled = true
            confirmPasswordTF.isUserInteractionEnabled = true
        }
    }
    
   
    
    
    func setData(){
        if comeFrom == true{
            self.nameTF.text = name
            self.emailAddressTF.text = email
            self.viewPassword.isHidden = true
            self.confirmPasswordView.isHidden = true
            self.emailAddressTF.isUserInteractionEnabled = false
        }else{
            self.viewPassword.isHidden = false
            self.confirmPasswordView.isHidden = false
        }
    }
    
    func txtData(){
        nameTF.text = "Okk"
        emailAddressTF.text = "test08@yopmail.com"
        passwordTF.text = "12345678"
        confirmPasswordTF.text = "12345678"
        addPlaceTF.text = "Mohali"
    }
    
    func setViewModel() {
        self.viewModel = SignUpVM(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
        self.viewModel?.apiGetCategoriesList(type: 2)
    }
    
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.dateOFbirthTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            self.dateOFbirthTF.text = dateFormatter.string(from: datePicker.date)
            print(dateOFbirthTF.text!)
        }
        self.dateOFbirthTF.resignFirstResponder()
    }
    
    func getCurrentLocation(){
        if #available(iOS 14.0, *) {
            
            if locationManager.authorizationStatus == (CLAuthorizationStatus.authorizedWhenInUse) ||
                locationManager.authorizationStatus ==  (CLAuthorizationStatus.authorizedAlways)  {
                currentLocation = locationManager.location
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == (CLAuthorizationStatus.authorizedWhenInUse) ||
                locationManager.authorizationStatus ==  (CLAuthorizationStatus.authorizedAlways)  {
                currentLocation = locationManager.location
            }
        } else {
            // Fallback on earlier versions
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
        
        
    }
    
    func setPicker(){
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        ethnicityTF.delegate = self
        genderTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        emailAddressTF.delegate = self
        nameTF.delegate = self
        userNameTF.delegate = self
        addPlaceTF.delegate = self
        
    }
    
    func openGalaryPhoto(tag: Int) {
        self.viewModel?.imagePicker.setImagePicker(imagePickerType: .both, tag: tag, controller: self)
        self.viewModel?.imagePicker.imageCallBack = {[weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data1 = data {
                        if tag == 1 {
                            self?.viewModel?.editImage = data
                            self?.profileImage.image = data1.image
                        } else {
                            self?.viewModel?.edit_cover_Image = data1
                           // self?.coverPhotoButton.setImage(data1.image, for: .normal)
                        }
                    }
                case .error(let message):
                    Singleton.shared.showErrorMessage(error: message, isError: .error)
                }
            }
        }
    }
    
    func validateSignUpDetails() -> Bool {
        let isvalidUsername = Validator.validateUserName(name: userNameTF.text ?? "")
        let isvalidname = Validator.validateName(name: nameTF.text ?? "")
        
        let isvalidEmail = Validator.validateEmail(candidate: emailAddressTF.text ?? "")
        let isValidPassword = Validator.validateOldPassword(password: passwordTF.text ?? "")
        let isValidConPassword = Validator.validateConfirmPassword(password: passwordTF.text ?? "", confirmPass: confirmPasswordTF.text ?? "" ,val: "confirm")
        let isvalidPlace = Validator.validatePlace(place: addPlaceTF.text ?? "")
        let isvalidDob = Validator.validDOB(dob: dateOFbirthTF.text ?? "")

        let isvaligender =  Validator.validategender(gender: genderTF.text ?? "")
        let isvalidEthnicity = Validator.validethnicity(ethnicity: ethnicityTF.text ?? "")
        
        guard isvalidUsername.0 == true else {
            
           // Singleton.showMessage(message: "\(isvalidUsername.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidUsername.1)", controller: self, Title: self.viewModel?.title ?? "")
            
            print("isvalidUsername  \(isvalidUsername)")
            return false
            
        }
        guard isvalidname.0 == true else {
        //    Singleton.showMessage(message: "\(isvalidname.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidname.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isvalidUsername  \(isvalidname)")
            return false
        }
        
        
        guard isvalidEmail.0 == true else {
           // Singleton.showMessage(message: "\(isvalidEmail.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidEmail.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isvalidEmail  \(isvalidEmail)")
            return false
        }
        guard isValidPassword.0 == true else {
          //  Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isValidPassword.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isValidPassword  \(isValidPassword)")
            return false
        }
        guard isValidConPassword.0 == true else {
           // Singleton.showMessage(message: "\(isValidConPassword.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isValidConPassword.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isValidConPassword  \(isValidPassword)")
            return false
        }
        guard isvalidPlace.0 == true else {
          //  Singleton.showMessage(message: "\(isvalidPlace.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidPlace.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isvalidPlace  \(isvalidPlace)")
            return false
        }
        
        guard isvalidDob.0 == true else {
          //  Singleton.showMessage(message: "\(isvalidDob.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidDob.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isvalidDob  \(isvalidDob)")
            return false
        }
        
        guard isvaligender.0 == true else {
          //  Singleton.showMessage(message: "\(isvaligender.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvaligender.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isValidPassword  \(isvaligender)")
            return false
        }
        guard isvalidEthnicity.0 == true else {
         //   Singleton.showMessage(message: "\(isvalidEthnicity.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidEthnicity.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isValidPassword  \(isvalidEthnicity)")
            return false
        }
        
        guard termAndConditionBtn.isSelected == true else {
          //  Singleton.showMessage(message: "Please accept terms and conditions", isError: .error)
            Singleton.shared.showAlert(message: "Please accept terms and conditions", controller: self, Title: self.viewModel?.title ?? "")
            return false
        }
        return true
    }
    func validation() {
        let isvalidUsername = Validator.validateName(name: userNameTF.text ?? "")
        if (userNameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }else if (userNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }
        else if (nameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }else if  (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }
        //        else if emailAddressTF.text == ""{
        //            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEmail, view: self)
        //        }else if emailAddressTF.text?.isValidEmail == false {
        //            Trongu.showAlert(title: Constants.AppName, message: Constants.validEmail, view: self)
        //        }
        else if (passwordTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPassword, view: self)
        }else if passwordTF?.isValidPassword() == false {
            Trongu.showAlert(title: Constants.AppName, message: Constants.minimumRangeSet, view: self)
        }else if (confirmPasswordTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankConfirmPassword, view: self)
        }else if (confirmPasswordTF?.text != passwordTF.text) {
            Trongu.showAlert(title: Constants.AppName, message: "Password and Confirm password does not match", view: self)
        }else if (addPlaceTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
        }else if (dateOFbirthTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankDateofbirth, view: self)
        }else if (genderTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankGender, view: self)
        }else if (ethnicityTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if termAndConditionBtn.isSelected == false{
            Trongu.showAlert(title:Constants.AppName, message: "Please agree with Terms & Conditions.", view: self)
        }
        //            else if googleId != ""{
        //            if selectGender == "" {
        //                self.selectGender = "0"
        //            }else{
        //                self.selectGender
        //            }
        //            if selectEthnicity == ""{
        //                self.selectEthnicity = "1"
        //            }else{
        //                self.selectEthnicity
        //            }
        //            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId)
        //        }
        else{
            if selectGender == "" {
                self.selectGender = "0"
            }else{
                self.selectGender
            }
            
            var ethnicity = "1"
            switch ethnicityTF.text {
            case "American":
                ethnicity = "1"
            case "Australian":
                ethnicity = "2"
            default:
                break
            }
            
            print(self.selectGender,self.selectEthnicity,"FSDdsf")
            viewModel?.apiSignup(name:self.nameTF.text ?? "", email:self.emailAddressTF.text ?? "", pswrd:self.passwordTF.text ?? "", place:self.addPlaceTF.text ?? "", birthDate:self.dateOFbirthTF.text ?? "", gender:self.selectGender ?? "0", ethnicity: ethnicity ?? "1", lat:latitude ?? "", long:longitude ?? "",username:userNameTF.text ?? "", bio: self.bioTextView.text.trim)
            
        }
        
    }
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if textField == passwordTF || textField ==  confirmPasswordTF {
    //            if string == " " {
    //                return false
    //            }
    //            return true
    //        }
    //    }
    
    func validateSignUpDetailSocial() -> Bool {
        let isvalidUsername = Validator.validateUserName(name: userNameTF.text ?? "")

        let isvalidname = Validator.validateName(name: nameTF.text ?? "")
//        let isvalidEmail = Validator.validateEmail(candidate: emailAddressTF.text ?? "")
//        let isValidPassword = Validator.validateOldPassword(password: passwordTF.text ?? "")
//        let isValidConPassword = Validator.validateOldPassword(password: confirmPasswordTF.text ?? "")
        let isvalidPlace = Validator.validatePlace(place: addPlaceTF.text ?? "")
        let isvalidDob = Validator.validDOB(dob: dateOFbirthTF.text ?? "")
        let isvaligender =  Validator.validategender(gender: genderTF.text ?? "")
  
        let isvalidEthnicity = Validator.validethnicity(ethnicity: ethnicityTF.text ?? "")
        guard isvalidname.0 == true else {
           // Singleton.showMessage(message: "\(isvalidname.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidname.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isvalidUsername  \(isvalidname)")
            return false
        }
        
        guard isvalidUsername.0 == true else {
          //  Singleton.showMessage(message: "\(isvalidUsername.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidUsername.1)", controller: self, Title: self.viewModel?.title ?? "")
            
            print("isvalidUsername  \(isvalidUsername)")
            return false
        }
//        guard isvalidEmail.0 == true else {
//            Singleton.showMessage(message: "Email already taken ", isError: .error)
//            print("isvalidEmail  \(isvalidEmail)")
//            return false
//        }
//        guard isValidPassword.0 == true else {
//            Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
//            print("isValidPassword  \(isValidPassword)")
//            return false
//        }
//        guard isValidConPassword.0 == true else {
//            Singleton.showMessage(message: "\(isValidConPassword.1)", isError: .error)
//            print("isValidConPassword  \(isValidPassword)")
//            return false
//        }
        guard isvalidPlace.0 == true else {
           // Singleton.showMessage(message: "\(isvalidPlace.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidPlace.1)", controller: self, Title: self.viewModel?.title ?? "")
            
            print("isvalidPlace  \(isvalidPlace)")
            return false
        }
        
        guard isvalidDob.0 == true else {
           // Singleton.showMessage(message: "\(isvalidDob.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidDob.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isvalidDob  \(isvalidDob)")
            return false
        }
        
        guard isvaligender.0 == true else {
           // Singleton.showMessage(message: "\(isvaligender.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvaligender.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isValidPassword  \(isvaligender)")
            return false
        }
        guard isvalidEthnicity.0 == true else {
           // Singleton.showMessage(message: "\(isvalidEthnicity.1)", isError: .error)
            Singleton.shared.showAlert(message: "\(isvalidEthnicity.1)", controller: self, Title: self.viewModel?.title ?? "")
            print("isValidPassword  \(isvalidEthnicity)")
            return false
        }
        
        guard termAndConditionBtn.isSelected == true else {
           // Singleton.showMessage(message: "Please accept terms and conditions", isError: .error)
            Singleton.shared.showAlert(message: "Please accept terms and conditions", controller: self, Title: self.viewModel?.title ?? "")
            return false
        }
        return true
    }
    
    
    func validation2() {
        if (userNameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }else if (userNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }
        else if (nameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }else if  (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }
        else if (emailAddressTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEmail, view: self)
        }else if emailAddressTF.text?.isValidEmail == false {
            Trongu.showAlert(title: Constants.AppName, message: Constants.validEmail, view: self)
        }else if (addPlaceTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
        }else if (dateOFbirthTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankDateofbirth, view: self)
        }else if (genderTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankGender, view: self)
        }else if (ethnicityTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if termAndConditionBtn.isSelected == false{
            Trongu.showAlert(title:Constants.AppName, message: "Please agree with Terms & Conditions.", view: self)
        }else if googleId != ""{
            if selectGender == "" {
                self.selectGender = "0"
            }else{
                self.selectGender
            }
            
            var ethnicity = "1"
            switch ethnicityTF.text {
            case "American":
                ethnicity = "1"
            case "Australian":
                ethnicity = "2"
            default:
                break
            }
            
            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender, ethnicity: ethnicity, lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId, bio: bioTextView.text.trim)
        }
        //        else{
        //            if selectGender == "" {
        //                self.selectGender = "0"
        //            }else{
        //                self.selectGender
        //            }
        //            if selectEthnicity == ""{
        //                self.selectEthnicity = "1"
        //            }else{
        //                self.selectEthnicity
        //            }
        //            print(self.selectGender,self.selectEthnicity,"FSDdsf")
        //            viewModel?.apiSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "")
        //
        //        }
        
    }
    func validation3() {
        if (userNameTF.text?.isEmpty)! {
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }else if (userNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }
        else if (nameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }else if  (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }
        else if (emailAddressTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEmail, view: self)
        }else if emailAddressTF.text?.isValidEmail == false {
            Trongu.showAlert(title: Constants.AppName, message: Constants.validEmail, view: self)
        }else if (addPlaceTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
        }else if (dateOFbirthTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankDateofbirth, view: self)
        }else if (genderTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankGender, view: self)
        }else if (ethnicityTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if termAndConditionBtn.isSelected == false{
            Trongu.showAlert(title:Constants.AppName, message: "Please agree with Terms & Conditions.", view: self)
        }else if fbId != ""{
            if selectGender == "" {
                self.selectGender = "0"
            }else{
                self.selectGender
            }
            var ethnicity = "1"
            switch ethnicityTF.text {
            case "American":
                ethnicity = "1"
            case "Australian":
                ethnicity = "2"
            default:
                break
            }
            //            viewModel?.fbSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",fbId: fbId)
            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: ethnicity , lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId, bio: bioTextView.text.trim)
        }
        //        else{
        //            if selectGender == "" {
        //                self.selectGender = "0"
        //            }else{
        //                self.selectGender
        //            }
        //            if selectEthnicity == ""{
        //                self.selectEthnicity = "1"
        //            }else{
        //                self.selectEthnicity
        //            }
        //            print(self.selectGender,self.selectEthnicity,"FSDdsf")
        //            viewModel?.apiSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "")
        //
        //        }
        
    }
    func validation4() {
        if (userNameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }else if (userNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }
        //                    else if nameTF.text == ""{
        //                        Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        //                    }else if  (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
        //                        Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        //                    }
        //        else if emailAddressTF.text == ""{
        //            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEmail, view: self)
        //        }else if emailAddressTF.text?.isValidEmail == false {
        //            Trongu.showAlert(title: Constants.AppName, message: Constants.validEmail, view: self)
        //        }
        else if (addPlaceTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
        }else if (dateOFbirthTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankDateofbirth, view: self)
        }else if (genderTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankGender, view: self)
        }else if (ethnicityTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if termAndConditionBtn.isSelected == false{
            Trongu.showAlert(title:Constants.AppName, message: "Please agree with Terms & Conditions.", view: self)
        }else if appleID != ""{
            if selectGender == "" {
                self.selectGender = "0"
            }else{
                self.selectGender
            }
            var ethnicity = "1"
            switch ethnicityTF.text {
            case "American":
                ethnicity = "1"
            case "Australian":
                ethnicity = "2"
            default:
                break
            }
            //            viewModel?.appleSignUp(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",appleId: appleID)
            
            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: ethnicity, lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId, bio: bioTextView.text.trim)
            
        }
        //        else{
        //            if selectGender == "" {
        //                self.selectGender = "0"
        //            }else{
        //                self.selectGender
        //            }
        //            if selectEthnicity == ""{
        //                self.selectEthnicity = "1"
        //            }else{
        //                self.selectEthnicity
        //            }
        //            print(self.selectGender,self.selectEthnicity,"FSDdsf")
        //            viewModel?.apiSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "")
        //
        //        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhotoAction(_ sender: UIButton) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let action = UIAlertAction(title: "Camera", style: .default){ [self] action in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePickerController.sourceType = .camera;
//                imagePickerController.allowsEditing = true
//                self.imagePickerController.delegate = self
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//            else{
//                let alert = UIAlertController(title: "Camera not found", message: "This device has no camera", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
//                present(alert, animated: true,completion: nil)
//            }
//        }
//        let action1 = UIAlertAction(title: "Gallery", style: .default){ action in
//            self.imagePickerController.allowsEditing = false
//            self.imagePickerController.sourceType = .photoLibrary
//            self.imagePickerController.delegate = self
//            self.present(self.imagePickerController, animated: true, completion: nil)
//        }
//        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(action)
//        alert.addAction(action1)
//        alert.addAction(action2)
//        present(alert, animated: true, completion: nil)
        self.openGalaryPhoto(tag: 1)
    }
    
    @IBAction func passwordHideAction(_ sender: UIButton) {
//        if sender.tag == 0{
//            sender.isSelected.toggle()
//            passwordTF.isSecureTextEntry = !sender.isSelected
//        }else{
//            sender.isSelected.toggle()
//            confirmPasswordTF.isSecureTextEntry = !sender.isSelected
//        }
        
        if(iconClick == true) {
            passwordTF.isSecureTextEntry = false
            eyeBtn.setImage(UIImage(named: "ic_ShowPassword"), for: .normal)
        }
        else {
            passwordTF.isSecureTextEntry = true
            eyeBtn.setImage(UIImage(named: "ic_HidePassword"), for: .normal)
        }
        iconClick = !iconClick
//    }

    }
    
    @IBAction func confirmPasswordAction(_ sender: Any) {
        if(iconClick2 == true) {
            confirmPasswordTF.isSecureTextEntry = false
            confirmEyeBtn.setImage(UIImage(named: "ic_ShowPassword"), for: .normal)
        }
        else {
            confirmPasswordTF.isSecureTextEntry = true
            confirmEyeBtn.setImage(UIImage(named: "ic_HidePassword"), for: .normal)
        }
        iconClick2 = !iconClick2
    }
    
    @IBAction func actionPickAddress(_ sender: UIButton) {
        
        let vc = AddLocationVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func termAndConditionBtnAction(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func termAndConditionAction(_ sender: UIButton) {
//        let vc = TermAndConditionsVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/termsandconditions")
        {
            let safariCC = SFSafariViewController(url: url)
            present(safariCC, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
//        if googleId != "" {
//            validation2()
//        }else if fbId != ""{
//            validation3()
//        }else if appleID != "" {
//            validation4()
//        }
        if comeFrom == true{
            let status =  validateSignUpDetailSocial()
            if status {
                if selectGender == "" {
                    self.selectGender = "0"
                }else{
                    self.selectGender
                }
                var ethnicity = "1"
                switch ethnicityTF.text {
                case "American":
                    ethnicity = "1"
                case "Australian":
                    ethnicity = "2"
                default:
                    break
                }
                viewModel?.googleSignup(name:self.nameTF.text ?? "", email:self.emailAddressTF.text ?? "", pswrd:self.passwordTF.text ?? "", place:self.addPlaceTF.text ?? "", birthDate:self.dateOFbirthTF.text ?? "", gender:self.selectGender ?? "0", ethnicity: ethnicity, lat:latitude ?? "", long:longitude ?? "",username:userNameTF.text ?? "",googleId:googleId, bio: bioTextView.text.trim)
            }
           
        
        }else{
            
             let status =  validateSignUpDetails()
            
            if status{
                
                if selectGender == "" {
                    self.selectGender = "0"
                }else{
                    self.selectGender
                }
                var ethnicity = "1"
                switch ethnicityTF.text {
                case "American":
                    ethnicity = "1"
                case "Australian":
                    ethnicity = "2"
                default:
                    break
                }
                print(self.selectGender,self.selectEthnicity,"FSDdsf")
                viewModel?.apiSignup(name:self.nameTF.text ?? "", email:self.emailAddressTF.text ?? "", pswrd:self.passwordTF.text ?? "", place:self.addPlaceTF.text ?? "", birthDate:self.dateOFbirthTF.text ?? "", gender:self.selectGender ?? "0", ethnicity:ethnicity, lat:latitude ?? "", long:longitude ?? "",username:userNameTF.text ?? "", bio: self.bioTextView.text.trim)
            }
            
              
                
            
//            validation()
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        let vc = LoginVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("**********************")
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.latitude = "\(userLocation.coordinate.latitude)"
        self.longitude = "\(userLocation.coordinate.longitude)"
        //        AppDefaults.latitude = self.latitude
        //        AppDefaults.longitude = self.longitude
        //        print(AppDefaults.latitude!)
        //        print(AppDefaults.longitude!)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
             
                self.addPlaceTF.text = placemark.locality
                
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                //                let data = "\(placemark.timeZone!), \(placemark.administrativeArea!), \(placemark.country!), \(placemark.timeZone!)"
                let data = placemark.timeZone?.identifier ?? ""
                
                //                self.cuntry = data
                print("data :-  ****** \(data) *****   self.cuntry:-  \(TimeZone.current.identifier)")
                self.locationManager.stopUpdatingLocation()
                
            }
        }
        
    }
    
}
extension SignUpVC :UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if genderTF.isFirstResponder {
            return self.viewModel?.arrGender.count ?? 0
        }else if ethnicityTF.isFirstResponder {
            return self.viewModel?.arrEthnicity.count ?? 0
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if genderTF.isFirstResponder {
            return self.viewModel?.arrGender[row].genderName
        }else if ethnicityTF.isFirstResponder{
            return self.viewModel?.arrEthnicity[row].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
                if genderTF.isFirstResponder {
                    genderTF.text = self.viewModel?.arrGender[row].genderName
                    self.selectGender = self.viewModel?.arrGender[row].id ?? ""
                    print("Selected Gender Id ",self.selectGender)
                }else if ethnicityTF.isFirstResponder {
                    ethnicityTF.text = self.viewModel?.arrEthnicity[row].name
                    self.selectEthnicity = self.viewModel?.arrEthnicity[row].id ?? ""
                    print("Selected ethnicity id ",self.selectEthnicity)
                }
        
    }
    
}
extension SignUpVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == genderTF {
            genderTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = genderPicker.firstIndex(where: {$0 == genderTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
              //  genderTF.text = genderPicker[index]
                //                self.selectGender = String(genderPicker[index])
            })
            
        }else if textField == ethnicityTF {
            ethnicityTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = ethnicityPicker.firstIndex(where: {$0 == ethnicityTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
               // ethnicityTF.text = ethnicityPicker[index]
                //                self.selectEthnicity = String(ethnicityPicker[index + 1])
            })
        }
    
        else{}
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateOFbirthTF {
            let allowedCharacters = ""
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else if textField == passwordTF || textField == confirmPasswordTF || textField == emailAddressTF{
            if string == " " {
                return false
            }else{
              return true
            }
        }
        else if textField == userNameTF{
            if  string == " " {

                    return false
                }else{
                  return true
                }
        }
        else {
            return true
        }
    }
    

}
extension UITextField {
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    
    func addInputViewTimePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}

extension SignUpVC:SignUpVMObserver{
    func observeGetCategoriesListSucessfull() {
        
    }
    
    func observeSignUpSucessfull(){
        if googleId != "" {
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if appleID != ""{
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if fbId != ""{
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{

            
            let vc = LoginVc()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension String {
    
    var isValidName: Bool {
        let RegEx = "^\\w{7,18}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
}

extension SignUpVC:AddLocationVCDelegate{
  
    func setLocation(text: String, lat: Double, long: Double, address: String,country: String) {
        DispatchQueue.main.async {
            
            self.latitude = "\(lat)"
            self.longitude = "\(long)"
            self.addPlaceTF.text = address
            
        }
        
    }
}

extension SignUpVC{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case genderTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrGender.firstIndex(where: {$0.genderName == genderTF.text ?? ""}) ?? 0
                 
                    if (self.viewModel?.arrGender.count ?? 0) > 0 {
                        self.genderTF.text = self.viewModel?.arrGender[index].genderName ?? ""
                        self.selectGender = self.viewModel?.arrGender[index].id ?? ""
                        print("   Selected Gender   \(self.viewModel?.arrGender[index].genderName ?? "") id  \(self.viewModel?.arrGender[index].id ?? "")")
                    }
                    
                })
                pickerView.reloadAllComponents()
                
            case ethnicityTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrEthnicity.firstIndex(where: {$0.name == ethnicityTF.text ?? ""}) ?? 0
                  
                    if (self.viewModel?.arrEthnicity.count ?? 0) > 0 {
                        
                        self.ethnicityTF.text = self.viewModel?.arrEthnicity[index].name ?? ""
                        self.selectEthnicity = self.viewModel?.arrEthnicity[index].id ?? ""
                        
                        print("Selected Gender   \(self.viewModel?.arrEthnicity[index].genderName ?? "") id  \(self.viewModel?.arrEthnicity[index].id ?? "")")
                        
                    }
                    
                })
                
                pickerView.reloadAllComponents()
                
            default: break
            }
        }
    
}
