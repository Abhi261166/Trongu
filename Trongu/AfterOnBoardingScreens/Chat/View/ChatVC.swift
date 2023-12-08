//
//  ChatVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import IQKeyboardManager
import GrowingTextView
import AVFoundation
import AVKit
import SDWebImage

class ChatVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelectMedia: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtVwMessage: GrowingTextView!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    
    var rightcell = ["Hey, How are you.where are you Going","Hi , am  Good."]
    var keyboardHieght : CGFloat?
    var keyboard: KeyboardVM?
    var viewModel:ChatVM?
    var socketton: Socketton?
    var clickedImage:UIImage?
    var click_Image_Data: Data?
    var timeFormat = "hh:mm a"
    var firstTimeLoadCell: Bool = true
    var comeFrom:String?
    var postId:String?
    var isCallChatListApi = true
    
    init(roomId: String, otherUserName:String, otherUserId:String, otherUserProfileImage: String) {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        
       // if roomId.count > 0 {
            self.viewModel = ChatVM(observer: self)
            self.viewModel?.roomId = roomId
            self.viewModel?.otherUserName = otherUserName
            self.viewModel?.otherUserId = otherUserId
            self.viewModel?.otherUserProfile = otherUserProfileImage
            print("room \(roomId) **** otherUserName \(otherUserName) **** otherUserId \(otherUserId)")
            print("my id \(String(describing: UserDefaultsCustom.userId))")
        
        // socket connection
//        if roomId.count > 0 {
//            guard socketton == nil else { return }
//            socketton = Socketton()
//            socketton?.delegate = self
//            socketton?.establishConnection()
//            socketton?.checkConnection(complition: { succ in
//                if succ == true {
//                    self.socketton?.conncetedChat(roomId: roomId)
//                    
//                }
//            })
//        }
     //   setSocket()
        
       // }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        print("deinit calles SingleChatController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtVwMessage.delegate = self
        setViewModel()
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        self.chatTableView.register(UINib(nibName: "MediaTVCell", bundle: nil), forCellReuseIdentifier: "MediaTVCell")
        self.chatTableView.register(UINib(nibName: "SharePostCVC", bundle: nil), forCellReuseIdentifier: "SharePostCVC")
        self.chatTableView.register(UINib(nibName: "ReplyMessageTVCell", bundle: nil), forCellReuseIdentifier: "ReplyMessageTVCell")
        self.chatTableView.register(UINib(nibName: "ReceiveMessageTVCell", bundle: nil), forCellReuseIdentifier: "ReceiveMessageTVCell")
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        
        if comeFrom == "Profile"{
            setuserData()
        }
        
        if self.viewModel?.roomId == "" || self.viewModel?.roomId == nil{
            
        }else{
            apiCall()
        }
        
        keyboard = KeyboardVM()
        keyboard?.setKeyboardNotification(self)
        setSocket()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
      //  self.viewModel?.apiUpdateSeenStatus()
        keyboard?.removeKeyboardNotification()
    }

    
    func setViewModel(){
               
        if self.viewModel == nil {
            self.viewModel = ChatVM(observer: self)
        }
        
    }
    
    func apiCall(){
        setuserData()
        if isCallChatListApi{
            self.viewModel?.chatHistory = []
            self.viewModel?.getAllMessageList()
        }
        
    }
    
    
    func setSocket() {
        guard socketton == nil else { return }
        socketton = Socketton()
        socketton?.delegate = self
        socketton?.establishConnection()
        socketton?.checkConnection(complition: { succ in
            if succ == true {
                self.socketton?.conncetedChat(roomId: self.viewModel?.roomId ?? "")
                
            }
        })
    }
    
    func setuserData(){
        
        self.imgProfile.setImage(image: self.viewModel?.otherUserProfile,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        self.lblName.text = self.viewModel?.otherUserName
        
        if comeFrom == "SharePost"{
            
            self.viewModel?.apiSendMessages(message: "", type: 4, sender: UIButton(), postId: self.postId ?? "")
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
       // self.viewModel?.apiUpdateSeenStatus()
        keyboard = nil
        viewModel?.observer = nil
        viewModel = nil
        self.isCallChatListApi = true
        
        popVC()
    }
    
    
    @IBAction func actionSelectMedia(_ sender: UIButton) {
        
        self.viewModel?.imageData = []
        
        self.txtVwMessage.resignFirstResponder()
        self.viewModel?.imagePicker.mediaType = .both
        self.viewModel?.imagePicker.setImagePicker(controller: self, delegate: self)
       
    }
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        disableButtonForHalfSecond()
     
        if txtVwMessage.text.count > 0{
            btnSendMessage.isUserInteractionEnabled = false
        }
        
        if self.viewModel?.roomId != ""{
            
            guard IJReachability.isConnectedToNetwork() == true else {
                Singleton.shared.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
                return
            }
            let message = (txtVwMessage.text ?? "").trim
                guard message.count > 0 else { return }
            self.viewModel?.apiSendMessages(message: message, type: 1, sender: sender, postId: "")
            
        }else{
            
            ChatVM.apiCreateRoom(otherUserId: self.viewModel?.otherUserId ?? "", observer: self, sender: UIButton())
            
        }
        
    }
    
    @IBAction func openOtherUserProfileAction(_ sender: UIButton) {
        
        let vc = OtherUserProfileVC()
        vc.userId = self.viewModel?.otherUserId ?? ""
        self.pushViewController(vc, true)
        
    }
    
    
    func disableButtonForHalfSecond() {
        btnSendMessage.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.btnSendMessage.isEnabled = true
        }
    }
}

