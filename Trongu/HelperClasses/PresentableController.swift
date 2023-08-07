//
//  PresentableController.swift
//  meetwise
//
//  Created by Amandeep on 29/12/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit

class PresentableController: UIViewController {
    
    var transitionHeight: CGFloat = 150
    
    
    @IBOutlet weak var contentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.transitionHeight = self.view.frame.height/2
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        setPopUpDismiss()
        self.contentView?.addShadow()
    }
    
    @objc func handleDismiss(sender : UIPanGestureRecognizer) {
        if let viewHeight = contentView?.frame.size.height {
            self.transitionHeight = viewHeight/2
        }
        let transfromY = sender.translation(in: view).y
        switch sender.state {
        case .changed:
            if transfromY > 0 {
                self.view.transform = CGAffineTransform(translationX: 0, y: transfromY)
            } else {
                self.view.transform = .identity
            }
        case .ended:
            if transfromY < transitionHeight {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    
    func setPopUpDismiss() {
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func myviewTapped(_ recognizer: UIGestureRecognizer) {
        self.dismiss(animated: true) {}
    }
}


extension PresentableController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = contentView {
            if view.bounds.contains(touch.location(in: view)) {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
}
