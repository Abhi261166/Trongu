//
//  MessageView.swift
//  Clout Lyfe
//
//  Created by apple on 21/06/22.
//

import UIKit

@IBDesignable
class MessageView: UIView {

   // var direction: ChatDirection = .right
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius:20, width: self.bounds.width, height: self.bounds.height)
        self.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20, width: self.bounds.width, height: self.bounds.height)
        
//        if direction == .left {
//            self.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 10, width: self.bounds.width, height: self.bounds.height)
//        } else {
//            self.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 10, width: self.bounds.width, height: self.bounds.height)
//        }
    }
}

