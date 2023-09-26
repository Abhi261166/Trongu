//
//  ChatVM.swift
//  Trongu
//
//  Created by apple on 25/09/23.
//

import UIKit

protocol CreateRoomObserver: NSObjectProtocol {
    func observeCreateRoom(model: ChatUserData)
}

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
    var otherUserProfile: String = ""
    
    init(observer: ChatVMObserver?) {
        self.observer = observer
    }
    
    class func apiCreateRoom(otherUserId: String, observer: CreateRoomObserver?) {
        var params = JSON()
       
        params["other_id"] = otherUserId
      
        print("params : ", params)
//        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.createRoom, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
             
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            
                            let decoded = try? decoder.decode(CreateRoomModel.self, from: data)
                            if let model = decoded?.data {
                                observer?.observeCreateRoom(model: model)
                            }
                           
                        } catch {
                            print("error", error)
                        }
                    } else {
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
            
            }
        }
    }
    
    
}
