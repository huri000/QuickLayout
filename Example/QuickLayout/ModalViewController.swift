//
//  ModalViewController.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class ModalViewController: BaseViewController {
    private let dismissButton = UIButton()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        setupDismissButton()
    }
    
    private func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        dismissButton.setImage(UIImage(named: "close_icon"), for: .normal)
        dismissButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        dismissButton.layout(to: .centerY, of: titleLabel)
        dismissButton.layoutToSuperview(.left)
    }
    
    @objc func dismissButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
