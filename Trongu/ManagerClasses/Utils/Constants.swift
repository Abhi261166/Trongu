//
//  Constants.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 30/03/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit

let SCREEN_SIZE = UIScreen.main.bounds
var statusBarStyle: UIStatusBarStyle = .lightContent


enum LOGIN_TYPE: String {
    case Email = "1"
    case Apple = "2"
    case Phone = "3"
}

struct STORYBOARD_ID {
    static let loginNavigation = "LoginNavigation"
    static let homeNavigation = "HomeNavigation"
    static let homeTabbarController = "HomeTabbarController"
    static let otpVerifyController = "OtpVerifyController"
    static let signupCompletedController = "SignupCompletedController"
    static let walkThrew2Controller = "WalkThrew2Controller"
    static let mobileSignupController = "MobileSignupController"
    static let chatListingController = "ChatListingController"
    static let profileController = "ProfileController"
    static let dashboardNavigation = "DashboardNavigation"
    static let meetingsNavigation = "MeetingNavigation"
    static let chatNavigation = "ChatNavigation"
    static let profileNavigation = "ProfileNavigation"
}

struct cellIdentifier {
    static let walkThrewCollectionCell = "WalkThrewCollectionCell"
    static let walkThrew2CollectionCell = "WalkThrew2CollectionCell"
    static let titlesCollectionCell = "TitlesCollectionCell"
    static let dashboardMeetingTableCell = "DashboardMeetingTableCell"
    static let dashboardEventsTableCell = "DashboardEventsTableCell"
    static let dashboardEventsCollectionCell = "DashboardEventsCollectionCell"
    static let dashboardQATableCell = "DashboardQATableCell"
    static let textCollectionCell = "TextCollectionCell"
    static let menuTableCell = "MenuTableCell"
    static let meetingsTableCell = "MeetingsTableCell"
    static let chatListingTableCell = "ChatListingTableCell"
    static let createMeetingTableCell = "CreateMeetingTableCell"
    static let cmAdvanceTableCell = "CMAdvanceTableCell"
    static let settingsCell = "SettingsCell"
    static let userAnalyticCell = "UserAnalyticCell"
    static let notificationsCell = "NotificationsCell"
    static let optionsTableCell = "OptionsTableCell"
    static let contactsTableCell = "ContactsTableCell"
    static let contactsCollectionCell = "ContactsCollectionCell"
    static let calendarTableCell = "CalendarTableCell"
    static let alertTableCell = "AlertTableCell"
    static let notificationSettingCell = "NotificationSettingCell"
    static let contactUsCell = "ContactUsCell"
    static let profileCell = "ProfileCell"
    static let participantCollectionCell = "ParticipantCollectionCell"
    static let participantTableCell = "ParticipantTableCell"
    static let imageCollectionCell = "ImageCollectionCell"
    
    static let documentCell = "DocumentCell"
    static let meetingDetailsTableCell = "MeetingDetailsTableCell"
    static let filesDocumentCollectionCell = "FilesDocumentCollectionCell"
    
    static let selectPollCell = "SelectPollCell"
    static let createRatePollCell = "CreateRatePollCell"
    static let createPollCell = "CreatePollCell"
    static let numberPollCell = "NumberPollCell"
    static let pollOptionsCell = "PollOptionsCell"
    static let pollsListTableCell = "PollsListTableCell"
    static let newPollListTableCell = "NewPollListTableCell"
    
    static let bottomOptionCollectionCell = "MDBottomOptionCollectionCell"
    static let taskListTableCell = "TaskListTableCell"
    static let taskTypeCollectionCell = "TaskTypeCollectionCell"
    static let taskStatusCollectionCell = "TaskStatusCollectionCell"
    static let taskDetailsTableCell = "TaskDetailsTableCell"
    static let editTaskTableCell = "EditTaskTableCell"
    
    static let notesTableCell = "NotesTableCell"
    static let expenseTableCell = "ExpenseTableCell"
    static let chatCell = "ChatCell"
    static let muteTableCell = "MuteTableCell"
    
    static let viewCountTableCell = "ViewCountTableCell"
    static let workProfileTableCell = "WorkProfileTableCell"
    static let profileDetailTableCell = "ProfileDetailTableCell"
    static let profileImagesCollectionCell = "ProfileImagesCollectionCell"
    static let editProfileTableCell = "EditProfileTableCell"
    static let addressesTableCell = "AddressesTableCell"
    static let bankDetailTableCell = "BankDetailTableCell"
    static let addBankTableCell = "AddBankTableCell"
    static let socialMediaLinkTableCell = "SocialMediaLinkTableCell"
    static let addCustomDetailTableCell = "AddCustomDetailTableCell"
    static let editShareProfileTableCell = "EditShareProfileTableCell"
     
    
    static let ticketTableViewCell = "TicketTableViewCell"
    static let eventDocumentTableCell = "EventDocumentTableCell"
    
    static let commentsTableCell = "CommentsTableCell"
    static let searchTableCell = "SearchTableCell"
    
    
    
}

struct NIB_NAME {
    static let errorView = "ErrorView"
    static let homeTableHeader = "HomeTableHeader"
    static let profileHeaderView = "ProfileHeaderView"
    static let profileSectionHeader = "ProfileSectionHeader"
    static let documentCollectionSectionView = "DocumentCollectionSectionView"
    static let createPollTableHeader = "CreatePollTableHeader"
    static let profileDetailTableHeader = "ProfileDetailTableHeader"
    static let editShareProfileHeader = "EditShareProfileHeader"
    
}

struct PlaceHolderImages{
    static let userProfilePlaceHolder = "avatar-placeholder"
    static let coverPhotoProfile = "photo-placeholder"
    
}

struct DEVICE_TYPE {
    static let appVersion = "1.0"
    
}

struct STORYBOARD {
    static let main = "Main"
    static let login = "Login"
}


struct HEIGHT {
    
    static var window: UIWindow? {
        if #available(iOS 15, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return scene.windows.first(where: {$0.isKeyWindow})
            } else {
                return nil
            }
        } else {
            return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        }
    }
    
    static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = HEIGHT.window
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    static let errorMessageHeight: CGFloat = 43.0
    static let navigationHeight: CGFloat = 190 + Self.getTopInsetofSafeArea + Self.statusBarHeight
    
    static var getTopInsetofSafeArea: CGFloat {
        guard let topInset = Self.window?.safeAreaInsetsForAllOS.top else { return 0 }
        return topInset
    }
    
    static var getBottomInsetofSafeArea: CGFloat {
        let topInset = Self.window?.safeAreaInsetsForAllOS.bottom ?? 0
        return topInset
    }
    
}

extension UINib {
    convenience public init(nibName:String) {
        self.init(nibName: nibName, bundle: nil)
    }
    
}
