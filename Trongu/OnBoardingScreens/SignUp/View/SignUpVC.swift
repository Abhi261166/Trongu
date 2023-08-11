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
    var viewModel: SignUpVM?
    var selectGender = String()
    var selectEthnicity = String()
    var latitude :String?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var longitude:String?
    var genderPicker = ["Male","Female"]
    var ethnicityPicker = ["White","Black","Asian"]
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
    func validateSignUpDetails() -> Bool {
        let isvalidUsername = Validator.validateUserName(name: userNameTF.text ?? "")
        let isvalidname = Validator.validateName(name: nameTF.text ?? "")
        
        let isvalidEmail = Validator.validateEmail(candidate: emailAddressTF.text ?? "")
        let isValidPassword = Validator.validateOldPassword(password: passwordTF.text ?? "")
        let isValidConPassword = Validator.validateConfirmPassword(password: passwordTF.text ?? "", confirmPass: confirmPasswordTF.text ?? "")
        let isvalidPlace = Validator.validatePlace(place: addPlaceTF.text ?? "")
        let isvalidDob = Validator.validDOB(dob: dateOFbirthTF.text ?? "")

        let isvaligender =  Validator.validategender(gender: genderTF.text ?? "")
        let isvalidEthnicity = Validator.validethnicity(ethnicity: ethnicityTF.text ?? "")
        
        guard isvalidUsername.0 == true else {
            Singleton.showMessage(message: "\(isvalidUsername.1)", isError: .error)
            print("isvalidUsername  \(isvalidUsername)")
            return false
        }
        guard isvalidname.0 == true else {
            Singleton.showMessage(message: "\(isvalidname.1)", isError: .error)
            print("isvalidUsername  \(isvalidname)")
            return false
        }
        
        
        guard isvalidEmail.0 == true else {
            Singleton.showMessage(message: "\(isvalidEmail.1)", isError: .error)
            print("isvalidEmail  \(isvalidEmail)")
            return false
        }
        guard isValidPassword.0 == true else {
            Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
            print("isValidPassword  \(isValidPassword)")
            return false
        }
        guard isValidConPassword.0 == true else {
            Singleton.showMessage(message: "\(isValidConPassword.1)", isError: .error)
            print("isValidConPassword  \(isValidPassword)")
            return false
        }
        guard isvalidPlace.0 == true else {
            Singleton.showMessage(message: "\(isvalidPlace.1)", isError: .error)
            print("isvalidPlace  \(isvalidPlace)")
            return false
        }
        
        guard isvalidDob.0 == true else {
            Singleton.showMessage(message: "\(isvalidDob.1)", isError: .error)
            print("isvalidDob  \(isvalidDob)")
            return false
        }
        
        guard isvaligender.0 == true else {
            Singleton.showMessage(message: "\(isvaligender.1)", isError: .error)
            print("isValidPassword  \(isvaligender)")
            return false
        }
        guard isvalidEthnicity.0 == true else {
            Singleton.showMessage(message: "\(isvalidEthnicity.1)", isError: .error)
            print("isValidPassword  \(isvalidEthnicity)")
            return false
        }
        
        guard termAndConditionBtn.isSelected == true else {
            Singleton.showMessage(message: "Please accept terms and conditions", isError: .error)
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
            if selectEthnicity == ""{
                self.selectEthnicity = "1"
            }else{
                self.selectEthnicity
            }
            print(self.selectGender,self.selectEthnicity,"FSDdsf")
            viewModel?.apiSignup(name:self.nameTF.text ?? "", email:self.emailAddressTF.text ?? "", pswrd:self.passwordTF.text ?? "", place:self.addPlaceTF.text ?? "", birthDate:self.dateOFbirthTF.text ?? "", gender:self.selectGender ?? "0", ethnicity:self.selectEthnicity ?? "1", lat:latitude ?? "", long:longitude ?? "",username:userNameTF.text ?? "")
            
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
            Singleton.showMessage(message: "\(isvalidname.1)", isError: .error)
            print("isvalidUsername  \(isvalidname)")
            return false
        }
        
        guard isvalidUsername.0 == true else {
            Singleton.showMessage(message: "\(isvalidUsername.1)", isError: .error)
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
            Singleton.showMessage(message: "\(isvalidPlace.1)", isError: .error)
            print("isvalidPlace  \(isvalidPlace)")
            return false
        }
        
        guard isvalidDob.0 == true else {
            Singleton.showMessage(message: "\(isvalidDob.1)", isError: .error)
            print("isvalidDob  \(isvalidDob)")
            return false
        }
        
        guard isvaligender.0 == true else {
            Singleton.showMessage(message: "\(isvaligender.1)", isError: .error)
            print("isValidPassword  \(isvaligender)")
            return false
        }
        guard isvalidEthnicity.0 == true else {
            Singleton.showMessage(message: "\(isvalidEthnicity.1)", isError: .error)
            print("isValidPassword  \(isvalidEthnicity)")
            return false
        }
        
        guard termAndConditionBtn.isSelected == true else {
            Singleton.showMessage(message: "Please accept terms and conditions", isError: .error)
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
            if selectEthnicity == ""{
                self.selectEthnicity = "1"
            }else{
                self.selectEthnicity
            }
            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId)
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
            if selectEthnicity == ""{
                self.selectEthnicity = "1"
            }else{
                self.selectEthnicity
            }
            //            viewModel?.fbSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",fbId: fbId)
            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId)
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
            if selectEthnicity == ""{
                self.selectEthnicity = "1"
            }else{
                self.selectEthnicity
            }
            //            viewModel?.appleSignUp(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",appleId: appleID)
            
            viewModel?.googleSignup(name: self.nameTF.text ?? "", email: self.emailAddressTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOFbirthTF.text ?? "", gender: self.selectGender ?? "0", ethnicity: self.selectEthnicity ?? "1", lat: latitude ?? "", long: longitude ?? "",username:userNameTF.text ?? "",googleId: googleId)
            
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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Camera", style: .default){ [self] action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera;
                imagePickerController.allowsEditing = true
                self.imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Camera not found", message: "This device has no camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
                present(alert, animated: true,completion: nil)
            }
        }
        let action1 = UIAlertAction(title: "Gallery", style: .default){ action in
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.delegate = self
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
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
                if selectEthnicity == ""{
                    self.selectEthnicity = "1"
                }else{
                    self.selectEthnicity
                }
                viewModel?.googleSignup(name:self.nameTF.text ?? "", email:self.emailAddressTF.text ?? "", pswrd:self.passwordTF.text ?? "", place:self.addPlaceTF.text ?? "", birthDate:self.dateOFbirthTF.text ?? "", gender:self.selectGender ?? "0", ethnicity:self.selectEthnicity ?? "1", lat:latitude ?? "", long:longitude ?? "",username:userNameTF.text ?? "",googleId:googleId)
            }
           
        
        }else{
            
             let status =  validateSignUpDetails()
            
            if status{
                
                if selectGender == "" {
                    self.selectGender = "0"
                }else{
                    self.selectGender
                }
                if selectEthnicity == ""{
                    self.selectEthnicity = "1"
                }else{
                    self.selectEthnicity
                }
                print(self.selectGender,self.selectEthnicity,"FSDdsf")
                viewModel?.apiSignup(name:self.nameTF.text ?? "", email:self.emailAddressTF.text ?? "", pswrd:self.passwordTF.text ?? "", place:self.addPlaceTF.text ?? "", birthDate:self.dateOFbirthTF.text ?? "", gender:self.selectGender ?? "0", ethnicity:self.selectEthnicity ?? "1", lat:latitude ?? "", long:longitude ?? "",username:userNameTF.text ?? "")
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
                //                self.cityy = placemark.locality
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
            return genderPicker.count
        }else if ethnicityTF.isFirstResponder {
            return ethnicityPicker.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if genderTF.isFirstResponder {
            return genderPicker[row]
        }else if ethnicityTF.isFirstResponder{
            return ethnicityPicker[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if genderTF.isFirstResponder {
            genderTF.text = genderPicker[row]
            self.selectGender = String(row)
            print(self.selectGender,"Etfdfdhhh")
        }else if ethnicityTF.isFirstResponder {
            ethnicityTF.text = ethnicityPicker[row]
            self.selectEthnicity = String(row + 1)
            print(self.selectEthnicity,"Ethhh")
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
                genderTF.text = genderPicker[index]
                //                self.selectGender = String(genderPicker[index])
            })
            
        }else if textField == ethnicityTF {
            ethnicityTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = ethnicityPicker.firstIndex(where: {$0 == ethnicityTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                ethnicityTF.text = ethnicityPicker[index]
                //                self.selectEthnicity = String(ethnicityPicker[index + 1])
            })
        }
        //        else if textField == addPlaceTF{
        //            self.addPlaceTF.resignFirstResponder()
        //            let autocompleteController = GMSAutocompleteViewController()
        //            autocompleteController.delegate = self
        //            autocompleteController.placeFields = .coordinate
        //            present(autocompleteController, animated: true, completion: nil)
        //        }
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
        } else if textField == nameTF || textField == userNameTF || textField == addPlaceTF {
            if  string == " " {
                  
                    return false
                }else{
                  return true
                }
        }else {
            
            
            
            
            return true
        }
    }
