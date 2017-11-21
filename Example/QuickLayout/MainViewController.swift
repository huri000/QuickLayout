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
        return "QuickLayout Examples"
    }
    
    // MARK: UI Props
    private let scrollExampleButton = UIButton()
    private let tableExampleButton = UIButton()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        setupBottomButtons()
    }
        
    // MARK: Example of setting a buttons layout
    private func setupBottomButtons() {
        
        let sideMargin: CGFloat = 20
        let bottomMargin: CGFloat = 30
        
        scrollExampleButton.backgroundColor = .satPink
        scrollExampleButton.setTitle("Scroll View", for: .normal)
        scrollExampleButton.addTarget(self, action: #selector(scrollViewExampleButtonPressed), for: .touchUpInside)
        view.addSubview(scrollExampleButton)
        
        tableExampleButton.backgroundColor = .satBlue
        tableExampleButton.setTitle("Table View", for: .normal)
        tableExampleButton.addTarget(self, action: #selector(tableViewExampleButtonPressed), for: .touchUpInside)
        view.addSubview(tableExampleButton)
        
        // Align leftBottomButton to the left of it's superview
        scrollExampleButton.layoutToSuperview(.left, constant: sideMargin)
        
        // Align leftBottomButton's right to centerX of it's superview, with constant distance
        scrollExampleButton.layout(.right, to: .centerX, of: scrollExampleButton.superview!, constant: -sideMargin * 0.5)
        
        // Align rightBottomButton to the right of it's superview
        tableExampleButton.layoutToSuperview(.right, constant: -sideMargin)
        
        // Align rightBottomButton's left to centerX of it's superview, with constant distance
        tableExampleButton.layout(.left, to: .centerX, of: tableExampleButton.superview!, constant: sideMargin * 0.5)
        
        // Example for using an array of views to layout them using a single line
        
        // Align both buttons to superview's bottom
        [scrollExampleButton, tableExampleButton].layoutToSuperview(.bottom, constant: -bottomMargin)
        
        // Set constant height for both buttons
        scrollExampleButton.layout(.height, to: .width, of: scrollExampleButton)
        tableExampleButton.layout(.height, to: .width, of: tableExampleButton)
    }
    
    @objc func scrollViewExampleButtonPressed() {
        present(ScrollSampleViewController(), animated: true, completion: nil)
    }
    
    @objc func tableViewExampleButtonPressed() {
        present(TableSampleViewController(), animated: true, completion: nil)
    }
}
