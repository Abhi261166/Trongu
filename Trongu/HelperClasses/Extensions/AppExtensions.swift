//
//  AppExtensions.swift
//  QIA
//
//  Created by Dharmani Apps mini on 10/26/21.
//

import Foundation
import UIKit


//MARK:  UIApplication

extension UIApplication {
    
    class func topViewController(base: UIViewController? = AppDelegate().window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension UIViewController {
    func popActionAlert(title:String,message:String,actionTitle:[String],actionStyle:[UIAlertAction.Style],action:[(UIAlertAction) -> Void]){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        for (index,title) in actionTitle.enumerated(){
            let action = UIAlertAction.init(title: title, style: actionStyle[index], handler: action[index])
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        self.present(alert, animated: true, completion: nil)
    }

}

//------------------------------------------------------
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
//MARK:  Dictionary

extension Dictionary {
    
    private var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    public func dict2json() -> String {
        return json
    }
    
    public func toData() -> Data? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}

//------------------------------------------------------

// MARK: - UIView

extension UIView {
    
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
    
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
    
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.borderColor = color.cgColor
//            } else {
//                layer.borderColor = nil
//            }
//        }
//    }
    @IBInspectable
    var buttonColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
//    @IBInspectable
//    var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
    
//    @IBInspectable
//    var shadowColor: UIColor? {
//        get {
//            if let color = layer.shadowColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.shadowColor = color.cgColor
//            } else {
//                layer.shadowColor = nil
//            }
//        }
//    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func toImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func defaultShaddow() {
        
        self.layoutIfNeeded()
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//------------------------------------------------------

//MARK:  String

extension String {
    
    public func toTrim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func toDictionary() -> [AnyHashable: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
    func random(length:Int)->String{
           let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
           var randomString = ""
           
           while randomString.utf8.count < length{
               let randomLetter = letters.randomElement()
               randomString += randomLetter?.description ?? ""
           }
           return randomString
       }
    
    func emailValid() {
        var isValidEmail: Bool {
            NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
        }
        
    }
    
    
    
    
}

//------------------------------------------------------

//MARK:  Data

//extension Data {
//
//    var hexStrings: String {
//        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
//        return hexString
//    }
//}



//------------------------------------------------------

//MARK:  UITabBarController

extension UITabBarController {
    func orderedTabBarItemViews() -> [UIView] {
        let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
        return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
    }
}

//------------------------------------------------------

//MARK:  UIImage

extension UIImage {
    
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func resizedImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
//        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

//------------------------------------------------------


extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
    
    func generateRandomStringWithLength(length: Int) -> String {
        let randomString: NSMutableString = NSMutableString(capacity: length)
        let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var i: Int = 0

        while i < length {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            i += 1
        }
        return String(randomString)
    }
    
    
    public var isImageType: Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif", "jpeg", "heic","HEIC"]
        let extensi = NSString(string: self).pathExtension.lowercased()
        return imageFormats.contains(extensi.lowercased())
    }
    
    func convertTimeStampToDate(dateVal : Double,dateFormate:String) -> String {
        let timeinterval = TimeInterval(dateVal)
        let dateFromServer = Date(timeIntervalSince1970:timeinterval)
        print(dateFromServer)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = .current
        dateFormater.dateFormat = dateFormate//"hh:mm"
        return dateFormater.string(from: dateFromServer)
    }
    
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: 0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = nil
        self.layer.mask = mask
    }
}

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
    


      var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
       }

    
    
    
}


extension UIImageView {
    func setRounded() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
    
    
    func imageWith(name: String?,bgColor:UIColor? = UIColor(named:"Neutral_600"))->UIImage? {
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        //        nameLabel.applyGradient(colours: [.red,.green], locations: [0.5,1])
        nameLabel.backgroundColor = bgColor
        nameLabel.setLabel("", UIColor.white, FONT_NAMEs.Amazon_Ember_Medium, 24)
        guard let firstLetter = name?.prefix(1),firstLetter != " " else{return UIImage()}
        nameLabel.text = "\(firstLetter.uppercased())"
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            self.image = nameImage
            return nameImage
        }else{
            return UIImage()
        }
    }
}
extension UIView {
    func setRound() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
    
    
}
extension UIViewController {
    
//    func convertTimeStampDate(dateVal : Double,dateFormate:String) -> String{
//        let timeinterval = TimeInterval(dateVal)
//        let dateFromServer = Date(timeIntervalSince1970:timeinterval)
//        print(dateFromServer)
//        let dateFormater = DateFormatter()
//        dateFormater.timeZone = .current
//        dateFormater.dateFormat = dateFormate//"hh:mm"
//        return dateFormater.string(from: dateFromServer)
//    }
    
}

