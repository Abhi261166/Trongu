//
//  CreatePostVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class CreatePostVC: UIViewController {

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var txtTags: UITextField!
    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtNoOffDays: UITextField!
    @IBOutlet weak var txtTripCategory: UITextField!
    @IBOutlet weak var txtTripComplexity: UITextField!
    @IBOutlet weak var txtViewDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiledDelegates()
    }
    
    
    func textFiledDelegates(){
        txtTags.delegate = self
        
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        let vc = AddPhotoVideoVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func postAction(_ sender: UIButton) {
//        let vc = AddPhotoVideoVC()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popViewController(animated: true)
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