extension ChatVC: ImagePickerDelegate {
    
    func imagePicker(_ picker: ImagePicker, didSelect data: [PickerData]?, assetIds: [String]) {
        print("picked images are \n\n\(data?.count) *** \n\n\(assetIds) \n\n")
        let ids = data?.map({$0.id ?? ""}) ?? []
        print("picked images are ids \n\n\(ids) \n\n")
        var postImages: [PickerData] = []
        assetIds.forEach { assetId in
            if let post = self.viewModel?.imageData.first(where: {$0.id == assetId}) {
                postImages.append(post)
            } else if let post = data?.first(where: {$0.id == assetId}) {
                postImages.append(post)
            } else if let post = self.viewModel?.imageData.first(where: {$0.imgUrlStr == assetId}) {
                postImages.append(post)
            }
        }
        print("post images are ******** \(postImages.count)")
        
        if self.viewModel?.roomId != ""{
            
            guard IJReachability.isConnectedToNetwork() == true else {
                Singleton.shared.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
                return
            }
            self.viewModel?.imageData = postImages
            if postImages.first?.fileName?.isImageType == false{
                self.viewModel?.apiSendMessagesWithVideo(type: 3, sender: UIButton())
            }else{
                self.viewModel?.apiSendMessagesWithImges(type: 2, sender: UIButton())
            }
            
        }else{
            
            ChatVM.apiCreateRoomImages(otherUserId: self.viewModel?.otherUserId ?? "", observer: self, sender: UIButton(),postImages: postImages)
            
        }
        
    }
    
    func imagePicker(_ picker: ImagePicker, didCapture data: PickerData?) {
        if let pickerData = data {
            if pickerData.id == nil || pickerData.id == "" {
                pickerData.id = pickerData.fileName
            }
            print("id is **** \(pickerData.id)")
           
            if self.viewModel?.roomId != ""{
            self.viewModel?.imageData.append(pickerData)
            if pickerData.fileName?.isImageType == false{
                self.viewModel?.apiSendMessagesWithVideo(type: 3, sender: UIButton())
            }else{
                self.viewModel?.apiSendMessagesWithImges(type: 2, sender: UIButton())
            }
            }else{
                ChatVM.apiCreateRoomCapturedImages(otherUserId: self.viewModel?.otherUserId ?? "", observer: self, sender: UIButton(),postImages: pickerData)
            }
        }
    }
    
    func imagePicker(_ picker: ImagePicker, didFinish withError: ImagePicker.Error) {
        
    }
    
}


