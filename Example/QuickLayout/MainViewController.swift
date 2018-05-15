//
//  ViewController.swift
//  QuickLayout
//
//  Created by Daniel Huri on 11/19/2017.
//  Copyright (c) 2017 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

// MARK: UI Example
class MainViewController: UIViewController {
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        navigationItem.title = "Samples"
        setupBottomButtons()
    }
        
    // MARK: Example of setting a buttons layout
    private func setupBottomButtons() {
        
        let contentView = UIView()
        view.addSubview(contentView)
        
        let buttonsAttributes = [(color: QLColor.BlueGray.c400, title: "Scroll View", action: #selector(scrollButtonPressed)),
                                 (color: QLColor.BlueGray.c400, title: "Table View", action: #selector(tableButtonPressed)),
                                 (color: QLColor.BlueGray.c400, title: "Vertigo", action: #selector(vertigoButtonPressed))]
        let buttons = buttonsAttributes.map { attributes -> UIButton in
            let (color, title, action) = attributes
            let button = FocusableButton()
            button.backgroundColor = color
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: action, for: .primaryActionTriggered)
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
            contentView.addSubview(button)
            return button
        }
        
        // MARK: Quick Layout Part Goes Here! - Only 4 lines of code to spread any array of child views within a parent view
        
        // Layout contentView to superview horizontally with 20pts offset from each side
        contentView.layoutToSuperview(axis: .horizontally, offset: 20)
        contentView.layoutToSuperview(.centerY)
        
        // Align each to the left of it's superview
        buttons.layoutToSuperview(axis: .horizontally)
        
        // Align all vertically (equal distribution)
        buttons.spread(.vertically, stretchEdgesToSuperview: true, offset: 8)
    }
    
    // MARK: Actions
    
    @objc func vertigoButtonPressed() {
        navigationController!.pushViewController(VertigoViewController(), animated: true)
    }
    
    @objc func scrollButtonPressed() {
        navigationController!.pushViewController(ScrollSampleViewController(), animated: true)
    }
    
    @objc func tableButtonPressed() {
        navigationController!.pushViewController(TableSampleViewController(), animated: true)
    }
}
