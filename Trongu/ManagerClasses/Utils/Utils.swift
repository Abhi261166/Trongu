//
//  Utils.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 07/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit

class Utils {
    static func presentAlert(message: String, title: String, view: UIViewController) {
        view.view.endEditing(true)
        Singleton.shared.showErrorMessage(error: message, isError: .error)
        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: Text.capital.ok, style: .default, handler: nil))
//        view.present(alert, animated: true, completion: nil)
    }
    
}
