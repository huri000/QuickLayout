//
//  Utils.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/19/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// MARK: Extensions (Used in file scope)
extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

extension Int {
    static var random: Int {
        return Int.random(n: Int.max)
    }
    
    static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1)
    }
}

extension String {
    static func random(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}

extension UIColor {
    static var satPink: UIColor {
        return UIColor(red: 1, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1)
    }
    
    static var satBlue: UIColor {
        return UIColor(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
}

