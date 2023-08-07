////
////  SocketManager.swift
////  CoWorkerUser
////
////  Created by Rakesh Kumar on 09/05/18.
////  Copyright © 2018 Nitin Kumar. All rights reserved.
////

import UIKit
import SocketIO
//import Swifter

enum SocketEvents {
    case isTyping
    case isStopTyping
    case connection
    case sendMessage
    case isOffline
    case isOnline
    case sendGroupMessage
    case confirmReadStatus
    case replyChatMessage
    case sendBulkChatMessage
    
    func name() -> String {
        switch self {
        case .isTyping:
            return "isTyping"
        case .connection:
            return "connection"
        case .sendMessage:
            return "sendChatMessage"
        case .sendGroupMessage:
            return "sendChatMessage"
        case .isStopTyping:
            return "stopTyping"
        case .isOnline:
            return "isOnline"
        case .isOffline:
            return "isOffline"
        case .confirmReadStatus:
            return "confirmReadStatus"
        case .replyChatMessage:
            return "replyChatMessage"
        case .sendBulkChatMessage:
            return "sendBulkChatMessage"
        }
    }
}

enum SocketListeners {
    case socketErr
    case socketConnected
    case sendMessage
    case sendGroupMessage
    case isTyping
    case isTypingStop
    case isSeen
    case isOnline
    case isOffline
    
    func name() -> String {
        switch self {
        case .socketErr:
            return "socketErr"
        case .socketConnected:
            return "socketConnected"
        case .sendMessage:
            return "sendMessage"
        case .sendGroupMessage:
            return "sendGroupMessage"
        case .isTyping:
            return "isTyping"
        case .isTypingStop:
            return "stopTyping"
        case .isSeen:
            return "isSeen"
        case .isOnline:
            return "isOnline"
        case .isOffline:
            return "isOffline"
        }
    }
}

protocol SockettonDelegate: NSObjectProtocol {
    func socketMessageReceived(_ socket: Socketton?, json: JSON)
    func socketConnected(_ socket: Socketton?)
//    func socketOnline(_ socket: Socketton?, json: JSON)
//    func socketTyping(_ socket: Socketton?, json: JSON)
//    func socketStopTyping(_ socket: Socketton?, json: JSON)
//    func socketMessageSeen(_ socket: Socketton?, json: JSON)
//    func socketMessageReceivedStatusUpdate(_ socket: Socketton?, json: JSON)
//    func socketOffline(_ socket: Socketton?, json: JSON)
//    func socketDeleteMessage(_ socket: Socketton?, json: JSON)
//    func socketOwnChatMessageReceived(_ socket: Socketton?, json: JSON)
}


class Socketton: NSObject {

    var manager: SocketManager?
    var chatId: String = ""
    var userId: String? = UserDefaultsCustom.userId
    var isConnected:Bool = false
    weak var socket: SocketIOClient?
    weak var delegate: SockettonDelegate?
    
    override init() {
        super.init()
    }
    
    init(chatId: String, delegate: SockettonDelegate?) {
        super.init()
        self.chatId = chatId
        self.delegate = delegate
    }
    
    func setupSocket() {
        guard self.socket == nil else { return }
        let userId = UserDefaultsCustom.userId //http://161.97.132.85:3020
        self.manager = SocketManager(socketURL: URL(string: "http://161.97.132.85:3020/")!, config: SocketIOClientConfiguration(arrayLiteral: SocketIOClientOption.connectParams(["userId": userId ?? "", "userType": "USER"])))
        self.socket = manager?.defaultSocket
    }
    
    func establishConnection() {
        if let socketConnectionStatus = self.socket?.status {
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                self.isConnected = true
                self.delegate?.socketConnected(self)
            case SocketIOStatus.connecting:
                print("socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
                self.isConnected = false
                self.setupConnection()
            case SocketIOStatus.notConnected:
                print("socket not connected")
                self.isConnected = false
                self.setupConnection()
            }
        } else {
            self.setupConnection()
        }
    }
    
    func setSocket() {
        self.setupSocket()
        self.manager?.connect()
        socket?.connect(timeoutAfter: 10.0, withHandler: {
            print("time out")
        })
    }
    
