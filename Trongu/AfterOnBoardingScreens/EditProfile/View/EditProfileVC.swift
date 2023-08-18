//
//  EditProfileVC.swift
//  Trongu
//
//  Created by apple on 03/07/23.
//

import UIKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordHideButton: UIButton!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordHideButton: UIButton!
    @IBOutlet weak var addPlaceTF: UITextField!
    @IBOutlet weak var ethnicityTF: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    var genderPicker = ["Male","Female"]
    var ethnicityPicker = ["White","Black","Asian"]
    let pickerView = UIPickerView()
    var imagePickerController = UIImagePickerController()
    var selectGender = String()
    var selectEthnicity = String()
    var viewModel: EditVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        setData()
        setPicker()
        setViewModel()
    }
    func setViewModel() {
        self.viewModel = EditVM(observer: self)
    }
    func setPicker(){
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        ethnicityTF.delegate = self
        userNameTF.delegate = self
        nameTF.delegate = self
        genderTF.delegate = self
        dateOfBirthTF.delegate = self
        genderTF.delegate = self
        addPlaceTF.delegate = self
        
    }
    func setData(){
        userProfileImage.setImage(image: UserDefaultsCustom.getUserData()?.image ?? "",placeholder: UIImage(named: "ic_profilePlaceHolder"))
        self.userNameTF.text = UserDefaultsCustom.getUserData()?.user_name ?? ""
        self.nameTF.text = UserDefaultsCustom.getUserData()?.name ?? ""
        print(UserDefaultsCustom.getUserData()?.user_name ?? "","Nmm")
        print(userNameTF.text,nameTF.text,"Names")
        dateOfBirthTF.text = UserDefaultsCustom.getUserData()?.dob ?? ""
        if UserDefaultsCustom.getUserData()?.gender == "0" {
            genderTF.text = "Male"
        }else{
            genderTF.text = "Female"
        }
        passwordTF.text = AppDefaults.password
        confirmPasswordTF.text = AppDefaults.password
        addPlaceTF.text = UserDefaultsCustom.getUserData()?.place
        if UserDefaultsCustom.getUserData()?.ethnicity == "1"{
            ethnicityTF.text = "White"
        }else if UserDefaultsCustom.getUserData()?.ethnicity == "2"{
            ethnicityTF.text = "Black"
        }else{
            ethnicityTF.text = "Asian"
        }
        self.selectGender = UserDefaultsCustom.getUserData()?.gender ?? ""
        self.selectEthnicity = UserDefaultsCustom.getUserData()?.ethnicity ?? ""
        bioTextView.text = UserDefaultsCustom.getUserData()?.bio
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        userProfileImage.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      //|| textField == nameTF  || textField == addPlaceTF
       if textField == userNameTF{
            if string == " " {
                return false
            }else{}
            
        }else {
            
        }
        return true
    }
    
    func validation() {
        if (userNameTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }else if (userNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Please enter username", view: self)
        }
        else if nameTF.text == ""{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }else if (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankName, view: self)
        }
        else if (dateOfBirthTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankDateofbirth, view: self)
        }else if (genderTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankGender, view: self)
        }
//        else if passwordTF.text == ""{
//            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPassword, view: self)
//        }else if passwordTF?.isValidPassword() == false {
//            Trongu.showAlert(title: Constants.AppName, message: Constants.minimumRangeSet, view: self)
//        }else if confirmPasswordTF.text == ""{
//            Trongu.showAlert(title: Constants.AppName, message: Constants.blankConfirmPassword, view: self)
//        }else if  (passwordTF.text != confirmPasswordTF.text){
//            Trongu.showAlert(title: Constants.AppName, message: "New password and confirm password not match.", view: self)
//        }
        else if (addPlaceTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
        }else if (ethnicityTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if (bioTextView.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: "Enter bio details", view: self)
        }
        else{
            viewModel?.apiEditProfile(name: self.nameTF.text ?? "", username: self.userNameTF.text ?? "", pswrd: self.passwordTF.text ?? "", place: self.addPlaceTF.text ?? "", birthDate: self.dateOfBirthTF.text ?? "", gender: self.selectGender ?? "", ethnicity: selectEthnicity, lat: UserDefaultsCustom.getUserData()?.lat ?? "", long: UserDefaultsCustom.getUserData()?.long ?? "",bio: self.bioTextView.text)
//            let vc = TabBarController()
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordHideAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.isSelected.toggle()
            passwordTF.isSecureTextEntry = !sender.isSelected
        }else{
            sender.isSelected.toggle()
            confirmPasswordTF.isSecureTextEntry = !sender.isSelected
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        self.openGalaryPhoto(tag: 1)
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
                            self?.userProfileImage.image = data1.image
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
    
}
extension EditProfileVC :UIPickerViewDelegate, UIPickerViewDataSource{
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

extension EditProfileVC : UITextFieldDelegate {
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
        }else{}
    }
}
extension EditProfileVC : EditVMObserver{
    func observeGetEditProfileSucessfull() {
        self.popViewController(true)
    }
    
}