extension NSObject {
    func convertTimeStampDate(dateVal : Double,dateFormate:String) -> String{
        let timeinterval = TimeInterval(dateVal)
        let dateFromServer = Date(timeIntervalSince1970:timeinterval)
        print(dateFromServer)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = .current
        dateFormater.dateFormat = dateFormate//"hh:mm"
        return dateFormater.string(from: dateFromServer)
    }
    
    
    func postDeletedPopup(vc: UIViewController?) {
        let alert = UIAlertController(title: "CloutLyfe", message: "This post is removed", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(alertAction)
        vc?.present(alert, true)
    }
    
    func userDeletedPopup(vc: UIViewController?) {
        let alert = UIAlertController(title: "CloutLyfe", message: "This user is no longer available.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(alertAction)
        vc?.present(alert, true)
    }
    
}


// MARK:- UIFONT EXTENTION
extension UIFont {
    
    static func setCustom(_ font: FONT_NAMEs, _ size:CGFloat) -> UIFont {
        if let font = UIFont(name: font.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    convenience init?(_ font: FONT_NAMEs, _ size:CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
    
    class func fontFamilie() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
}

//MARK:  UIImageView

extension UIImageView {
    
    func circle() {
        self.contentMode = .scaleToFill
        self.layer.cornerRadius = bounds.height/2
        shadowOffset = .zero
        //        shadowColor = FGColor.appBlack
//        shadowOpacity = QLSettings.shadowOpacity
    }
}


extension UIImageView {
    public func roundCornersLeft(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
extension UILabel {
    func addTrailing(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])
        
        string.append(attachmentString)
        self.attributedText = string
    }
    
    func addLeading(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        
        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
    
    func setLabel(_ text:String?, _ color:UIColor?, _ font:FONT_NAMEs = .Amazon_Ember_Medium, _ size: CGFloat = 12) {
        self.textColor = color ?? UIColor.black
        self.text = text
        self.font = UIFont.setCustom(font, size)
    }
    
    
}
extension UITableView {
    
    func indexPathExists(indexPath:IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    }
    
    func tableHeaders(with view:UIView) {
        let headerView = UIView()
        headerView.viewWithTag(0)
        headerView.frame = view.bounds
        headerView.addSubview(view)
        self.tableHeaderView = headerView
    }
}
//------------------------------------------------------

//MARK:  Date & Time (TimeAgo display)


extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}

extension UIColor {
    
    convenience init(hexStrings: String, alpha: CGFloat = 1.0) {
          let hexString: String = hexStrings.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
          let scanner = Scanner(string: hexString)
          if (hexString.hasPrefix("#")) {
              scanner.scanLocation = 1
          }
          var color: UInt32 = 0
          scanner.scanHexInt32(&color)
          let mask = 0x000000FF
          let r = Int(color >> 16) & mask
          let g = Int(color >> 8) & mask
          let b = Int(color) & mask
          let red   = CGFloat(r) / 255.0
          let green = CGFloat(g) / 255.0
          let blue  = CGFloat(b) / 255.0
          self.init(red:red, green:green, blue:blue, alpha:alpha)
      }
    
    convenience public init(re: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
            self.init(red: re/255, green: g/255, blue: b/255, alpha: a)
        }
}

///MARK   NSLAYOUT CONSTRAINT
extension NSLayoutConstraint {
    func setRelation(relations:NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    func setFirstItems(firstItem:AnyObject?) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    func setSecondItems(secondItem:AnyObject?) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    func setRelations(relation: NSLayoutConstraint.Relation, constant:CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
