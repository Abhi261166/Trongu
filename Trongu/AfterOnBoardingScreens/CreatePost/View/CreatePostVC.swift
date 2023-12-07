//
//  CreatePostVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import YPImagePicker
import GrowingTextView

class CreatePostVC: UIViewController{
   
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var txtTags: GrowingTextView!
    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtNoOffDays: UITextField!
    @IBOutlet weak var txtTripCategory: UITextField!
    @IBOutlet weak var txtTripComplexity: UITextField!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var lblSelectedItems: UILabel!
    @IBOutlet weak var lblCreatePost: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnTagPeople: UIButton!
    
    
    var finalPostItems = [YPMediaItem]()
    var myPost = [Post]()
    var images : [UIImage] = []
    var tagIds = ""
    let pickerView = UIPickerView()
    var arrDays = ["1 day","2 days","3 days","4 days","5 days","6 days","7 days","8 days","9 days","10 days"]
    var arrTripCat = ["Business Trip","Family Trip","Friends Trip","Solo Trip"]
    var arrTripComplexity = ["Complex","Smooth","Normal"]
    var viewModel:TagListVM?
    var tagPeople = ""
    var comeFrom:String?
    var isFromTabbar = false
    var selectedForTag:[Userdetail] = []
    var comeFromPostBack = false
    // selected id's
    var selectedDaysId = ""
    var selectedTripCatId = ""
    var selectedTripComplexityId = ""
    var comeFromEditPostForTag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiledDelegates()
        setPicker()
        setViewModel()
        txtBudget.delegate = self
        if self.comeFrom == "Edit"{
            btnback.isHidden = false
            lblCreatePost.text = "Edit Post"
            self.addImage.image = UIImage(named: "ic_editPost")
            
            if self.myPost[0].postImagesVideo.count != 0{
                if self.myPost[0].postImagesVideo.count == 1{
                    self.lblSelectedItems.text = "\(self.myPost[0].postImagesVideo.count) item selected"
                }else{
                    self.lblSelectedItems.text = "\(self.myPost[0].postImagesVideo.count) items selected"
                }
                
            }else{
                self.lblSelectedItems.text = ""
            }
            
        }else{
            btnback.isHidden = true
            lblCreatePost.text = "Create Post"
            self.addImage.image = UIImage(named: "CreatePostImage")
            
            let UserData = UserDetail(id: "", googleID: "", facebookID: "", appleID: "", name: "", userName: "", loginType: "", gender: "", email: "", image: "", password: "", place: "", bio: "", dob: "", ethnicity: "", deviceToken: "", deviceType: "", isStatus: "", mailStatus: "", smsStatus: "", status: "", authKey: "", accessToken: "", lat: "", long: "", verificationToken: "", passwordResetToken: "", expireAt: "", createdAt: "", updatedAt: "")
            
          //  let post = Post(id: "", userID: "", budget: "", noOfDays: "", tripCategory: "", description: "", tripComplexity: "", status: "", createdAt: "", tripCategoryName: "", userDetail: UserData)
            
            let post = Post(id: "", userID: "", budget: "", noOfDays: "", trip_complexity_name: "", no_of_days_name: "", tripCategory: "", description: "", tripComplexity: "", status: "", createdAt: "", tripCategoryName: "", userDetail: UserData)
            
            myPost.append(post)
            
        }
        txtViewDesc.delegate = self
        
