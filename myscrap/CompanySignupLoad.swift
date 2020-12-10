//
//  CompanySignupLoad.swift
//  myscrap
//
//  Created by MyScrap on 12/12/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation
import RealmSwift

class CompanySignupLoad : Object {
    @objc dynamic var key_id = 1
    @objc dynamic var companyKey = "companySignup"
    @objc dynamic var companyString = ""
    
    
    static func create() -> CompanySignupLoad {
        let companyData = CompanySignupLoad()
        //feedData.key_id = lastId()
        return companyData
    }
}
