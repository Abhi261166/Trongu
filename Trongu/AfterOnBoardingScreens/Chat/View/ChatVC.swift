//
//  ChatVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import IQKeyboardManager
import GrowingTextView

class ChatVC: UIViewController {

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
    
    var comeFrom:String?
    
    init(roomId: String, otherUserName:String, otherUserId:String, otherUserProfileImage: String) {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        
        if roomId.count > 0 {
            self.viewModel = ChatVM(observer: self)
            self.viewModel?.roomId = roomId
            self.viewModel?.otherUserName = otherUserName
            self.viewModel?.otherUserId = otherUserId
            self.viewModel?.otherUserProfile = otherUserProfileImage
            print("room \(roomId) **** otherUserName \(otherUserName) **** otherUserId \(otherUserId)")
            print("my id \(String(describing: UserDefaultsCustom.userId))")
            
        }
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
       
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        self.chatTableView.register(UINib(nibName: "MediaTVCell", bundle: nil), forCellReuseIdentifier: "MediaTVCell")
        self.chatTableView.register(UINib(nibName: "SharePostCVC", bundle: nil), forCellReuseIdentifier: "SharePostCVC")

    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        setViewModel()
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
        
        setuserData()
        if self.viewModel == nil {
            self.viewModel = ChatVM(observer: self)
        }
        self.viewModel?.getAllMessageList()
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
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.viewModel?.apiUpdateSeenStatus()
        
    }
    
    
    @IBAction func actionSelectMedia(_ sender: UIButton) {
        
        self.txtVwMessage.resignFirstResponder()
        self.viewModel?.imagePicker.mediaType = .both
        self.viewModel?.imagePicker.setImagePicker(controller: self, delegate: self)
       
    }
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        disableButtonForHalfSecond()
        
        guard IJReachability.isConnectedToNetwork() == true else {
            Singleton.shared.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
            return
        }
        let message = (txtVwMessage.text ?? "").trim
            guard message.count > 0 else { return }
        self.viewModel?.apiSendMessages(message: message, type: 1, sender: sender)
        
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
        self.viewModel?.imageData = postImages
        
