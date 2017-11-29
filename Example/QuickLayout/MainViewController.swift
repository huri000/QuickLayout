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
        
        scrollExampleButton.backgroundColor = .satPink
        scrollExampleButton.setTitle("Scroll View", for: .normal)
        scrollExampleButton.addTarget(self, action: #selector(scrollViewExampleButtonPressed), for: .touchUpInside)
        view.addSubview(scrollExampleButton)
        
        tableExampleButton.backgroundColor = .satBlue
        tableExampleButton.setTitle("Table View", for: .normal)
        tableExampleButton.addTarget(self, action: #selector(tableViewExampleButtonPressed), for: .touchUpInside)
        view.addSubview(tableExampleButton)
        
        let sideMargin: CGFloat = 20

        // Align to the left of it's superview
        scrollExampleButton.layoutToSuperview(.left, offset: sideMargin)
        
        // Align right to centerX of it's superview, with constant distance
        scrollExampleButton.layout(.right, to: .centerX, of: scrollExampleButton.superview!, offset: -sideMargin * 0.5)
        
        // Align to the right of it's superview
        tableExampleButton.layoutToSuperview(.right, offset: -sideMargin)
        
        // Align left to centerX of it's superview, with constant distance
        tableExampleButton.layout(.left, to: .centerX, of: tableExampleButton.superview!, offset: sideMargin * 0.5)
        
        // Example for using an array of views to layout them using a single line
        
        // Align both buttons to superview's centerY
        [scrollExampleButton, tableExampleButton].layoutToSuperview(.centerY)
        
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
    
    private func test() {
        // Create a view, add it to view hierarchy, and customize it
        let simpleView = UIView()
        simpleView.backgroundColor = .gray
        view.addSubview(simpleView)
        
        simpleView.set(.height, of: 50)
        
        
        
        simpleView.layoutToSuperview(.top)
        simpleView.layoutToSuperview(.centerX)
        simpleView.layoutToSuperview(.width, ratio: 0.8)
        let constraint = simpleView.layoutToSuperview(.centerX)
        let center = simpleView.centerInSuperview()
        center?.x.constant = 20
        center?.y.constant = 20
        
        let size = simpleView.sizeToSuperview()
        size?.width.constant = -20
        
        let anotherView = UIView()
        simpleView.layout(.left, to: .right, of: anotherView, offset: 20)
        simpleView.layoutToSuperview(.top, .bottom, .left, .right)
        simpleView.layoutToSuperview(.top, .bottom, .left, .right)
        
        
        // Create array of views and customize it
        var viewsArray: [UIView] = []
        for _ in 0...4 {
            let simpleView = UIView()
            view.addSubview(simpleView)
            viewsArray.append(simpleView)
        }
        
        viewsArray.set(.height, of: 50)
        viewsArray.layoutToSuperview(axis: .horizontally, offset: 30)
        viewsArray.spread(.vertically, stretchEdgesToSuperview: true, offset: 8)

    }
}