      //  addDoneButtonToPickerView()
              
    }
          
          func addDoneButtonToPickerView() {
                  let toolbar = UIToolbar()
                  toolbar.sizeToFit()
                  let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
                  toolbar.setItems([doneButton], animated: false)
              
              
              if txtNoOffDays.isFirstResponder {
                  txtNoOffDays.inputAccessoryView = toolbar
              } else if txtTripCategory.isFirstResponder {
                  txtNoOffDays.inputAccessoryView = toolbar
              } else if txtTripComplexity.isFirstResponder {
                  txtNoOffDays.inputAccessoryView = toolbar
              }
              
              
              }

              @objc func doneButtonTapped() {
              
                  let selectedRow = pickerView.selectedRow(inComponent: 0)
          
                  if txtNoOffDays.isFirstResponder {
                      txtNoOffDays.text = self.viewModel?.arrNoOfDays[selectedRow].noOfDays
                      txtNoOffDays.resignFirstResponder()
                  } else if txtTripCategory.isFirstResponder {
                      txtTripCategory.text = self.viewModel?.arrTripCategory[selectedRow].name
                      txtTripCategory.resignFirstResponder()
                      
                  } else if txtTripComplexity.isFirstResponder {
                      txtTripComplexity.text = self.viewModel?.arrTripComplexity[selectedRow].name
                      txtTripCategory.resignFirstResponder()
                  }
                  
              }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
      //  removeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        calculateTime()
        
        self.viewModel?.apiGetCategoriesList(type: 1)
        
        if comeFrom == "Edit"{
            setData()
        }else{
        
        if isFromTabbar{
            setData()
        }else{
            removeData()
        }
    }
        
    }
    
    
    
    func calculateTime(){
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"

        let dates = self.myPost.first?.postImagesVideo.map { $0.date }.compactMap { dateFormatter.date(from: $0) }

        if let minDate = dates?.min(), let maxDate = dates?.max() {
            let minDateString = dateFormatter.string(from: minDate)
            let maxDateString = dateFormatter.string(from: maxDate)

            print("Minimum Date: \(minDateString)")
            print("Maximum Date: \(maxDateString)")
            
               let calendar = Calendar.current
               let components = calendar.dateComponents([.day], from: minDate, to: maxDate)

               if let numberOfDays = components.day {
                   print("Number of Days between Minimum and Maximum Dates: \(numberOfDays) days")
                   txtNoOffDays.text = "\(numberOfDays + 1)"
                   
               } else {
                   print("Error calculating the number of days.")
               }
            
        } else {
            print("No valid dates in the array.")
        }
        
    }
    
    func removeData(){
        finalPostItems = []
        myPost = []
        images = []
        selectedForTag = []
        self.lblSelectedItems.text = ""
        txtTags.text = ""
        txtBudget.text = ""
        txtNoOffDays.text = ""
        txtTripCategory.text = ""
        txtViewDesc.text = ""
        txtTripCategory.text = ""
        let UserData = UserDetail(id: "", googleID: "", facebookID: "", appleID: "", name: "", userName: "", loginType: "", gender: "", email: "", image: "", password: "", place: "", bio: "", dob: "", ethnicity: "", deviceToken: "", deviceType: "", isStatus: "", mailStatus: "", smsStatus: "", status: "", authKey: "", accessToken: "", lat: "", long: "", verificationToken: "", passwordResetToken: "", expireAt: "", createdAt: "", updatedAt: "")
        
        let post = Post(id: "", userID: "", budget: "", noOfDays: "", trip_complexity_name: "", no_of_days_name: "", tripCategory: "", description: "", tripComplexity: "", status: "", createdAt: "", tripCategoryName: "", userDetail: UserData)
        myPost.append(post)
        
    }
    
    func setData(){
        isFromTabbar = false
        
        if comeFrom == "Edit"{
            txtBudget.text = myPost[0].budget
            txtNoOffDays.text = myPost[0].noOfDays
            txtTripCategory.text = myPost[0].tripCategoryName
            txtTripComplexity.text = myPost[0].trip_complexity_name
            txtViewDesc.text = myPost[0].description
            
            selectedDaysId = myPost[0].noOfDays
            selectedTripCatId = myPost[0].tripCategory
            selectedTripComplexityId = myPost[0].tripComplexity
            
            if comeFromPostBack{
                
               
            }else{
                
                if !comeFromEditPostForTag{
                    
                if myPost[0].tagPeople?.count ?? 0 > 0 {
                    for index in 0...((myPost[0].tagPeople?.count ?? 0) - 1){
                        txtTags.text = "\(txtTags.text ?? "") @\(myPost[0].tagPeople?[index].name ?? "")"
                        
                        if self.tagIds == ""{
                            self.tagIds = "\(self.tagIds)\(myPost[0].tagPeople?[index].id ?? "")"
                        }else{
                            self.tagIds = "\(self.tagIds),\(myPost[0].tagPeople?[index].id ?? "")"
                        }
                        
                        let user = Userdetail(id: myPost[0].tagPeople?[index].id ?? "", googleID: "", facebookID: "", appleID: "", name: myPost[0].tagPeople?[index].name ?? "", userName: "", loginType: "", gender: "", email: "", image: "", password: nil, place: nil, bio: nil, dob: nil, ethnicity: "", deviceToken: "", deviceType: "", isStatus: "", mailStatus: "", smsStatus: "", status: "", authKey: "", accessToken: "", lat: "", long: "", verificationToken: "", passwordResetToken: "", expireAt: "", superUser: "", isPrivate: "", createdAt: "", updatedAt: "")
                        
                        selectedForTag.append(user)
                    }
                    
                }else{
                    
                }
                }else{
                    self.comeFromEditPostForTag = false
                }
                self.comeFromPostBack = false
                
            }
        }
        
    }
    
    func setViewModel(){
        
        self.viewModel = TagListVM(observer: self)
    }
    
    func setPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        // self.genderButton.isUserInteractionEnabled = false
        txtNoOffDays.delegate = self
        txtTripCategory.delegate = self
        txtTripComplexity.delegate = self
    }
    
    func textFiledDelegates(){
        txtTags.delegate = self
        txtTripCategory.delegate = self
        txtTripComplexity.delegate = self
        txtNoOffDays.delegate = self
    }
    
    @IBAction func actionTagPeople(_ sender: UIButton) {
        
        let optionItemListVC = MentionVC()
        optionItemListVC.modalPresentationStyle = .overFullScreen
        optionItemListVC.selectedPeople = selectedForTag
        optionItemListVC.completion = { selectedPeoples in
           // self.selectedForTag = selectedPeoples
            self.selectedForTag.append(contentsOf: selectedPeoples)
            self.tagIds = ""
            self.txtTags.text = ""
            for people in selectedPeoples {
                self.txtTags.text = "\(self.txtTags.text ?? "") @\(people.name)"
                
                if self.tagIds == ""{
                    self.tagIds = "\(self.tagIds)\(people.id)"
                }else{
                    self.tagIds = "\(self.tagIds),\(people.id)"
                }
            }
        }
        
        self.present(optionItemListVC, animated: true, completion: nil)
        print("view presented....")
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        popVC()
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        let vc = AddPhotoVideoVC()
        vc.completion = { posts1, posts2 ,images in
            
            if self.comeFrom == "Edit"{
                self.isFromTabbar = true
                self.comeFromEditPostForTag = true
                self.myPost[0].postImagesVideo = posts2
                if self.myPost[0].postImagesVideo.count != 0{
                    if self.myPost[0].postImagesVideo.count == 1{
                        self.lblSelectedItems.text = "\(self.myPost[0].postImagesVideo.count) item selected"
                    }else{
                        self.lblSelectedItems.text = "\(self.myPost[0].postImagesVideo.count) items selected"
                    }
                    
                }else{
                    self.lblSelectedItems.text = ""
                }
                
            }else{
                self.isFromTabbar = true
                self.images = images
                self.finalPostItems = posts1
                self.myPost[0].postImagesVideo = posts2
                if self.finalPostItems.count != 0{
                    if self.myPost[0].postImagesVideo.count == 1{
                        self.lblSelectedItems.text = "\(self.myPost[0].postImagesVideo.count) item selected"
                    }else{
                        self.lblSelectedItems.text = "\(self.myPost[0].postImagesVideo.count) items selected"
                    }
                    
                }else{
                    self.lblSelectedItems.text = ""
                }
                
                print("finalPostItems count --- ",self.finalPostItems.count)
                
            }
        }
        vc.selectedItems = finalPostItems
        vc.images = self.images
        vc.selectedIndex = IndexPath(row: 0, section: 0)
        vc.arrPostItems = myPost.first?.postImagesVideo ?? []
        
        if self.comeFrom == "Edit"{
            vc.arrPostItems = myPost[0].postImagesVideo
            vc.completion2 = {
                self.comeFromEditPostForTag = true
            }
            vc.comeFrom = "Edit"
        }
        
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func postAction(_ sender: UIButton) {

        if myPost.first?.postImagesVideo.count ?? 0 > 0{
            
            var imagesSelected = true
            if self.comeFrom == "Edit"{
                 imagesSelected = true
            }else{
                if images.count > 0{
                    imagesSelected = true
                }else{
                    imagesSelected = false
                }
            }
            
            guard let viewModel = self.viewModel,
                  viewModel.validateCreatePostDetails(imageSelected: imagesSelected, budget: self.txtBudget.text ?? "", noOfDays: self.txtNoOffDays.text ?? "", tripCat: txtTripCategory.text ?? "", desc: txtViewDesc.text ?? "", tripComp: txtTripComplexity.text ?? "", controller: self)else { return }
            
            self.myPost[0].budget = self.txtBudget.text ?? ""
            self.myPost[0].no_of_days_name = self.txtNoOffDays.text ?? ""
            self.myPost[0].tripCategoryName = self.txtTripCategory.text ?? ""
            self.myPost[0].description = self.txtViewDesc.text ?? ""
            self.myPost[0].trip_complexity_name = self.txtTripComplexity.text ?? ""
            
            let vc = PostVC()
            
            vc.completion = {
                //self.txtTags.text = ""
                self.comeFromPostBack = true
                self.isFromTabbar = true
            }
            
            vc.selectedDaysId = self.txtNoOffDays.text ?? "" //selectedDaysId
            vc.selectedTripCatId = selectedTripCatId
            vc.selectedTripComplexityId = selectedTripComplexityId
            vc.arrPostYP = finalPostItems
            vc.finalPost = myPost.first
            vc.tagIds = tagIds
            vc.tagPeople = tagPeople
            vc.tagPeopleName = txtTags.text
            if self.comeFrom == "Edit"{
                vc.comeForm = "Edit"
            }
            vc.images = self.images
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc, true)
        }else{
            Singleton.shared.showAlert(message: "Please select at least one video or image to post", controller: self, Title: self.viewModel?.Title ?? "")
           // Singleton.showMessage(message: "Please select atleast one video or image to post", isError: .error)
        }
       
    }
    
}