    func setupConnection(complition:((Bool)->())? = nil) {
        self.setupSocket()
        manager?.connect()
        socket?.connect(timeoutAfter: 10.0, withHandler: {
            print("time out")
        })
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.isConnected = true
            self.delegate?.socketConnected(self)
        }
        self.socket?.on(SocketListeners.socketErr.name(), callback: {data, ack in
            print("socket Error = ", data)
        })
        self.socket?.on(SocketListeners.socketConnected.name(), callback: {data, ack in
            print("socket connected = ", data)
            complition?(true)
        })
        self.socket?.on("newMessage") { (data, ack) in
            print("newMessage \(data.first)")
            if let msg = data.last as? JSON {
                self.delegate?.socketMessageReceived(self, json: msg)
            } else if let last = data.last as? String {
                do {
                    if let msg = try JSONSerialization.jsonObject(with: last.data(using: .utf8)!, options: []) as? [String:Any] {
                        self.delegate?.socketMessageReceived(self, json: msg)
                    }
                } catch {
                    print("error to detect message: \(error)")
                }
            } else {
                print("message not detect ")
            }
        }
    }
    
    func closeConnection() {
        socket?.disconnect()
        socket = nil
    }
    
    public func socketConnected(callback:(() -> Void)?) {
//        self.isSocketConnectedCallback = callback
        self.delegate?.socketConnected(self)
    }
    
    func sendMessage(_ dict: JSON, roomId: String) {
        self.checkConnection { conected in
            print("message send \(roomId)")
            self.socket?.emit("newMessage", roomId, dict)
        }
    }
    
    func conncetedChat(roomId: String) {
        guard socket != nil else { return }
        print("ConncetedChat is ***  *** \(roomId) **  \(socket?.status)")
        self.socket?.emit("ConncetedChat", roomId)
    }
    
    func checkConnection(complition: ((Bool)->())?) {
        if self.socket == nil {
            self.setupConnection(complition: complition)
        } else {
            if self.socket?.status == .connected {
                print("connected Socket")
                complition?(true)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    print("not connected Socket")
                    self.checkConnection(complition: complition)
                }
            }
        }
    }
    
    func sendMessage(_ dict: JSON, roomIds: [String], completion: @escaping(()->())) {
        self.checkConnection { conected in
            
            var count = 0 {
                didSet {
                    print("all message sent \(count)")
                    if count == roomIds.count {
                        completion()
                        print("all message sent")
                    }
                }
            }
            roomIds.forEach { roomId in
                self.socket?.emit("newMessage", roomId, dict, completion: {
                    count = count + 1
                })
            }
        }
    }
    
}


class BlukMessageSend: NSObject {
    
    var socketton: Socketton?
    
    func setSocket(message: JSON, roomIds: [String]) {
        guard socketton == nil else { return }
        socketton = Socketton()
        socketton?.establishConnection()
        socketton?.checkConnection(complition: { succ in
            if succ == true {
                roomIds.forEach { id in
                    self.socketton?.sendMessage(message, roomId: id)
                }
//                self.socketton?.sendMessage(message, roomIds: roomIds, completion: {
//                    DispatchQueue.main.async {
//                        print("complition of message send")
////                        self.socketton
//                    }
//                })
            }
        })
    }
    
}












//        print("chat id *************************** \(chatId)")
//        self.socket?.on("isOnline_\(chatId)", callback: {[weak self] data, ack in
//            print(data.jsonString)
//            if let data = data[0] as? [String: Any] {
//                print(" asjdkfjkl sjdlkfj klsadf isOnline_ \(data)")
////                if data.string(forKey: "sender") != self?.userId {
////                    self?.delegate?.socketOnline(self, json: data)
////                }
//            }
//        })
//        self.socket?.on("isTyping_\(chatId)", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
//                print(" asjdkfjkl sjdlkfj klsadf isTyping_ \(data)")
////                if data.string(forKey: "sender") != self?.userId {
////                    self?.delegate?.socketTyping(self, json: data)
////                }
//            }
//        })
//        self.socket?.on("stopTyping_\(chatId)", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
//                print(" asjdkfjkl sjdlkfj klsadf stopTyping_ \(data)")
////                if data.string(forKey: "sender") != self?.userId {
////                    self?.delegate?.socketStopTyping(self, json: data)
////                }
//            }
//        })
//        self.socket?.on("isOffline_\(chatId)", callback: { data, ack in
//            print("Disconnected = ", data)
//            if let data = data[0] as? [String:Any] {
////                if data.string(forKey: "sender") != self.userId {
////                    self.delegate?.socketOffline(self, json: data)
////                }
//            }
//        })
//        self.socket?.on("receiveChatMessage_\(chatId)_\(self.userId ?? "")", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
//                print("receiveChatMessage_ json is \n\n \(data)")
//                self?.delegate?.socketMessageReceived(self, json: data)
//            }
//        })
//        self.socket?.on("isReceived_\(chatId)_\(userId ?? "")", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
////                self?.isMessageReceivedCallback?(data)
//                self?.delegate?.socketMessageReceivedStatusUpdate(self, json: data)
//            }
//        })
//        self.socket?.on("confirmReadStatus_\(chatId)_\(self.userId ?? "")", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
////                if data.string(forKey: "sender") != self?.userId {
////                    self?.delegate?.socketMessageSeen(self, json: data)
////                }
//            }
//        })
//        self.socket?.on("receiveOwnChatMessage_\(chatId)_\(self.userId ?? "")", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
//                print("own message recieved \(data)")
//                self?.delegate?.socketOwnChatMessageReceived(self, json: data)
//            }
//        })
//        self.socket?.on("deleteMessage_\(chatId)_\(self.userId ?? "")", callback: {[weak self] data, ack in
//            if let data = data[0] as? [String:Any] {
//                print("own message recieved \(data)")
//                self?.delegate?.socketOwnChatMessageReceived(self, json: data)
//            }
//        })



