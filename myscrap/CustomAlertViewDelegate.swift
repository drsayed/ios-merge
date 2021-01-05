//
//  CustomAlertViewDelegate.swift
//  myscrap
//
//  Created by MyScrap on 7/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import Foundation

protocol CustomAlertViewDelegate: class {
    func okButtonTapped(selectedOption: String, textFieldValue: String)
    func cancelButtonTapped()
}
protocol EndLiveViewDelegate: class {
    func okEndLiveButtonTapped(selectedOption: String, textFieldValue: String)
    func cancelEndLiveButtonTapped()
}
