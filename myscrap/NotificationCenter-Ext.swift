//
//  Notification-Ext.swift
//  myscrap
//
//  Created by MS1 on 9/28/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation

extension Notification.Name{
    static let startTyping = Notification.Name("startTyping")
    static let stopTyping = Notification.Name("stopTyping")
    static let userOnline = Notification.Name("userOnline")
    static let messageSeen = Notification.Name("messageSeen")
    static let messageDelivered = Notification.Name("messageDelivered")
    static let insertMessage = Notification.Name("insertedMessage")
    static let userSignedIn = Notification.Name("com.myscrap.userSignedIn")
    static let userSignedOut = Notification.Name("com.myscrap.userSignedOut")
    
    
    static let notificationCountChanged = Notification.Name("com.myscrap.notificationCountChanged")
    static let visitorsCountChanged = Notification.Name("com.myscrap.visitorsCountChanged")
    static let messageCountChanged = Notification.Name("com.myscrap.messageCountChanged")
    static let bumpCountChanged = Notification.Name("com.myscrap.bumpCountChanged")
    static let moderatorChanged = Notification.Name("com.myscrap.moderatorTriggered")
    static let profileCountChanged = Notification.Name("com.myscrap.profileCountChanged")
    
    static let locationAuthorisationChanged = Notification.Name("com.myscrap.locationAuthorizationStatusChanged")
    
    static let chatHistoryCompleted = Notification.Name("com.myscrap.chatHistory")
    
    static let memberCorDataUpdated = Notification.Name("com.myscrap.coredataMembersUpdated")
    
    static let xmppReceivedMessage = Notification.Name("com.myscrap.xmppReceivedMessage")
    static let xmppSendMessage = Notification.Name("com.myscrap.xmppSendMessage")
    
    
    static let navigate = Notification.Name("com.myscrap.navigateToConversationVC")
    
    static let conversationChatCompleted = Notification.Name("com.myscrap.conversationChatHistoryCompleted")
    
    
    static let marketListingBuyPosted = Notification.Name("com.myscrap.buyPosted")
    static let marketListingSellPosted = Notification.Name("com.myscrap.sellPosted")
    
    //Video Download notify
    static let videoDownloaded = Notification.Name("com.myscrap.feedsVideoDownload")
    //Video cell is showing in the feeds to start playing the video
    static let videoCellPlay = Notification.Name("com.myscrap.feedsVideoCellPlay")
    static let videoCellPause = Notification.Name("com.myscrap.feedsVideoCellPause")
}
