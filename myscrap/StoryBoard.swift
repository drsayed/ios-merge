//
//  StoryBoard.swift
//  myscrap
//
//  Created by MS1 on 10/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import Foundation
struct StoryBoard{
    static let LAND = "Landing"
    static let MAIN = "Main"
    static let COMPANIES = "Companies"
    static let CHAT = "Chat"
    static let FEED = "Feed"
    static let PROFILE = "Profile"
    static let COMMENT = "Comment"
    static let POST = "POST"
    static let FAVOURITE = "Favourite"
    static let ABOUT = "About"
    static let PHOTOS = "Photos"
    static let CALENDAR = "Calendar"
    static let MARKET = "Market"
    static let EMAIL = "Email"
    static let LIVE = "LIVE"
    static let VOTE = "Vote"
}


extension UIStoryboard{
    static let LAND = UIStoryboard(name: StoryBoard.LAND, bundle: nil)
    static let MAIN = UIStoryboard(name: StoryBoard.MAIN, bundle: nil)
    static let calendar = UIStoryboard(name: StoryBoard.CALENDAR, bundle: nil)
    static let profile = UIStoryboard(name: StoryBoard.PROFILE, bundle: nil)
    static let chat = UIStoryboard(name: StoryBoard.CHAT, bundle: nil)
    static let Comment = UIStoryboard(name: StoryBoard.COMMENT, bundle: nil)
    static let Market = UIStoryboard(name: StoryBoard.MARKET, bundle: nil)
    static let Email = UIStoryboard(name: StoryBoard.EMAIL, bundle: nil)
    static let LIVE = UIStoryboard(name: StoryBoard.LIVE, bundle: nil)
    static let Vote = UIStoryboard(name: StoryBoard.VOTE, bundle: nil)
    static let Company = UIStoryboard(name: StoryBoard.COMPANIES, bundle: nil)
}


extension UIViewController{
    class var id : String{
        return String(describing: self)
    }
}

/*

enum AppStoryBoard: String{
    case Main, Chat, Comment, Companies, Favourite, POST , Profile , Photos
    
    var instance : UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyBoardId = (viewControllerClass as UIViewController.Type).StoryBoardId
        return instance.instantiateViewController(withIdentifier: storyBoardId) as! T
    }
    
}

extension UIViewController{
    
    class var StoryBoardId : String{
        return "\(self)"
    }
    
    static func instantiateFromAppStoryBoard(appStoryBoard: AppStoryBoard) -> Self {
        return appStoryBoard.viewController(viewControllerClass: self)
    }
    
}
*/
