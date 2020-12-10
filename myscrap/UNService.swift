//
//  UNService.swift
//  myscrap
//
//  Created by MS1 on 2/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import UserNotifications

final class UNService : NSObject {
    
    private override init() { }
    
    static let instance = UNService()
    
    
    private let unCenter = UNUserNotificationCenter.current()
    
    func authorize(){
        let options : UNAuthorizationOptions = [.alert, .badge, .sound , .carPlay]
        unCenter.requestAuthorization(options: options) { [weak self] (granted, error) in
            guard granted else { return }
            self?.getNotificationSettings()
            self?.configure()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func configure(){
        self.unCenter.delegate = self
    }
    
}

extension UNService : UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {

            // Delivers a notification to an app running in the foreground.
        }
}