//    emailAddressTF.delegate = self
//    nameTF.delegate = self
//    userNameTF.delegate = self
//    addPlaceTF.delegate = self
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
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
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
//extension SignUpVC: GMSAutocompleteViewControllerDelegate {
//        
//        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//            //        print("Place name: \(place.name)")
//            //         print("Place ID: \(place.placeID)")
//            //         print("Place attributions: \(place.attributions)")
//            self.latitude = "\(place.coordinate.latitude.rounded(toPlaces: 4))"
//            self.longitude = "\(place.coordinate.longitude.rounded(toPlaces: 4))"
//            print(self.latitude)
//            print(self.longitude)
//            
//            let geoCoder = CLGeocoder()
//            let location = CLLocation(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
//            
//            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
//                placemarks?.forEach { (placemark) in
//                    
//                    if let city = placemark.locality {
//                        print(city)
//                        self.addPlaceTF.text = city
//                    }
//                    else{
//                        if let thoroughfare = placemark.thoroughfare {
//    //                        self.searchTF.text = thoroughfare
//                        }
//                    }
//                }
//            })
//            dismiss(animated: true, completion: nil)
//        }
//        
//        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//            // TODO: handle the error.
//            print("Error: ", error.localizedDescription)
//        }
//        
//    //    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
//    //        self.searchTF.text = prediction.attributedFullText.string
//    //        return true
//    //    }
//        // User canceled the operation.
//        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//            dismiss(animated: true, completion: nil)
//        }
//        
//        // Turn the network activity indicator on and off again.
//        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//        
//        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//    }
extension String {
    
    var isValidName: Bool {
        let RegEx = "^\\w{7,18}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
   
}