extension CreatePostVC:UITextFieldDelegate{
    
    // UITextFieldDelegate method to detect the "@" symbol
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

          if textField == txtBudget || textField == txtNoOffDays{
              let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
              
              if string.isEmpty {
                  return true
              }

              // Check if the first character of the entered text is '0'
              if textField.text?.count ?? 0 > 0{
                  
              }else{
                  
                  if let firstCharacter = string.first, firstCharacter == "0" {
                      // Reject the input by returning false
                      return false
                  }
                  
              }
              
             if newText.count > 10{
                 Singleton.showMessage(message: "maximum limit reached.", isError: .error)
             }
              return newText.count < 11
              
          }

          return true
      }
    
    
}
extension CreatePostVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension CreatePostVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if txtNoOffDays.isFirstResponder {
            return self.viewModel?.arrNoOfDays.count ?? 0
        } else if txtTripCategory.isFirstResponder {
            return self.viewModel?.arrTripCategory.count ?? 0
        } else if  txtTripComplexity.isFirstResponder {
            return self.viewModel?.arrTripComplexity.count ?? 0
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        if txtNoOffDays.isFirstResponder {
            return self.viewModel?.arrNoOfDays[row].noOfDays
            
        } else if txtTripCategory.isFirstResponder {
            return self.viewModel?.arrTripCategory[row].name
        } else if txtTripComplexity.isFirstResponder {
            return self.viewModel?.arrTripComplexity[row].name
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if txtNoOffDays.isFirstResponder {
            txtNoOffDays.text = self.viewModel?.arrNoOfDays[row].noOfDays
        } else if txtTripCategory.isFirstResponder {
            
            if row == 0{
                txtTripCategory.text = ""
            }else{
                txtTripCategory.text = self.viewModel?.arrTripCategory[row].name
            }
            
        } else if txtTripComplexity.isFirstResponder {
            if row == 0{
                txtTripComplexity.text = ""
            }else{
                txtTripComplexity.text = self.viewModel?.arrTripComplexity[row].name
            }
        }
        
    }
}


