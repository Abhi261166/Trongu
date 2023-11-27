//
//  FilterScreenVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit
import MultiSlider
class FilterScreenVC: UIViewController {
    
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var numberOfDaysTF: UITextField!
    @IBOutlet weak var tripCategoryTF: UITextField!
    @IBOutlet weak var ethnicityTF: UITextField!
    @IBOutlet weak var complexityTF: UITextField!
    @IBOutlet weak var multislider: MultiSlider!
    @IBOutlet weak var lblMaxAmount: UILabel!
    @IBOutlet weak var lblMinAmount: UILabel!
   
    let pickerView = UIPickerView()
    
    var arrDays = ["1 day","2 days","3 days","4 days","5 days","6 days","7 days","8 days","9 days","10 days"]
    var arrTripCat = ["Business Trip","Family Trip","Friends Trip","Solo Trip"]
    var arrTripComplexity = ["Complex","Smooth","Normal"]
    var arrEthnicityPicker = ["America","Canada"]
    var completion : ((_ place:String?,_ budget:String?,_ noOffDays:String?,_ tripCat:String?,_ ethnicity:String?,_ complexity:String?) -> Void)? = nil
    var minPrice = ""
    var maxPrice = ""
    var viewModel:FilterVM?
    // selected id's
    var selectedDaysId = ""
    var selectedTripCatId = ""
    var selectedTripComplexityId = ""
    var selectedEthnicity = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multislider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        setPicker()
        setViewModel()
        numberOfDaysTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPickerData()
        
    }

    func setViewModel(){
        
        self.viewModel = FilterVM(observer: self)
        
    }
    
    func getPickerData(){
        self.viewModel?.apiGetCategoriesList(type: 1)
        self.viewModel?.apiGetEthnicityCategoriesList(type: 2)
    }
    
    func setPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        // self.genderButton.isUserInteractionEnabled = false
        numberOfDaysTF.delegate = self
        tripCategoryTF.delegate = self
        ethnicityTF.delegate = self
        complexityTF.delegate = self
  
    }
    
    
    @objc func sliderChanged(slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        lblMaxAmount.text = "$\(Int(slider.value.last ?? 0.0))"
        lblMinAmount.text = "$\(Int(slider.value.first ?? 0.0))"
        
    }
    
    func validation() {
        if placeTF.text == ""{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
    }else if numberOfDaysTF.text == ""{
        Trongu.showAlert(title: Constants.AppName, message: Constants.blankNumberofdays, view: self)
        }else if tripCategoryTF.text == "" {
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankTripcategory, view: self)
        }else if ethnicityTF.text == "" {
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if complexityTF.text == "" {
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankComplexity, view: self)
        }else{
//            let vc = CheckAvailabilityScreenVC()
//            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        minPrice = "\(Int(multislider.value.first ?? 0.0))"
        maxPrice = "\(Int(multislider.value.last ?? 0.0))"
        var noOfDays = numberOfDaysTF.text?.replacingOccurrences(of: " ", with: "")
        noOfDays = noOfDays?.replacingOccurrences(of: "day", with: "")
        noOfDays = noOfDays?.replacingOccurrences(of: "days", with: "")
        noOfDays = noOfDays?.replacingOccurrences(of: "s", with: "")
        
        if let completion = completion{
            popVC()
            completion(placeTF.text,"\(minPrice)-\(maxPrice)",numberOfDaysTF.text?.trim,selectedTripCatId,selectedEthnicity,selectedTripComplexityId)
            
        }
        
    }
    
    @IBAction func actionSelectAddress(_ sender: UIButton) {
        
        let vc = AddLocationVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FilterScreenVC:AddLocationVCDelegate{
   
    
    func setLocation(text: String, lat: Double, long: Double, address: String,country: String) {
        
        DispatchQueue.main.async {
            self.placeTF.text = address
        }
        
    }
     
}



extension FilterScreenVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if numberOfDaysTF.isFirstResponder {
            return self.viewModel?.arrNoOfDays.count ?? 0
        } else if tripCategoryTF.isFirstResponder {
            return self.viewModel?.arrTripCategory.count ?? 0
        } else if  ethnicityTF.isFirstResponder {
            return self.viewModel?.arrEthnicity.count ?? 0
        }else if complexityTF.isFirstResponder{
            return self.viewModel?.arrTripComplexity.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        if numberOfDaysTF.isFirstResponder {
            return self.viewModel?.arrNoOfDays[row].noOfDays
        } else if tripCategoryTF.isFirstResponder {
            return self.viewModel?.arrTripCategory[row].name
        } else if ethnicityTF.isFirstResponder {
            return self.viewModel?.arrEthnicity[row].name
        }else if complexityTF.isFirstResponder{
            return self.viewModel?.arrTripComplexity[row].name
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

//        if numberOfDaysTF.isFirstResponder {
//            numberOfDaysTF.text = self.viewModel?.arrNoOfDays[row].noOfDays
//        } else if tripCategoryTF.isFirstResponder {
//            tripCategoryTF.text = self.viewModel?.arrTripCategory[row].name
//        } else if ethnicityTF.isFirstResponder {
//            ethnicityTF.text = self.viewModel?.arrEthnicity[row].name
//        }else if complexityTF.isFirstResponder{
//            complexityTF.text = self.viewModel?.arrTripComplexity[row].name
//        }
        
        
        if numberOfDaysTF.isFirstResponder {
            numberOfDaysTF.text = self.viewModel?.arrNoOfDays[row].noOfDays
        } else if tripCategoryTF.isFirstResponder {
            
            if row == 0{
                tripCategoryTF.text = ""
            }else{
                tripCategoryTF.text = self.viewModel?.arrTripCategory[row].name
            }
            
        } else if complexityTF.isFirstResponder {
            if row == 0{
                complexityTF.text = ""
            }else{
                complexityTF.text = self.viewModel?.arrTripComplexity[row].name
            }
        }else if ethnicityTF.isFirstResponder {
            if row == 0{
                ethnicityTF.text = ""
            }else{
                ethnicityTF.text = self.viewModel?.arrEthnicity[row].name
            }
        }
        
    }
}

extension FilterScreenVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == numberOfDaysTF {
//            numberOfDaysTF.inputView = pickerView
//            pickerView.reloadAllComponents()
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
//                let index = arrDays.firstIndex(where: {$0 == numberOfDaysTF.text ?? ""}) ?? 0
//                pickerView.selectRow(index, inComponent: 0, animated: false)
//               // numberOfDaysTF.text = arrDays[index]
//            })
            
        } else if textField == tripCategoryTF {
            tripCategoryTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = self.viewModel?.arrTripCategory.firstIndex(where: {$0.name == tripCategoryTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                //tripCategoryTF.text = arrTripCat[index]
            })
            
        }else if textField == ethnicityTF {
            ethnicityTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = self.viewModel?.arrEthnicity.firstIndex(where: {$0.name == ethnicityTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
              //  ethnicityTF.text = arrEthnicityPicker[index]
            })
        }else if textField == complexityTF {
            complexityTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = self.viewModel?.arrTripComplexity.firstIndex(where: {$0.name == complexityTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
              //  complexityTF.text = arrTripComplexity[index]
            })
            
        }
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case numberOfDaysTF:
                self.selectedDaysId = numberOfDaysTF.text ?? ""
                print("in no of days field")
//                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
//                    let index = arrDays.firstIndex(where: {$0 == numberOfDaysTF.text ?? ""}) ?? 0
//                  //  pickerView.selectRow(index, inComponent: 0, animated: false)
//                    //                self.mId = home_Search_Data?[index].brand_name ?? ""
//                    
//                    
//                    self.numberOfDaysTF.text = self.viewModel?.arrNoOfDays[index].noOfDays
//                    self.selectedDaysId = self.viewModel?.arrNoOfDays[index].id ?? ""
//                    print("   Selected No Off Days   \(self.viewModel?.arrNoOfDays[index].noOfDays ?? "") id  \(self.viewModel?.arrNoOfDays[index].id ?? "")")
//                    
//                })
//                pickerView.reloadAllComponents()
                
            case tripCategoryTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrTripCategory.firstIndex(where: {$0.name == tripCategoryTF.text ?? ""}) ?? 0
                  //  pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.caliber_Id = viewModel?.caliberData[index].id
                    if (self.viewModel?.arrTripCategory.count ?? 0) > 0 && index != 0{
                    self.tripCategoryTF.text = self.viewModel?.arrTripCategory[index].name
                    self.selectedTripCatId = self.viewModel?.arrTripCategory[index].id ?? ""
                    print("  Selected Trip Category   \(self.viewModel?.arrTripCategory[index].name ?? "") id  \(self.viewModel?.arrTripCategory[index].id ?? "")")
                    }
                })
                pickerView.reloadAllComponents()
                
            case ethnicityTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrEthnicity.firstIndex(where: {$0.name == ethnicityTF.text ?? ""}) ?? 0
                   // pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.caliber_Id = viewModel?.caliberData[index].id
                    if (self.viewModel?.arrEthnicity.count ?? 0) > 0 && index != 0{
                        self.ethnicityTF.text = self.viewModel?.arrEthnicity[index].name
                        self.selectedEthnicity = self.viewModel?.arrEthnicity[index].id ?? ""
                        print("  Selected Trip Complexity   \(self.viewModel?.arrEthnicity[index].name ?? "")  Id  \(self.viewModel?.arrEthnicity[index].id ?? "")")
                    }
                })
                pickerView.reloadAllComponents()
            case complexityTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = self.viewModel?.arrTripComplexity.firstIndex(where: {$0.name == complexityTF.text ?? ""}) ?? 0
                   // pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.caliber_Id = viewModel?.caliberData[index].id
                    if (self.viewModel?.arrTripComplexity.count ?? 0) > 0 && index != 0{
                        self.complexityTF.text = self.viewModel?.arrTripComplexity[index].name
                        self.selectedTripComplexityId = self.viewModel?.arrTripComplexity[index].id ?? ""
                        print("  Selected Trip Complexity   \(self.viewModel?.arrTripComplexity[index].name ?? "")  Id  \(self.viewModel?.arrTripComplexity[index].id ?? "")")
                    }
                    })
                pickerView.reloadAllComponents()
            default: break
            }
        }
    
    
    // UITextFieldDelegate method to detect the "@" symbol
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

          if textField == numberOfDaysTF{
              let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
              
              if string.isEmpty {
                  return true
              }

              // Check if the first character of the entered text is '0'
              if numberOfDaysTF.text?.count ?? 0 > 0{
                  
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

extension FilterScreenVC : CustomPickerControllerDelegate{
    
    //    MARK: - learn Reason PICKER
        func showLearnReasonPicker(_ textField: UITextField, indexPath: IndexPath?) {
            let picker = CustomPickerController()
            let statesArray: [Category] = self.viewModel?.arrNoOfDays ?? []
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

extension FilterScreenVC: FilterVMObserver{
    
    func observeGetCategoriesListSucessfull() {
        
    }
    
}
