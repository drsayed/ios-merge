//
//  StackOverflowFile.swift
//  myscrap
//
//  Created by MyScrap on 8/9/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
public class ServiceOperation{ }
public struct SignInRequest {
    let email: String
    let password: String
}
public class  SignInItem : UIViewController{
    
    @IBOutlet weak var label : FrameWorkLabel!
    //or
    let label1 = FrameWorkLabel()
    
    @IBOutlet weak var textField : FrameWorkTextField!
    
    let textField1 = FrameWorkTextField()
    
    
    
}

class FrameWorkLabel: UILabel{
    
}


class FrameWorkTextField: UITextField{
    
}

let label = FrameWorkLabel()