extension CreatePostVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtNoOffDays {
//            txtNoOffDays.inputView = pickerView
//            pickerView.reloadAllComponents()
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
//                let index = self.viewModel?.arrNoOfDays.firstIndex(where: {$0.noOfDays == txtNoOffDays.text ?? ""}) ?? 0
//                pickerView.selectRow(index, inComponent: 0, animated: false)
//               // txtNoOffDays.text = arrDays[index]
//            })
            
        } else if textField == txtTripCategory {
            txtTripCategory.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = self.viewModel?.arrTripCategory.firstIndex(where: {$0.name == txtTripCategory.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                //txtTripCategory.text = arrTripCat[index]
            })
            
        }else if textField == txtTripComplexity {
            txtTripComplexity.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = self.viewModel?.arrTripComplexity.firstIndex(where: {$0.name == txtTripComplexity.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
               // txtTripComplexity.text = arrTripComplexity[index]
            })
        }
        
    }
    
    
    
}
extension CreatePostVC : CustomPickerControllerDelegate{
    
    //    MARK: - learn Reason PICKER
        func showLearnReasonPicker(_ textField: UITextField, indexPath: IndexPath?) {
            let picker = CustomPickerController()
            let statesArray: [Category] = self.viewModel?.arrNoOfDays ?? []//arrDays
            picker.set(statesArray, delegate: self, tag: indexPath?.row ?? 0, element: textField)
            self.present(picker, animated: false, completion: nil)
        }
    
    
    func didSelectPicker(_ value: String, _ index: Int, _ tag: Int?, custom picker: CustomPickerController, element: Any?) {
        picker.dismiss(animated: false)
        guard let textField = element as? UITextField else { return }
        guard let row = tag else { return }
        textField.text = value
        switch textField.tag {
        case 0:
            print("in 1")
        case 1:
            print("in 2")
        case 2:
            print("in 3")
        default: break
        }
    }
    
