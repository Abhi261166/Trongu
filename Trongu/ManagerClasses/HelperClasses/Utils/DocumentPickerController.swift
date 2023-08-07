//
//  DocumentPicker.swift
//  meetwise
//
//  Created by Nitin Kumar on 12/09/20.
//  Copyright © 2020 Nitin Kumar. All rights reserved.
//

import UIKit
import MobileCoreServices

class DocumentPickerController: UIDocumentPickerViewController {
    
    private var didPick:((_ str: String?) -> ())? = nil
    private var didCancel:((_ str: String?) -> ())? = nil
    
    init() {
//        super.init(documentTypes: ["public.image", "public.jpeg", "public.png"], in: .import)
        super.init(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        self.modalPresentationStyle = .fullScreen
        self.allowsMultipleSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(controller: UIViewController?, didPick: @escaping(_ data: String?) -> (), didCancel: @escaping(_ data: String?) -> ()) {
        self.delegate = self
        controller?.present(self, true)
        self.didPick = didPick
        self.didCancel = didCancel
    }
    
}

extension DocumentPickerController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("did Pick Documents At \(urls.count)")
        self.didPick?(urls.first?.absoluteString)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("canceled")
        self.didCancel?("canceled")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("did Pick Document At \(url)")
        self.didPick?(url.absoluteString)
    }
    
}
