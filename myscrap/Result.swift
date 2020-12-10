//
//  Result.swift
//  myscrap
//
//  Created by MyScrap on 5/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

enum Result<T, U> where U : Error{
    case success(T)
    case failure(U) 
}



