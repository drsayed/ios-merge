//
//  SceneDelegate.swift
//  myscrap
//
//  Created by MyScrap on 30/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//Scene delegate for ipad split screen

import Foundation
import UIKit
/*
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // ...
    var window: UIWindow?
    
    /*func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //Using the storyboard so will not use thid function
    }*/
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
      guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else {
          return
        }
        print(url.absoluteString)
        //handle url and open whatever page you want to open.
        let urlPath : String = url.path
        let urlHost : String = url.host!
        
        if(urlHost != "myscrap.com")
        {
            print("Host is not correct")
        }
        
        if urlPath.contains("/ms/market/") {
            
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/ms/market/")
            
            let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
            
            let trimMarket = market.replacingOccurrences(of: "/ms/market/", with: "")
            var decodedListId = ""
            print("Trim listing id : \(decodedListId)")
            
            if AuthStatus.instance.isLoggedIn {
                if trimMarket.fromBase64() == nil {
                    decodedListId = trimMarket
                } else {
                    decodedListId = trimMarket.fromBase64()!
                }
                let marketvc = DetailListingOfferVC.controllerInstance(with: decodedListId, with1: "")
                //let vc = FeedsVC.storyBoardInstance()!
                let vc = MarketVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                setRootViewController(mainRevealController)
                frontNavigationController.pushViewController(marketvc, animated: true)
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        } else if urlPath.contains("/ms/feedpost/") {
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/ms/feedpost/")
            
            let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
            
            let trimMarket = market.replacingOccurrences(of: "/ms/feedpost/", with: "")
            var decodedListId = ""
            
            
            if AuthStatus.instance.isLoggedIn {
                if trimMarket.fromBase64() == nil {
                    decodedListId = trimMarket
                    print("Trim post id : \(decodedListId)")
                } else {
                    decodedListId = trimMarket.fromBase64()!
                    print("Trim post id : \(decodedListId)")
                }
                let marketvc = DetailsVC.controllerInstance(postId: decodedListId)
                //let vc = MarketVC.storyBoardInstance()!
                let vc = FeedsVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                setRootViewController(mainRevealController)
                frontNavigationController.pushViewController(marketvc, animated: true)
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        } else if urlPath.contains("/ms/video/") {
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/ms/video/")
            
            let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
            
            let trimMarket = market.replacingOccurrences(of: "/ms/video/", with: "")
            var decodedListId = ""
            
            
            if AuthStatus.instance.isLoggedIn {
                if trimMarket.fromBase64() == nil {
                    decodedListId = trimMarket
                    print("Trim post id : \(decodedListId)")
                } else {
                    decodedListId = trimMarket.fromBase64()!
                    print("Trim post id : \(decodedListId)")
                }
                let marketvc = DetailsVC.controllerInstance(postId: decodedListId)
                //let vc = MarketVC.storyBoardInstance()!
                let vc = FeedsVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                setRootViewController(mainRevealController)
                frontNavigationController.pushViewController(marketvc, animated: true)
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        }
        else if urlPath.contains("/msmonthcompany/") {
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/msmonthcompany/")
            
            let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
            
            let trimMarket = market.replacingOccurrences(of: "/msmonthcompany/", with: "")
            var decodedListId = ""
            
            
            if AuthStatus.instance.isLoggedIn {
                if trimMarket.fromBase64() == nil {
                    decodedListId = trimMarket
                    print("Trim company of month id : \(decodedListId)")
                } else {
                    decodedListId = trimMarket.fromBase64()!
                    print("Trim company of month id : \(decodedListId)")
                }
                let marketvc = FeedsCMDetailsVC.controllerInstance(cmId: decodedListId)
                let vc = FeedsVC.storyBoardInstance()!
                //let vc = MarketVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                setRootViewController(mainRevealController)
                frontNavigationController.pushViewController(marketvc, animated: true)
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        } else if urlPath.contains("/msweekperson/") {
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/msweekperson/")
            
            let market = urlValue[listRange!.lowerBound..<urlValue.endIndex]
            
            let trimMarket = market.replacingOccurrences(of: "/msweekperson/", with: "")
            var decodedListId = ""
            
            
            if AuthStatus.instance.isLoggedIn {
                if trimMarket.fromBase64() == nil {
                    decodedListId = trimMarket
                    print("Trim person of pow id : \(decodedListId)")
                } else {
                    decodedListId = trimMarket.fromBase64()!
                    print("Trim person of pow id : \(decodedListId)")
                }
                let marketvc = FeedsPOWDetailsVC.controllerInstance(powId: decodedListId)
                let vc = FeedsVC.storyBoardInstance()!
                //let vc = MarketVC.storyBoardInstance()!
                let rearViewController = MenuTVC()
                let frontNavigationController = UINavigationController(rootViewController: vc)
                let mainRevealController = SWRevealViewController()
                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                setRootViewController(mainRevealController)
                frontNavigationController.pushViewController(marketvc, animated: true)
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        } else if urlPath.contains("/ms/vote/") {
            let urlValue = urlPath
            
            let listRange = urlValue.range(of: "/ms/vote/")
            
            let voteRange = urlValue[listRange!.lowerBound..<urlValue.endIndex]
            
            let trimVote = voteRange.replacingOccurrences(of: "/ms/vote/", with: "")
            var decodedListId = ""
            
            
            if AuthStatus.instance.isLoggedIn {
                if urlValue.contains("/ms/vote/poll") {
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Vote", bundle: nil)
                    let homePage = mainStoryboard.instantiateViewController(withIdentifier: "VoterPollScreenVC") as! VoterPollScreenVC
                    homePage.voterId = decodedListId
                    
                    let vc = FeedsVC.storyBoardInstance()!
                    //let vc = MarketVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(homePage, animated: true)
                } else {
                    if trimVote.fromBase64() == nil {
                        decodedListId = trimVote
                        print("Trim voter id without base64: \(decodedListId)")
                    } else {
                        decodedListId = trimVote.fromBase64()!
                        print("Trim voter id decoded : \(decodedListId)")
                    }
                    /*let marketvc = ViewBioVoteVC.controllerInstance(voterId: decodedListId)
                    let vc = FeedsVC.storyBoardInstance()!
                    //let vc = MarketVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(marketvc, animated: true)*/
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Vote", bundle: nil)
                    let homePage = mainStoryboard.instantiateViewController(withIdentifier: "ViewBioVoteVC") as! ViewBioVoteVC
                    homePage.voterId = decodedListId
                    
                    let vc = FeedsVC.storyBoardInstance()!
                    //let vc = MarketVC.storyBoardInstance()!
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    setRootViewController(mainRevealController)
                    frontNavigationController.pushViewController(homePage, animated: true)
                    //self.window?.rootViewController = nav
                }
                
            } else {
                setRootViewController(SignInViewController.storyBoardInstance()!)
            }
        }
        self.window?.makeKeyAndVisible()
    }
    
    func setRootViewController(_ viewController: UIViewController){
        window?.rootViewController = viewController
    }
}
*/

