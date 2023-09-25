//
//  ChatVM.swift
//  Trongu
//
//  Created by apple on 25/09/23.
//

import UIKit

protocol ChatVMObserver: NSObjectProtocol {
//    func observerListMessages()
//    func observerRemoveHeader()
//    func observerPreviousMessages(indexPaths:[IndexPath])
//    func observerSendMessages(json: [String: Any], message: MessageData)
//    func updateSeenStatus()
//    func observeDeleteMessage(indexPath: IndexPath)
}

class ChatVM: NSObject {

    var observer: ChatVMObserver?
    var isAllReadMessage: Bool = false
    var pageCompleted: Bool = false
    var updating: Bool = false
    var otherUserName: String = ""
    var otherUserId: String = ""
    var roomId: String = ""
    var page_no: Int = 0
    var per_page: Int = 30
    var isLoadingMesssages: Bool = false
  //  var chatHistory = [MessageData]()
    var recieverDetails: UserData?
    var imagePicker = ImagePicker()
    var imageData: [PickerData] = []
    
    init(observer: ChatVMObserver?) {
        self.observer = observer
    }
    
    
}
