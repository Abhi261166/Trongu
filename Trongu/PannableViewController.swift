//
//  PannableViewController.swift
//  OnTheYard
//
//  Created by Apple on 25/04/23.
//

import UIKit

class PannableViewController: UIViewController {
    
    var transitionHeight: CGFloat = 150
    
    @IBOutlet var gbView: UIView!
    @IBOutlet weak var contentView: UIView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.transitionHeight = self.view.frame.height/2
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.gbView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        setPopUpDismiss()
    }
    
    @objc func handleDismiss(sender : UIPanGestureRecognizer){
        if let viewHeight = contentView?.frame.size.height {
            self.gbView.backgroundColor = .clear
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
               // self.gbView.backgroundColor = .clear
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

extension PannableViewController: UIGestureRecognizerDelegate {
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
