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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multislider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        setPicker()
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
        var tripCat = ""
        switch tripCategoryTF.text{
        case "Business Trip":
            tripCat = "1"
        case "Family Trip":
            tripCat = "2"
        case "Friends Trip":
            tripCat = "3"
        case "Solo Trip":
            tripCat = "4"
        default:
            break
        }
        
        var ethnicity = ""
        switch ethnicityTF.text {
        case "America":
            ethnicity = "1"
        case "Canada":
            ethnicity = "2"
        default:
            break
        }
        
        if let completion = completion{
            popVC()
            completion(placeTF.text,"\(minPrice)-\(maxPrice)",noOfDays,tripCat,ethnicity,complexityTF.text)
            
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
            return arrDays.count
        } else if tripCategoryTF.isFirstResponder {
            return arrTripCat.count
        } else if  ethnicityTF.isFirstResponder {
            return arrEthnicityPicker.count
        }else if complexityTF.isFirstResponder{
            return arrTripComplexity.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        if numberOfDaysTF.isFirstResponder {
            return arrDays[row]
        } else if tripCategoryTF.isFirstResponder {
            return arrTripCat[row]
        } else if ethnicityTF.isFirstResponder {
            return arrEthnicityPicker[row]
        }else if complexityTF.isFirstResponder{
            return arrTripComplexity[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if numberOfDaysTF.isFirstResponder {
            numberOfDaysTF.text = arrDays[row]
        } else if tripCategoryTF.isFirstResponder {
            tripCategoryTF.text = arrTripCat[row]
        } else if ethnicityTF.isFirstResponder {
            ethnicityTF.text = arrEthnicityPicker[row]
        }else if complexityTF.isFirstResponder{
            complexityTF.text = arrTripComplexity[row]
        }
        
    }
}

extension FilterScreenVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == numberOfDaysTF {
            numberOfDaysTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrDays.firstIndex(where: {$0 == numberOfDaysTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
               // numberOfDaysTF.text = arrDays[index]
            })
            
        } else if textField == tripCategoryTF {
            tripCategoryTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrTripCat.firstIndex(where: {$0 == tripCategoryTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                //tripCategoryTF.text = arrTripCat[index]
            })
            
        }else if textField == ethnicityTF {
            ethnicityTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrEthnicityPicker.firstIndex(where: {$0 == ethnicityTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
              //  ethnicityTF.text = arrEthnicityPicker[index]
            })
        }else if textField == complexityTF {
            complexityTF.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrTripComplexity.firstIndex(where: {$0 == complexityTF.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
              //  complexityTF.text = arrTripComplexity[index]
            })
            
        }
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case numberOfDaysTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = arrDays.firstIndex(where: {$0 == numberOfDaysTF.text ?? ""}) ?? 0
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.mId = home_Search_Data?[index].brand_name ?? ""
                    self.numberOfDaysTF.text = arrDays[index]
                    print("   brandName[index]     \(   arrDays[index] )")
                })
                pickerView.reloadAllComponents()
                
            case tripCategoryTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = arrTripCat.firstIndex(where: {$0 == tripCategoryTF.text ?? ""}) ?? 0
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.caliber_Id = viewModel?.caliberData[index].id
                    self.tripCategoryTF.text = arrTripCat[index]
                    print("  caliberName[index]    \(  self.arrTripCat[index])")
                })
                pickerView.reloadAllComponents()
                
            case ethnicityTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = arrEthnicityPicker.firstIndex(where: {$0 == ethnicityTF.text ?? ""}) ?? 0
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.caliber_Id = viewModel?.caliberData[index].id
                    self.ethnicityTF.text = arrEthnicityPicker[index]
                    print("  caliberName[index]    \(  self.arrEthnicityPicker[index])")
                })
                pickerView.reloadAllComponents()
            case complexityTF:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                    let index = arrTripComplexity.firstIndex(where: {$0 == complexityTF.text ?? ""}) ?? 0
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    //                self.caliber_Id = viewModel?.caliberData[index].id
                    self.complexityTF.text = arrTripComplexity[index]
                    print("  caliberName[index]    \(  self.arrTripComplexity[index])")
                })
                pickerView.reloadAllComponents()
            default: break
            }
        }
    
    
}

extension FilterScreenVC : CustomPickerControllerDelegate{
    
    //    MARK: - learn Reason PICKER
        func showLearnReasonPicker(_ textField: UITextField, indexPath: IndexPath?) {
            let picker = CustomPickerController()
            let statesArray: [String] = arrDays
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
