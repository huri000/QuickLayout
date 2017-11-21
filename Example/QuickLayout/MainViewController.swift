//
//  ViewController.swift
//  QuickLayout
//
//  Created by Daniel Huri on 11/19/2017.
//  Copyright (c) 2017 Daniel Huri. All rights reserved.
//

import UIKit

// MARK: UI Example
class MainViewController: BaseViewController {
    
    override var titleString: String {
        return "QuickLayout Example App"
    }
    
    // MARK: UI Props
    private let leftBottomButton = UIButton()
    private let rightBottomButton = UIButton()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomButtons()
    }
        
    // MARK: Example of setting a buttons layout
    private func setupBottomButtons() {
        
        let sideMargin: CGFloat = 20
        let bottomMargin: CGFloat = 30
        let height: CGFloat = 50
        
        leftBottomButton.backgroundColor = .gray
        leftBottomButton.setTitle("Left Button", for: .normal)
        view.addSubview(leftBottomButton)
        
        rightBottomButton.backgroundColor = .gray
        rightBottomButton.setTitle("Right Button", for: .normal)
        view.addSubview(rightBottomButton)
        
        // Align leftBottomButton to the left of it's superview
        leftBottomButton.layoutToSuperview(.left, constant: sideMargin)
        
        // Align leftBottomButton's right to centerX of it's superview, with constant distance
        leftBottomButton.layout(.right, to: .centerX, of: leftBottomButton.superview!, constant: -sideMargin * 0.5)
        
        // Align rightBottomButton to the right of it's superview
        rightBottomButton.layoutToSuperview(.right, constant: -sideMargin)
        
        // Align rightBottomButton's left to centerX of it's superview, with constant distance
        rightBottomButton.layout(.left, to: .centerX, of: rightBottomButton.superview!, constant: sideMargin * 0.5)
        
        // Example for using an array of views to layout them using a single line
        
        // Align both buttons to superview's bottom
        [leftBottomButton, rightBottomButton].layoutToSuperview(.bottom, constant: -bottomMargin)
        
        // Set constant height for both buttons
        [leftBottomButton, rightBottomButton].setConstant(edges: .height, value: height)
    }
    
}
