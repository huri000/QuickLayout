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
    
    // MARK: Load view programmatically
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
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
