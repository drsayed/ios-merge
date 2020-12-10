//
//  Equatable-Extension.swift
//  myscrap
//
//  Created by MyScrap on 6/2/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


extension Array where Element: Equatable{
    mutating func removeDuplicates(){
        var result = [Element]()
        for value in self{
            if result .contains(value){
                if let index = result.index(of: value){
                    result.remove(at: index)
                }
            }
            result.append(value)
        }
        self = result
    }
}