//    func sendMessageEvent() {
//        sendMessage (Listeners for receiver - sendMessage) {
//            senderId : _id of Sender,
//            receiverId : _id of Receiver,
//            message : Message String,
//            sentAt : Date Time (UTC Date Time)
//        }
//    }










//
//func isTypingEmit(json: JSON) {
//    print("typing json \(json)")
//    if self.socket == nil {
//        self.setupConnection()
//    }
//    self.socket?.emit(SocketEvents.isTyping.name(), json)
//}
//
//func stopTypingEmit(json:JSON) {
//    print("stop typing json \(json)")
//    if self.socket == nil {
//        self.setupConnection()
//    }
//    self.socket?.emit(SocketEvents.isStopTyping.name(), json)
//}
//
//func offlineEmit(json:JSON) {
//    print("offline json \(json)")
//    self.socket?.emit(SocketEvents.isOffline.name(), json)
//}
//
//func onlineEmit(json:JSON) {
//    print("online json \(json)")
//    self.socket?.emit(SocketEvents.isOnline.name(), json)
//}
//
//func sendBulkChatMessage(json: JSON) {
//    if self.socket == nil {
//        self.setupConnection { connected in
//            print("sendBulkChatMessage 0 \(json)   ***   ")
//            if connected {
//                print("sendBulkChatMessage  1 \(json)   *** ")
//                self.socket?.emit(SocketEvents.sendBulkChatMessage.name(), json)
//            }
//        }
//    } else {
//        if isConnected == false {
//            self.setupConnection { succes in
//                if succes {
//                    print("sendBulkChatMessage 3 \(json)   ***   ")
//                    self.socket?.emit(SocketEvents.sendBulkChatMessage.name(), json)
//                }
//            }
//        } else {
//            print("sendBulkChatMessage 4 \(json)   ***   ")
//            self.socket?.emit(SocketEvents.sendBulkChatMessage.name(), json)
//        }
//    }
//}
//
//func seenEmit(json: [String:Any]) {
//    print("seen json \(json)    \(isConnected)")
//    if self.socket == nil {
//        self.setupConnection { connected in
//            if connected {
//                self.socket?.emit(SocketEvents.confirmReadStatus.name(), json)
//            }
//        }
//    } else {
//        self.socket?.emit(SocketEvents.confirmReadStatus.name(), json)
//    }
//}
//
//func sendMessage(json: [String:Any]) {
//    print("send message json  ************** \(json)")
//    var updated = json
//    updated["timezone"] = TimeZone.current.identifier
//    if self.socket == nil {
//        self.setupConnection { connected in
//            if connected {
//                self.socket?.emit(SocketEvents.sendMessage.name(), updated)
//            }
//        }
//    } else {
//        if self.socket?.status.active == false {
//            self.establishConnection()
//        }
//        self.socket?.emit(SocketEvents.sendMessage.name(), updated)
//    }
//}
//
//func replyMessage(json: [String:Any]) {
//    if self.socket == nil {
//        self.setupConnection()
//    }
//    if self.socket?.status.active == false {
//        self.establishConnection()
//    }
//    print("reply message json  ************** \(json)")
//    self.socket?.emit(SocketEvents.replyChatMessage.name(), json)
//}
//
//func deleteMessage(json: JSON) {
//    print("typing json \(json)")
//    if self.socket == nil {
//        self.setupConnection()
//    }
//    self.socket?.emit(SocketEvents.isTyping.name(), json)
//}
//