extension ChatVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel?.chatHistory.count ?? 0

    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let dict = self.viewModel?.chatHistory[indexPath.row]
            
            switch Int(dict?.type ?? ""){
            case 1:
                
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
                    else{return UITableViewCell()}
                if dict?.userID != UserDefaultsCustom.getUserData()?.id{
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMessageTVCell", for: indexPath) as? ReceiveMessageTVCell
                    else{return UITableViewCell()}
                    
                    cell.lblMessage.text = dict?.message
//                    cell.viewLeadingConstraint.constant = 10
//                   // cell.viewTrailingConstraint.constant = 80
//                    cell.viewTrailingConstraint = cell.viewTrailingConstraint.setRelation(relation: .greaterThanOrEqual, constant: 80)
                    cell.messageBGView.shadowRadius = 3
                    cell.messageBGView.shadowOpacity = 0.4
//                    cell.messageLabel.textColor = .black
//                    cell.timeLabel.textColor = .gray
                    cell.messageBGView.shadowOffset = CGSize(width: 0, height: 1)
                    cell.messageBGView.shadowColor = .gray
                    cell.messageBGView.backgroundColor = .white
//                    cell.profileImage.isHidden = false
////                    if indexPath.row == 0 || self.viewModel?.chatHistory[indexPath.row - 1].userID == UserDefaultsCustom.getUserData()?.id{
////                        cell.profileImgTopCons.constant = 35
////                    }else{
//                        cell.profileImgTopCons.constant = 0
//                   // }
//                    cell.imageWidthConstraint.constant = 40
                    cell.imgProfile.setImage(image: self.viewModel?.otherUserProfile,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    
                    if indexPath.row == 0 {
                    cell.setDate(currentDate: dict?.createdAt, previousDate: nil)
                    }else{
                        cell.setDate(currentDate: dict?.createdAt, previousDate:  self.viewModel?.chatHistory[indexPath.row - 1].createdAt)
                    }
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                    print(date)
                    cell.lblTime.text = date.dateToString(format: timeFormat)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                        tapGesture.delegate = self
                        cell.imgProfile.addGestureRecognizer(tapGesture)
                        cell.imgProfile.isUserInteractionEnabled = true
                    
                    
                        return cell
                    
                }else{
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyMessageTVCell", for: indexPath) as? ReplyMessageTVCell
                    else{return UITableViewCell()}
                     cell.lblMessage.text = dict?.message
                    
                    cell.messageBGView.clipsToBounds = true
//                    cell.messageLabel.text = dict?.message
//                    cell.messageLabel.textColor = .white
//                    cell.timeLabel.textColor = .white
//                    cell.profileImgTopCons.constant = 0
//                    cell.viewLeadingConstraint = cell.viewLeadingConstraint.setRelation(relation: .greaterThanOrEqual, constant: 80)
//                   // cell.viewLeadingConstraint.constant = 80
//                    cell.viewTrailingConstraint.constant = 20
//                    cell.imageWidthConstraint.constant = 0
//                    cell.profileImage.isHidden = true
                    cell.messageBGView.backgroundColor = .orange
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                    print(date)
                    cell.lblTime.text = date.dateToString(format: timeFormat)
                    
                    if indexPath.row == 0 {
                    cell.setDate(currentDate: dict?.createdAt, previousDate: nil)
                    }else{
                        cell.setDate(currentDate: dict?.createdAt, previousDate:  self.viewModel?.chatHistory[indexPath.row - 1].createdAt)
                    }
                    
                        return cell
                    
                }
                
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTVCell", for: indexPath) as? MediaTVCell
                else{return UITableViewCell()}
                
                if dict?.userID != UserDefaultsCustom.getUserData()?.id{
                    
                    switch dict?.images?.count {
                    case 1:
                        cell.playVideoButton.isHidden = true
                        cell.secondImageView.isHidden = true
                        cell.secondView.isHidden = true
                    case 2:
                        cell.playVideoButton.isHidden = true
                        cell.secondView.isHidden = true
                    case 3:
                        cell.playVideoButton.isHidden = true
                        cell.ForthImageView.isHidden = true
                    case 4:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.isHidden = true
                    case 5,6,7,8,9,10:
                        cell.lblExtraImagesCount.isHidden = false
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "+\((dict?.images?.count ?? 0) - 4)"
                    default:
                        break
                    }
                    
                    for i in 0...(dict?.images?.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                          //  cell.imgFirst.setImage(image: dict?.images[i].image)
                            
                            cell.imgFirst.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgFirst.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgFirst.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                        case 1:
                           // cell.imgTwo.setImage(image: dict?.images[i].image)
                            cell.imgTwo.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgTwo.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgTwo.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                        case 2:
                           // cell.imgThree.setImage(image: dict?.images[i].image)
                            cell.imgThree.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgThree.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgThree.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                            
                        case 3:
                           // cell.imgFour.setImage(image: dict?.images[i].image)
                            cell.imgFour.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgFour.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgFour.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                            
                        default:
                            break
                        }
                    }
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.isHidden = false
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                        tapGesture.delegate = self
                        cell.profileImage.addGestureRecognizer(tapGesture)
                        cell.profileImage.isUserInteractionEnabled = true
                   
                }else{
                   
                    switch dict?.images?.count {
                    case 1:
                        cell.playVideoButton.isHidden = true
                        cell.secondImageView.isHidden = true
                        cell.secondView.isHidden = true
                    case 2:
                        cell.playVideoButton.isHidden = true
                        cell.secondView.isHidden = true
                    case 3:
                        cell.playVideoButton.isHidden = true
                        cell.ForthImageView.isHidden = true
                    case 4:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.isHidden = true
                    case 5,6,7,8,9,10:
                        cell.lblExtraImagesCount.isHidden = false
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "+\((dict?.images?.count ?? 0) - 4)"
                    default:
                        break
                    }
                    
                    for i in 0...(dict?.images?.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                           // cell.imgFirst.setImage(image: dict?.images[i].image)
                            cell.imgFirst.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgFirst.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgFirst.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                            
                        case 1:
                           // cell.imgTwo.setImage(image: dict?.images[i].image)
                            cell.imgTwo.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgTwo.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgTwo.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                            
                        case 2:
                          //  cell.imgThree.setImage(image: dict?.images[i].image)
                            cell.imgThree.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgThree.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgThree.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                            
                        case 3:
                           // cell.imgFour.setImage(image: dict?.images[i].image)
                            cell.imgFour.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.imgFour.sd_imageIndicator?.startAnimatingIndicator()
                            cell.imgFour.sd_setImage(with: URL(string: dict?.images?[i].image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                            
                        default:
                            break
                        }
                    }
                    
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 110
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                    
                }
                
                if indexPath.row == 0 {
                cell.setDate(currentDate: dict?.createdAt, previousDate: nil)
                }else{
                    cell.setDate(currentDate: dict?.createdAt, previousDate:  self.viewModel?.chatHistory[indexPath.row - 1].createdAt)
                }
                
                let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                print(date)
                cell.timeLabel.text = date.dateToString(format: timeFormat)
                cell.playVideoButton.isHidden = true
                    
                return cell
              
            case 3:
                
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTVCell", for: indexPath) as? MediaTVCell
                    else{return UITableViewCell()}
                
                if dict?.userID != UserDefaultsCustom.getUserData()?.id{
                    
                    switch dict?.videos?.count {
                    case 1:
                        cell.playVideoButton.isHidden = false
                        cell.secondImageView.isHidden = true
                        cell.secondView.isHidden = true
                    case 2:
                        cell.playVideoButton.isHidden = true
                        cell.secondView.isHidden = true
                    case 3:
                        cell.playVideoButton.isHidden = true
                        cell.ForthImageView.isHidden = true
                    case 4:
                        cell.playVideoButton.isHidden = true
                    case 5:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "\((dict?.images?.count ?? 0) - 1)"
                    default:
                        break
                    }
                    
                    
                    for i in 0...(dict?.videos?.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                            cell.imgFirst.setImage(image: dict?.videos?[i].thumbnailImage)
                        case 1:
                            cell.imgTwo.setImage(image: dict?.videos?[i].thumbnailImage)
                        case 2:
                            cell.imgThree.setImage(image: dict?.videos?[i].thumbnailImage)
                        case 3:
                            cell.imgFour.setImage(image: dict?.videos?[i].thumbnailImage)
                        default:
                            break
                        }
                    }
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.isHidden = false
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                        tapGesture.delegate = self
                        cell.profileImage.addGestureRecognizer(tapGesture)
                        cell.profileImage.isUserInteractionEnabled = true
                   
                }else{
                   
                    switch dict?.videos?.count {
                    case 1:
                        cell.playVideoButton.isHidden = false
                        cell.secondImageView.isHidden = true
                        cell.secondView.isHidden = true
                    case 2:
                        cell.playVideoButton.isHidden = true
                        cell.secondView.isHidden = true
                    case 3:
                        cell.playVideoButton.isHidden = true
                        cell.ForthImageView.isHidden = true
                    case 4:
                        cell.playVideoButton.isHidden = true
                    case 5:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "\((dict?.images?.count ?? 0) - 1)"
                    default:
                        break
                    }
                    
                    for i in 0...(dict?.videos?.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                            cell.imgFirst.setImage(image: dict?.videos?[i].thumbnailImage)
                        case 1:
                            cell.imgTwo.setImage(image: dict?.videos?[i].thumbnailImage)
                        case 2:
                            cell.imgThree.setImage(image: dict?.videos?[i].thumbnailImage)
                        case 3:
                            cell.imgFour.setImage(image: dict?.videos?[i].thumbnailImage)
                        default:
                            break
                        }
                    }
                    
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 110
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                    
                }
                
                if indexPath.row == 0 {
                cell.setDate(currentDate: dict?.createdAt, previousDate: nil)
                }else{
                    cell.setDate(currentDate: dict?.createdAt, previousDate:  self.viewModel?.chatHistory[indexPath.row - 1].createdAt)
                }
                
                let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                print(date)
                   cell.timeLabel.text = date.dateToString(format: timeFormat)
                   cell.secondImageView.isHidden = true
                   cell.secondView.isHidden = true
                
                    return cell
            case 4:
                print("In case 4")
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SharePostCVC", for: indexPath) as? SharePostCVC
                    else{return UITableViewCell()}
                
                if dict?.userID != UserDefaultsCustom.getUserData()?.id{
                    
                    if dict?.post?.postImages?.thumb_nail_image != ""{
                        
                        cell.imgPostFirstImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgPostFirstImage.sd_imageIndicator?.startAnimatingIndicator()
                        cell.imgPostFirstImage.sd_setImage(with: URL(string: dict?.post?.postImages?.thumb_nail_image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                      
                    }else{
                        cell.imgPostFirstImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgPostFirstImage.sd_imageIndicator?.startAnimatingIndicator()
                        cell.imgPostFirstImage.sd_setImage(with: URL(string: dict?.post?.postImages?.image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                      
                    }
                    
                    
                    cell.imgPostUserImage.setImage(image: dict?.post?.userDetails?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.lblUserName.text = dict?.post?.userDetails?.name
                    cell.lblPostDesc.text = ""
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.isHidden = false
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                        tapGesture.delegate = self
                        cell.profileImage.addGestureRecognizer(tapGesture)
                        cell.profileImage.isUserInteractionEnabled = true
                    
                }else{
                    
                    if dict?.post?.postImages?.thumb_nail_image != ""{
                        
                        cell.imgPostFirstImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgPostFirstImage.sd_imageIndicator?.startAnimatingIndicator()
                        cell.imgPostFirstImage.sd_setImage(with: URL(string: dict?.post?.postImages?.thumb_nail_image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                
                    }else{
                        
                        cell.imgPostFirstImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgPostFirstImage.sd_imageIndicator?.startAnimatingIndicator()
                        cell.imgPostFirstImage.sd_setImage(with: URL(string: dict?.post?.postImages?.image ?? ""), placeholderImage: UIImage(named: ""), context: nil)
                        
                     //   cell.imgPostFirstImage.setImage(image: dict?.postImages?.first?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    }
                    
                    cell.imgPostUserImage.setImage(image: dict?.post?.userDetails?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.lblUserName.text = dict?.post?.userDetails?.name
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 110
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                }
                
                if indexPath.row == 0 {
                cell.setDate(currentDate: dict?.createdAt, previousDate: nil)
                }else{
                    cell.setDate(currentDate: dict?.createdAt, previousDate:  self.viewModel?.chatHistory[indexPath.row - 1].createdAt)
                }
                
                let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                print(date)
                cell.timeLabel.text = date.dateToString(format: timeFormat)
               
                return cell
                
            default:
                return UITableViewCell()
            }
            
        }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.viewModel?.chatHistory[indexPath.row]
        
        let type = Int(dict?.type ?? "")
        
        switch type {
        case 1:
            print("Message Type")
        case 2:
            print("Image Type")
            let vc = PhotosDetailsVC()
          
            vc.completion = {
                self.isCallChatListApi = false
            }
            
            vc.arrPhotos = dict?.images ?? []
            self.pushViewController(vc, true)
            
        case 3:
            print("Video Type")
            let videoURL = URL(string: dict?.videos?.first?.video ?? "")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
            
        case 4:
            print("Post Type")
            let vc = DetailVC()
            
            vc.completion = {
                self.isCallChatListApi = false
            }
            
            vc.comeFrom = "bucket"
            vc.postId = dict?.postID
            self.pushViewController(vc, true)
            
        default:
            break
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard self.viewModel?.pageCompleted == false else {return}
        guard self.viewModel?.updating == false else {return}
        guard self.firstTimeLoadCell == false else {
            self.firstTimeLoadCell = false
            return}
        if indexPath.row == 0 {
            self.checkHeaderAnimation(row: indexPath.row)
            print("pageNo---",self.viewModel?.page_no ?? 0)
            self.viewModel?.getAllMessageList()
        }
        
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    
    
    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        if let tappedImageView = gesture.view as? UIImageView {
            // Handle the tap on the image view
            print("Image tapped in cell at index \(tappedImageView.tag)")
        
            let vc = OtherUserProfileVC()
            vc.userId = self.viewModel?.otherUserId ?? ""
            self.pushViewController(vc, true)
            
        }
    }
    
    
    func checkHeaderAnimation(row: Int) {
        guard self.viewModel?.pageCompleted == false else {return}
        if row == 0 {
            self.chatTableView.tableHeaderView = self.activityHeaderView()
        } else {
            self.chatTableView.tableHeaderView = nil
        }
    }
    
    func activityHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 60))
        let activityIndigator = UIActivityIndicatorView(style: .medium)
        activityIndigator.frame = CGRect(x: 0, y: 15, width: SCREEN_SIZE.width, height: 30)
        activityIndigator.startAnimating()
        headerView.addSubview(activityIndigator)
        return headerView
    }
    
    }


extension ChatVC: KeyboardVMObserver {
    
    func keyboard(didChange height: CGFloat, duration: Double, animation: UIView.AnimationOptions) {
        if txtVwMessage.isFirstResponder {
            chatTableView.scrollToBottom
            if bottomCons.constant == height {
                return
            }
        } else {
            if bottomCons.constant == 0 {
                return
            }
        }
        print("height is \(height)")
        self.bottomCons.constant = height
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { finished in
           // self.scrollToBottom(isScrolled: false)
        })
    }
    

}

//MARK: - UITextFiled Delegate Methods -
extension ChatVC:UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}


extension ChatVC:ChatVMObserver{
    
    func updateSeenStatus() {
//        keyboard = nil
//        viewModel?.observer = nil
//        viewModel = nil
//        self.isCallChatListApi = true
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    func observerSendMessages(json: [String : Any], message: MessageDetails) {
        
        insertNewMessage(message: message)
        scrollToBottom(isScrolled: true)
        btnSendMessage.isSelected = true
        btnSendMessage.isEnabled = true
        txtVwMessage.text = nil
        print("send message is \(json) ***** \(self.socketton == nil)")
        socketton?.sendMessage(json, roomId: self.viewModel?.roomId ?? "")
        self.chatTableView.tableHeaderView = nil
        self.comeFrom = ""
        btnSendMessage.isUserInteractionEnabled = true
    }
    
    func observerListMessages(image: String) {
        
        self.viewModel?.apiUpdateSeenStatus()
        
        if viewModel?.otherUserProfile == ""{
            viewModel?.otherUserProfile = image
            self.imgProfile.setImage(image: image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        }
        
        isCallChatListApi = false
        chatTableView.reloadData()
        chatTableView.tableHeaderView = nil
        scrollToBottom(isScrolled: true)
    }
    
    func observerPreviousMessages(indexPaths:[IndexPath]) {
        
//        chatTable.beginUpdates()
//        chatTable.insertRows(at: indexPaths, with: .top)
//        chatTable.endUpdates()
        
        firstTimeLoadCell = true
        chatTableView.reloadData()
        if indexPaths.count > 1 {
            let last = indexPaths[indexPaths.count-1]
            chatTableView.scrollToRow(at: last, at: .top, animated: false)
            firstTimeLoadCell = false
        } else
        if let last = indexPaths.last {
            chatTableView.scrollToRow(at: last, at: .top, animated: false)
            firstTimeLoadCell = false
        }
        chatTableView.tableHeaderView = nil
    }
    
    func observerRemoveHeader() {
        chatTableView.tableHeaderView = nil
    }
    
}


extension ChatVC: SockettonDelegate {
    func socketMessageReceived(_ socket: Socketton?, json: JSON) {
        print("new message received \(json)")
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return }
        guard let message = DataDecoder.decodeData(data, type: MessageDetails.self) else { return }
        insertNewMessage(message: message)
        self.viewModel?.apiUpdateSeenStatus()
        self.scrollToBottom(isScrolled: false)
    }
    
    func socketConnected(_ socket: Socketton?) {
        
    }
    
//    MARK: - INSERT NEW MESSAGE
    func insertNewMessage(message: MessageDetails) {
        viewModel?.chatHistory.append(message)
        guard let count = self.viewModel?.chatHistory.count else { return }
        let indexPath = IndexPath(row: count-1, section: 0)
        chatTableView.beginUpdates()
        chatTableView.insertRows(at: [indexPath], with: .bottom)
        chatTableView.endUpdates()
       // btnSendMessage.isUserInteractionEnabled = true
    }
    
//    MARK: - SCROLL TO BOTTOM -
    func scrollToBottom(isScrolled:Bool) {
        guard isTableScrolled() == false || isScrolled == true  else { return }
        guard let count = self.viewModel?.chatHistory.count,
              count > 0  else { return }
        let section = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
            let indexPath = IndexPath(row: count - 1, section: section)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func isTableScrolled() -> Bool {
        return (self.chatTableView.contentOffset.y < (self.chatTableView.contentSize.height - SCREEN_SIZE.height))
    }
    
}

extension ChatVC: CreateRoomObserver{
    
    func observeCreateRoom(model: ChatUserData, sender: UIButton?) {
        guard IJReachability.isConnectedToNetwork() == true else {
            Singleton.shared.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
            return
        }
        self.viewModel?.roomId = model.roomID
        let message = (txtVwMessage.text ?? "").trim
            guard message.count > 0 else { return }
        self.viewModel?.apiSendMessages(message: message, type: 1, sender: UIButton(), postId: "")
    }
    
}

extension ChatVC:CreateRoomObserverImages{
    func observeCreateRoomImages(model: ChatUserData, sender: UIButton?, postImages: [PickerData]) {
        self.viewModel?.roomId = model.roomID
        
        self.viewModel?.imageData = postImages
        
        if postImages.first?.fileName?.isImageType == false{
            
            self.viewModel?.apiSendMessagesWithVideo(type: 3, sender: UIButton())
            
        }else{
            self.viewModel?.apiSendMessagesWithImges(type: 2, sender: UIButton())
        }
    }
       
}

extension ChatVC:CreateRoomObserverCapturedImages{
    
    func observeCreateRoomCapturedImages(model: ChatUserData, sender: UIButton?, postImages: PickerData?) {
        
        self.viewModel?.roomId = model.roomID
        self.viewModel?.imageData.append(postImages!)
        if postImages?.fileName?.isImageType == false{
            
            self.viewModel?.apiSendMessagesWithVideo(type: 3, sender: UIButton())
            
        }else{
            
            self.viewModel?.apiSendMessagesWithImges(type: 2, sender: UIButton())
            
        }
        
    }
    
}
