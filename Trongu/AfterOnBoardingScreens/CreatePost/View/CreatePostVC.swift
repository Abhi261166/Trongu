//
//  CreatePostVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import YPImagePicker

class CreatePostVC: UIViewController{
   
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var txtTags: UITextField!
    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtNoOffDays: UITextField!
    @IBOutlet weak var txtTripCategory: UITextField!
    @IBOutlet weak var txtTripComplexity: UITextField!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var lblSelectedItems: UILabel!
    
    var finalPostItems = [YPMediaItem]()
    var tagIds = "10"
    let pickerView = UIPickerView()
    var arrDays = ["1 day","2 days","3 days","4 days","5 days","6 days","7 days","8 days","9 days","10 days"]
    var arrTripCat = ["Business Trip","Family Trip","Friends Trip"]
    var arrTripComplexity = ["Complex","Smooth","Normal"]
    var viewModel:TagListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiledDelegates()
        setPicker()
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    func setData(){
        
        txtBudget.text = "40"
        txtNoOffDays.text = "2 days"
        txtTripCategory.text = "Business Trip"
        txtNoOffDays.text = "2 days"
        txtTripComplexity.text = "Normal"
        txtViewDesc.text = "12345"
        
        
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
        
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        let vc = AddPhotoVideoVC()
        vc.completion = { posts in
            self.finalPostItems = posts
            if self.finalPostItems.count != 0{
                self.lblSelectedItems.text = "\(self.finalPostItems.count) items selected"
            }else{
                self.lblSelectedItems.text = ""
            }
            print("finalPostItems count --- ",self.finalPostItems.count)
        }
        vc.selectedItems = finalPostItems
        vc.selectedIndex = IndexPath(row: 0, section: 0)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func postAction(_ sender: UIButton) {
//        let vc = AddPhotoVideoVC()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.popViewController(animated: true)
        
        self.viewModel?.apiCreatePost(tags: self.tagIds, budget: self.txtBudget.text ?? "", noOffDays: self.txtNoOffDays.text ?? "", tripCat: "1", disc: txtViewDesc.text ?? "", tripComp: txtTripComplexity.text ?? "", arrPosts: finalPostItems)
    }
    
}

extension CreatePostVC:UITextFieldDelegate{
    
    // UITextFieldDelegate method to detect the "@" symbol
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          guard let currentText = textField.text else {
              return true
          }

                // Check if the user has typed "@" in the text field
                  if string == "@" {
                      // Show the mentionView as an overlay
                      let optionItemListVC = MentionVC()
                      optionItemListVC.modalPresentationStyle = .popover
                    guard let popoverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Set Modal presentation style") }
                      optionItemListVC.popoverPresentationController?.sourceView = txtTags
                      popoverPresentationController.permittedArrowDirections = .down
                      optionItemListVC.preferredContentSize = CGSize(width: 300, height: 300)
                    popoverPresentationController.delegate = self
                      optionItemListVC.completion = { name,id in
                          self.tagIds.append(id)
                          self.txtTags.text = "@\(name)"
                          self.txtTags.resignFirstResponder()
                      }
                      self.present(optionItemListVC, animated: true, completion: nil)
                      print("view presented....")
                  } else {
                      // Hide the mentionView if "@" is not detected
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
            return arrDays.count
        } else if txtTripCategory.isFirstResponder {
            return arrTripCat.count
        } else if  txtTripComplexity.isFirstResponder {
            return arrTripComplexity.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        if txtNoOffDays.isFirstResponder {
            return arrDays[row]
            
        } else if txtTripCategory.isFirstResponder {
            return arrTripCat[row]
        } else if txtTripComplexity.isFirstResponder {
            return arrTripComplexity[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if txtNoOffDays.isFirstResponder {
            txtNoOffDays.text = arrDays[row]
        } else if txtTripCategory.isFirstResponder {
            txtTripCategory.text = arrTripCat[row]
        } else if txtTripComplexity.isFirstResponder {
            txtTripComplexity.text = arrTripComplexity[row]
        }
        
    }
}


extension CreatePostVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtNoOffDays {
            txtNoOffDays.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrDays.firstIndex(where: {$0 == txtNoOffDays.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                txtNoOffDays.text = arrDays[index]
            })
            
        } else if textField == txtTripCategory {
            txtTripCategory.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrTripCat.firstIndex(where: {$0 == txtTripCategory.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                txtTripCategory.text = arrTripCat[index]
            })
            
        }else if textField == txtTripComplexity {
            txtTripComplexity.inputView = pickerView
            pickerView.reloadAllComponents()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
                let index = arrTripComplexity.firstIndex(where: {$0 == txtTripComplexity.text ?? ""}) ?? 0
                pickerView.selectRow(index, inComponent: 0, animated: false)
                txtTripComplexity.text = arrTripComplexity[index]
            })
        }
        
    }
}
extension CreatePostVC : CustomPickerControllerDelegate{
    
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

extension CreatePostVC:TagListVMObserver{
    func observePostAddedSucessfull() {
       print("Postedddd")
    }
    func observeGetTagListSucessfull() {
        
    }
    
}
