//
//  ThumbView.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import QuickLayout

class ThumbView: UIView {
        
    private let initialsLabel = UILabel()
    var name: String = "" {
        didSet {
            initialsLabel.text = String(name.first!)
        }
    }
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = QLColor.BlueGray.random
        initialsLabel.font = MainFont.light.with(size: 20)
        initialsLabel.textColor = .white
        addSubview(initialsLabel)
        initialsLabel.centerInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
    }
}
