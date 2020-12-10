//
//  UserDefaults-Ext.swift
//  myscrap
//
//  Created by MS1 on 1/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


extension UserDefaults{
    
    // User defaults
    static let LOGGED_IN_KEY = "isLoggedIn"
    static let USER_ID = "userid"
    static let PROFILE_PIC = "profilepic"
    static let BIG_PROFILE_PIC = "bigProfilePic"
    static let EMAIL = "email"
    static let  MOBILE = "mobile"
    static let FIRST_NAME = "firstname"
    static let LAST_NAME = "lastname"
    static let PASSWORD = "password"
    static let XMPPJID = "com.myscrap.xmppjid"
    static let COLOR_CODE = "colorCode"
    static let IS_GUEST = "isGuest"
    static let IS_LOGGED_OUT = "isLoggedOut"                                //manually added this code for clearing all details when logged out
    static let IS_SHARED = "com.myscrap.isShared"
    static let CURRENT_USER = "currentUser"
    static let VOIP_TOKEN = "com.myscrap.voipPushKitToken"
    static let DEVICE_TOKEN = "com.myscrap.apnToken"
    static let DEVICE_UDID = "com.myscrap.apnsToken"

    static let IS_UPDATED_ONLINE = "isUpdatedOnlineStatus"
    static let NOTIFICATION_COUNT = "com.myscrap.notificationCount"
    static let VISITORS_COUNT = "com.myscrap.viewersCount"
    static let MODERATOR_COUNT = "com.myscrap.moderatorCount"
    static let BUMP_COUNT = "com.myscrap.bumpCount"
    static let MESSAGE_COUNT = "com.myscrap.messageCount"
    static let MEMBER_ALERT_NOTIFIED = "com.myscrap.MemberAlertNotified"
    static let IS_MODERATOR = "com.myscrap.isModerator"
    static let PROFILE_COUNT = "com.myscrap.profileCount"
    static let PROFILE_PERCENTAGE = "com.myscrap.profilePercentage"
    static let USER_RANK = "rank"
    static let LOG_USER_RANK = "logUserRank"
    static let LOG_SCORE = "logScore"
    static let COMPANY = "company"
    static let COMPANY_ID = "companyId"
    static let DESIGNATION = "designation"
    static let IS_NEW_USER = "com.myscrap.isNewUser"
static let COMPANY_COUNTRY_ID = "CompanyCountryID"
    
    static let CURRENT_JID = "com.myscrap.currentJID"

    static let isCoreDataCleared = "com.myscrap.isCoredataClearedv1.36"
    static let API_REGISTERED = "com.myscrap.isApiRegistered"
    static let API_KEY = "com.myscrap.apiKey"
    
    static let isLmeSubscribed = "com.myscrap.isSubscribed"
    static let lmeStatus = "com.myscrap.lmeStatus"
    static let XMPPConnEst = "com.myscrap.xmppConnEst"
    
    static let FOLLOWERS_COUNT = "followersCount"

}
