//
//  BaseViewController.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: UI Props
    let titleLabel = UILabel()
    var titleString: String {
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleLabel()
    }
    
    // MARK: Example of setting a table-view layout
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.text = titleString
        view.addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, constant: UIApplication.shared.statusBarFrame.maxY + 10)
        titleLabel.layoutToSuperview(.centerX)
    }
}
