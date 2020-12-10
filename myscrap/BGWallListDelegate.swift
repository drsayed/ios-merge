//
//  BGWallListDelegate.swift
//  myscrap
//
//  Created by MyScrap on 7/8/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol BGWallListDelegate: class {
    func uploadDone(status: Bool)
    func getBGWall(image: String)
    func cancelButtonTapped()
}
