//
//  MenuItem.swift
//  myscrap
//
//  Created by MS1 on 10/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
enum MenuName: String{
    //case feed = "Feeds"
    case land = "Trending"
    case members = "Members"
    case companies = "Companies"
    case visitors = "Visitors"
    case nearBy = "People NearBy"
    case favourites = "Favourites"
    case news = "News"
    case market = "Market"
    case discover = "Discover"
    case prices = "Prices"
    case inviteFriends = "Invite Friends"
    case about = "About"
    case logout = "Log Out"
//    case bump = "Bumped"
    case calendar = "Calendar"
    case report = "Moderator"
    case mylisting = "My Listings"
//    case inbox = "Inbox"
}


struct MenuItem{
    
    var menuTitle: MenuName
    var imageName: String
    
    static func getMenuItes() -> [MenuItem]{
        //let feeds = MenuItem(menuTitle: .feed, imageName: "feeds")
        let land = MenuItem(menuTitle: .land, imageName: "land")
        let members = MenuItem(menuTitle: .members, imageName: "members")
        let company = MenuItem(menuTitle: .companies, imageName: "companies")
        let visitors = MenuItem(menuTitle: .visitors, imageName: "visitors")
        let nearby = MenuItem(menuTitle: .nearBy, imageName: "people_near_by")
        let favourites = MenuItem(menuTitle: .favourites, imageName: "favourites")
        let news = MenuItem(menuTitle: .news, imageName: "news")
        let discover = MenuItem(menuTitle: .discover, imageName: "discover")
        let prices = MenuItem(menuTitle: .prices, imageName: "prices")
        let inviteFriends = MenuItem(menuTitle: .inviteFriends, imageName: "invite_friends")
        let about = MenuItem(menuTitle: .about, imageName: "about")
        let logout = MenuItem(menuTitle: .logout, imageName: "logout")
//        let bumped = MenuItem(menuTitle: .bump, imageName: "bumped")
        let calendar = MenuItem(menuTitle: .calendar, imageName: "calendaricon")
        let reported = MenuItem(menuTitle: .report, imageName: "report")
        let market = MenuItem(menuTitle: .market, imageName: "market")
        let myListings = MenuItem(menuTitle: .mylisting, imageName: "market")
//        let inbox = MenuItem(menuTitle: .inbox, imageName: "news")
        
        if !AuthStatus.instance.isGuest{
            print("Moderator find : \(AuthStatus.instance.isModeraor)")
            if AuthStatus.instance.isModeraor{
                return [/*feeds*/land,prices,market,myListings,members,/*inbox,*/company,visitors,/*bumped,*/ calendar,nearby,favourites,/*news,*/discover,inviteFriends,reported,about,logout]
            }
            return [/*feeds*/land,prices,market,myListings,members,/*inbox,*/company,visitors,/*bumped,*/ calendar,nearby,favourites,/*news,*/discover , inviteFriends,about,logout]
        }
 

        return [/*feeds*/land,market,myListings,members,/*inbox,*/company,visitors,/*bumped,*/ calendar,nearby,favourites,/*news,*/discover,inviteFriends,about]
        
    }

}
