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
    func observerListMessages()
    func observerRemoveHeader()
    func observerPreviousMessages(indexPaths:[IndexPath])
    func observerSendMessages(json: [String: Any], message: MessageDetails)
    func updateSeenStatus()
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
    var chatHistory = [MessageDetails]()
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
    
    
    //MARK: Api massages listing
    
    func apiListMessages() {
        guard self.isLoadingMesssages == false else { return }
        let userid = UserDefaultsCustom.userId
        //let lastid = self.chatHistory.count > 0 ? (self.chatHistory.first?.id ?? "") : "0"
        var params = JSON()
            params["per_page"] = "\(self.per_page)"
            params["page_no"] = page_no + 1
            params["room_id"] = self.roomId
        print("Params in post screen:-  \(params)")
        self.isLoadingMesssages = true
        ApiHandler.call(apiName: API.Name.getAllChat, params: params, httpMethod: .POST) { succeeded, response, data in
            self.isLoadingMesssages = false
            DispatchQueue.main.async {
                if succeeded == true {
                    if let response = DataDecoder.decodeData(data, type: AllMessagesModel.self) {
                      
                        self.observer?.observerRemoveHeader()
                  
                            let messages = response.data
                            self.pageCompleted = messages.count < self.per_page
                            if self.chatHistory.count == 0 {
                                self.chatHistory.insert(contentsOf: messages, at: 0)
                                self.observer?.observerListMessages()
                            } else {
                                self.chatHistory.insert(contentsOf: messages, at: 0)
                                let indexPaths = messages.enumerated().map({IndexPath(row: $0.offset, section: 0)})
                                self.observer?.observerPreviousMessages(indexPaths: indexPaths)
                            }
                   
                    }
                } else {
                    self.showMessage(message: response["message"] as? String ?? "" , isError: .error)
                    self.observer?.observerRemoveHeader()
                }
            }
        }
    }
    
    //MARK: Api massages listing
    
    func getAllMessageList(){
        guard self.isLoadingMesssages == false else { return }
        let userid = UserDefaultsCustom.userId
        //let lastid = self.chatHistory.count > 0 ? (self.chatHistory.first?.id ?? "") : "0"
        var params = JSON()
            params["per_page"] = "\(self.per_page)"
            params["page_no"] = page_no + 1
            params["room_id"] = self.roomId
        print("Params in post screen:-  \(params)")
        self.isLoadingMesssages = true
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getAllChat, params: params) { succeeded, response, data in
            self.isLoadingMesssages = false
        ActivityIndicator.shared.hideActivityIndicator()
            DispatchQueue.main.async {
                if succeeded == true {
                    if let response = DataDecoder.decodeData(data, type: AllMessagesModel.self) {
                      
                        self.observer?.observerRemoveHeader()
                  
                            let messages = response.data
                            self.pageCompleted = messages.count < self.per_page
                            if self.chatHistory.count == 0 {
                                self.chatHistory.insert(contentsOf: messages, at: 0)
                                self.observer?.observerListMessages()
                            } else {
                                self.chatHistory.insert(contentsOf: messages, at: 0)
                                let indexPaths = messages.enumerated().map({IndexPath(row: $0.offset, section: 0)})
                                self.observer?.observerPreviousMessages(indexPaths: indexPaths)
                            }
                   
                    }
                } else {
                    self.showMessage(message: response["message"] as? String ?? "" , isError: .error)
                    self.observer?.observerRemoveHeader()
                }
            }
        }
    }
    
    
    func apiSendMessages(message: String,type:Int,sender: UIButton) {
       var params = JSON()
        params["message"] = message
        params["type"] = type
        params["room_id"] = self.roomId
        print("params : ", params)
     
//        add loader
      // ActivityIndicator.shared.showActivityIndicator()
       ApiHandler.callWithMultipartForm(apiName: API.Name.sendMessage, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
               sender.isUserInteractionEnabled = true
               if succeeded == true {
                   if let message = DataDecoder.decodeData(data, type: SendMessageModel.self)?.data,
                       let json = response["data"] as? JSON {
                       self.observer?.observerSendMessages(json: json, message: message)
                   }
               } else {
                   self.showMessage(message: response["message"] as? String ?? "", isError: .error)
               }
           }
       }
   }
    
    
    func apiSendMessagesWithImges(type:Int,sender: UIButton) {
        var params = JSON()
        params["message"] = ""
        params["type"] = type
        params["room_id"] = self.roomId
        print("params : ", params)
        
        print("Params in SearchUsers screen:-  \(params)")
        print("imageData in SearchUsers screen:-  \(imageData)")
        
        ApiHandler.uploadPost(key: "image_id", apiName: API.Name.sendMessage, dataArray: self.imageData, imgs_deleted: [], imageKey: ["uploads"], params: params) { succeeded, response, data in
            
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
                print("api responce in SendMessagesWithImges screen : \(response)")
                if succeeded == true {
                    if let message = DataDecoder.decodeData(data, type: SendMessageModel.self)?.data,
                        let json = response["data"] as? JSON {
                       
                        self.observer?.observerSendMessages(json: json, message: message)
                    }
                } else {
                    self.showMessage(message: response["message"] as? String ?? "", isError: .error)
                }
            }
            
        }
    }
    
    //MARK: Update seen Api
        func apiUpdateSeenStatus() {
           
            let params: [String:Any] = [
                "room_id"  : self.roomId
            ]
            print("Params in SearchUsers screen:-  \(params)")
            ApiHandler.callWithMultipartForm(apiName: API.Name.updateSeen, params: params) { succeeded, response, data in
                DispatchQueue.main.async {
                    if succeeded == true {
                        self.observer?.updateSeenStatus()
                    } else {
                        self.showMessage(message: response["message"] as? String ?? "", isError: .error)
                    }
                }
            }
        }
    
    
}
