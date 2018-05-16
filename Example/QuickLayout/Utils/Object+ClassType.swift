//
//  Object+ClassType.swift
//  SwiftEntryKit_Example
//
//  Created by Daniel Huri on 4/25/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import Foundation

extension NSObject {
    var classType: String {
        return String(describing: type(of: self))
    }
    
    class var classType: String {
        return String(describing: self)
    }
}