        self.viewModel?.apiSendMessagesWithImges(type: 2, sender: UIButton())
        
    }
    
    func imagePicker(_ picker: ImagePicker, didCapture data: PickerData?) {
        if let pickerData = data {
            if pickerData.id == nil || pickerData.id == "" {
                pickerData.id = pickerData.fileName
            }
            print("id is **** \(pickerData.id)")
            self.viewModel?.imageData.append(pickerData)

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
                    cell.messageLabel.text = dict?.message
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    cell.messageBGView.shadowRadius = 3
                    cell.messageBGView.shadowOpacity = 0.4
                    cell.messageLabel.textColor = .black
                    cell.timeLabel.textColor = .gray
                    cell.messageBGView.shadowOffset = CGSize(width: 0, height: 1)
                    cell.messageBGView.shadowColor = .gray
                    cell.messageBGView.backgroundColor = .white
                    cell.profileImage.isHidden = false
                    cell.profileImgTopCons.constant = 35
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile)
                }else{
                    cell.messageBGView.clipsToBounds = true
                    cell.messageLabel.text = dict?.message
                    cell.messageLabel.textColor = .white
                    cell.timeLabel.textColor = .white
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 80
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                    cell.headerStackView.isHidden = true
                    cell.messageBGView.backgroundColor = .orange
                    
                }
                
                let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                print(date)
                cell.timeLabel.text = date.dateToString(format: timeFormat)
                    return cell
                
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTVCell", for: indexPath) as? MediaTVCell
                else{return UITableViewCell()}
                
                if dict?.userID != UserDefaultsCustom.getUserData()?.id{
                    
                    switch dict?.images.count {
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
                    case 5:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "\((dict?.images.count ?? 0) - 1)"
                    default:
                        break
                    }
                    
                    
                    for i in 0...(dict?.images.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                            cell.imgFirst.setImage(image: dict?.images[i].image)
                        case 1:
                            cell.imgTwo.setImage(image: dict?.images[i].image)
                        case 2:
                            cell.imgThree.setImage(image: dict?.images[i].image)
                        case 3:
                            cell.imgFour.setImage(image: dict?.images[i].image)
                        default:
                            break
                        }
                    }
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile)
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.isHidden = false
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    
                   
                }else{
                   
                    switch dict?.images.count {
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
                    case 5:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "\((dict?.images.count ?? 0) - 1)"
                    default:
                        break
                    }
                    
                    
                    for i in 0...(dict?.images.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                            cell.imgFirst.setImage(image: dict?.images[i].image)
                        case 1:
                            cell.imgTwo.setImage(image: dict?.images[i].image)
                        case 2:
                            cell.imgThree.setImage(image: dict?.images[i].image)
                        case 3:
                            cell.imgFour.setImage(image: dict?.images[i].image)
                        default:
                            break
                        }
                    }
                    
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 80
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                    
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
                    
                    switch dict?.videos.count {
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
                        cell.lblExtraImagesCount.text = "\((dict?.images.count ?? 0) - 1)"
                    default:
                        break
                    }
                    
                    
                    for i in 0...(dict?.videos.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                            cell.imgFirst.setImage(image: dict?.images[i].image)
                        case 1:
                            cell.imgTwo.setImage(image: dict?.images[i].image)
                        case 2:
                            cell.imgThree.setImage(image: dict?.images[i].image)
                        case 3:
                            cell.imgFour.setImage(image: dict?.images[i].image)
                        default:
                            break
                        }
                    }
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile)
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.isHidden = false
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    
                   
                }else{
                   
                    switch dict?.videos.count {
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
                    case 5:
                        cell.playVideoButton.isHidden = true
                        cell.lblExtraImagesCount.text = "\((dict?.images.count ?? 0) - 1)"
                    default:
                        break
                    }
                    
                    for i in 0...(dict?.videos.count ?? 0) - 1{
                        
                        switch i {
                        case 0:
                            cell.imgFirst.setImage(image: dict?.images[i].image)
                        case 1:
                            cell.imgTwo.setImage(image: dict?.images[i].image)
                        case 2:
                            cell.imgThree.setImage(image: dict?.images[i].image)
                        case 3:
                            cell.imgFour.setImage(image: dict?.images[i].image)
                        default:
                            break
                        }
                    }
                    
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 80
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                    
                }
                
                let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                print(date)
                   cell.timeLabel.text = date.dateToString(format: timeFormat)
                   cell.secondImageView.isHidden = true
                   cell.secondView.isHidden = true
                
                    return cell
            case 4:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SharePostCVC", for: indexPath) as? SharePostCVC
                    else{return UITableViewCell()}
                
                if dict?.userID != UserDefaultsCustom.getUserData()?.id{
                    
                    if dict?.postImages?.first?.thumbnailImage != ""{
                        cell.imgPostFirstImage.setImage(image: dict?.postImages?.first?.thumbnailImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    }else{
                        cell.imgPostFirstImage.setImage(image: dict?.postImages?.first?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    }
                    
                    cell.imgPostUserImage.setImage(image: dict?.userDetails?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.lblUserName.text = dict?.userDetails?.userName
                    cell.lblPostDesc.text = ""
                    cell.profileImage.setImage(image: self.viewModel?.otherUserProfile)
                    cell.imageWidthConstraint.constant = 40
                    cell.profileImage.isHidden = false
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
                    
                }else{
                    
                    if dict?.postImages?.first?.thumbnailImage != ""{
                        cell.imgPostFirstImage.setImage(image: dict?.postImages?.first?.thumbnailImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    }else{
                        cell.imgPostFirstImage.setImage(image: dict?.postImages?.first?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    }
                    
                    cell.imgPostUserImage.setImage(image: dict?.userDetails?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
                    cell.lblUserName.text = dict?.userDetails?.userName
                    cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 80
                    cell.viewTrailingConstraint.constant = 20
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                }
                
                let date = Date(timeIntervalSince1970: TimeInterval(dict?.createdAt ?? "") ?? 0.0)
                print(date)
                cell.timeLabel.text = date.dateToString(format: timeFormat)
               
                    return cell
                
            default:
                return UITableViewCell()
            }
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    
    }


extension ChatVC: KeyboardVMObserver {
    
    func keyboard(didChange height: CGFloat, duration: Double, animation: UIView.AnimationOptions) {
        if txtVwMessage.isFirstResponder {
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
        keyboard = nil
        viewModel?.observer = nil
        viewModel = nil
        self.navigationController?.popViewController(animated: true)
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
        
    }
    
    
    func observerListMessages() {
        
        chatTableView.reloadData()
        chatTableView.tableHeaderView = nil
        scrollToBottom(isScrolled: true)
    }
    
    func observerRemoveHeader() {
        
    }
    
    func observerPreviousMessages(indexPaths: [IndexPath]) {
        
    }
    
    
}


extension ChatVC: SockettonDelegate {
    func socketMessageReceived(_ socket: Socketton?, json: JSON) {
        print("new message received \(json)")
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return }
        guard let message = DataDecoder.decodeData(data, type: MessageDetails.self) else { return }
        insertNewMessage(message: message)
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
    }
    
//    MARK: - SCROLL TO BOTTOM
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
