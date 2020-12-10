//
//  XMPPLoginManager.swift
//  myscrap
//
//  Created by MyScrap on 3/27/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class XMPPLoginManager{
    
    static var `default`: XMPPLoginManager = {
//        let options = XMPPLoginManager(host: "myscrap.com", domain: "s192-169-189-223.secureserver.net")
//        let options = XMPPLoginManager(host: "192.169.189.223", domain: "192.169.189.223")
        let options = XMPPLoginManager(host: "myscrap.com", domain: "myscrap.com")
        return options	
    }()
    
    var port: UInt16 = 5222
    
    var host: String
    
    var domain: String
    
    var resource: String
    
    init(host: String, domain: String) {
        self.host = host
        self.domain = domain
        self.resource = "iOS"
    }
}
