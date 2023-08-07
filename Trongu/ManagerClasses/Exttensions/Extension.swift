//
//  Extension.swift
//  Vanguards
//
//  Created by apple on 12/06/23.
//

import Foundation
import UIKit

extension String{
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
   }
extension UITextField{
    func isValidPassword() -> Bool {
        if self.text?.count ?? 0 < 8 {
            return false
        }
        return true
    }
    func isValidConfirmPassword() -> Bool {
        if self.text?.count ?? 0 < 8 {
            return false
        }
        return true
    }
    
    func isValidCurrentPassword() -> Bool {
        if self.text?.count ?? 0 < 6 {
            return false
        }
        return true
    }
    
    func isValidNewPassword() -> Bool {
        if self.text?.count ?? 0 < 6 {
            return false
        }
        return true
    }
    
    func isValidConfirmNewPassword() -> Bool {
        if self.text?.count ?? 0 < 6 {
            return false
        }
        return true
    }
}