    func cancel(picker: CustomPickerController, _ tag: Int) {
        
    }
}

extension CreatePostVC:TagListVMObserver{
    
    func observerSendMessages(json: JSON, roomId: String?, sender: UIButton?) {
        
    }
    
    
    func observeGetCategoriesListSucessfull() {
        
    }
    
   
    func observeGetTagListSucessfull() {
        
    }
    
}

extension CreatePostVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 200{
            Singleton.showMessage(message: "Discription is too long.", isError: .error)
        }
         return newText.count < 201
    }
    
    
   
}


extension CreatePostVC{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case txtNoOffDays:
                self.selectedDaysId = txtNoOffDays.text ?? ""
                print("in no of days field")
//                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
//                    let index = self.viewModel?.arrNoOfDays.firstIndex(where: {$0.noOfDays == txtNoOffDays.text ?? ""}) ?? 0
//                    
//                    if (self.viewModel?.arrNoOfDays.count ?? 0) > 0{
//                        
//                        pickerView.selectRow(index, inComponent: 0, animated: false)
//                        //                self.mId = home_Search_Data?[index].brand_name ?? ""
//                        self.txtNoOffDays.text = self.viewModel?.arrNoOfDays[index].noOfDays
//                        self.selectedDaysId = self.viewModel?.arrNoOfDays[index].id ?? ""
//                        print("   Selected No Off Days   \(self.viewModel?.arrNoOfDays[index].noOfDays ?? "") id  \(self.viewModel?.arrNoOfDays[index].id ?? "")")
//                    }
//                })
//                pickerView.reloadAllComponents()
                
            case txtTripCategory:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrTripCategory.firstIndex(where: {$0.name == txtTripCategory.text ?? ""}) ?? 0
                    if (self.viewModel?.arrTripCategory.count ?? 0) > 0 && index != 0{
                        pickerView.selectRow(index, inComponent: 0, animated: false)
                        //                self.caliber_Id = viewModel?.caliberData[index].id
                        self.txtTripCategory.text = self.viewModel?.arrTripCategory[index].name
                        self.selectedTripCatId = self.viewModel?.arrTripCategory[index].id ?? ""
                        print("  Selected Trip Category   \(self.viewModel?.arrTripCategory[index].name ?? "") id  \(self.viewModel?.arrTripCategory[index].id ?? "")")
                    }
                })
                pickerView.reloadAllComponents()
                
            case txtTripComplexity:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrTripComplexity.firstIndex(where: {$0.name == txtTripComplexity.text ?? ""}) ?? 0
                    if (self.viewModel?.arrTripComplexity.count ?? 0) > 0 && index != 0{
                        pickerView.selectRow(index, inComponent: 0, animated: false)
                        //                self.caliber_Id = viewModel?.caliberData[index].id
                        self.txtTripComplexity.text = self.viewModel?.arrTripComplexity[index].name
                        self.selectedTripComplexityId = self.viewModel?.arrTripComplexity[index].id ?? ""
                        print("  Selected Trip Complexity   \(self.viewModel?.arrTripComplexity[index].name ?? "")  Id  \(self.viewModel?.arrTripComplexity[index].id ?? "")")
                    }
                })
                pickerView.reloadAllComponents()
                
            default: break
            }
        }
   
}
