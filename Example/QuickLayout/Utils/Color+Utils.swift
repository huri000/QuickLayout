//
//  UIColor+Utils.swift
//  QuickLayout
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit

extension UIColor {
    static func by(rVal: Int, gVal: Int, bVal: Int, aVal: CGFloat = 1) -> UIColor {
        let dVal = CGFloat(255)
        return UIColor(red: CGFloat(rVal) / dVal, green: CGFloat(gVal) / dVal, blue: CGFloat(bVal) / dVal, alpha: aVal)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

struct QLColor {
    struct BlueGray {
        static let c25 = UIColor(rgb: 0xf2f5f7)
        static let c50 = UIColor(rgb: 0xeceff1)
        static let c100 = UIColor(rgb: 0xcfd8dc)
        static let c200 = UIColor(rgb: 0xb0bec5)
        static let c300 = UIColor(rgb: 0x90a4ae)
        static let c400 = UIColor(rgb: 0x78909c)
        static let c500 = UIColor(rgb: 0x607d8b)
        static let c600 = UIColor(rgb: 0x546e7a)
        static let c700 = UIColor(rgb: 0x455a64)
        static let c800 = UIColor(rgb: 0x37474f)
        static let c900 = UIColor(rgb: 0x263238)
        
        static let all = [QLColor.BlueGray.c300,
                          QLColor.BlueGray.c400,
                          QLColor.BlueGray.c500,
                          QLColor.BlueGray.c600,
                          QLColor.BlueGray.c600,
                          QLColor.BlueGray.c700,
                          QLColor.BlueGray.c800,
                          QLColor.BlueGray.c900]
        
        static var random: UIColor {
            return all[.random(upTo: all.count)]
        }
    }
}
