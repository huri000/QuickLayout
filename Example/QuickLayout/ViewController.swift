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
class ViewController: UIViewController {
    
    // MARK: UI Props
    private let leftBottomButton = UIButton()
    private let rightBottomButton = UIButton()
    private let titleLabel = UILabel()
    private let contentScrollView = UIScrollView()

    // MARK: Setup subviews programmatically
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomButtons()
        setupTitleLabel()
//        setupScrollView()
        setupMultipleLabels()
    }
    
    // MARK: Example of setting a table-view layout
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.text = "QuickLayout Example"
        view.addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, constant: UIApplication.shared.statusBarFrame.maxY + 10)
        titleLabel.layoutToSuperview(.centerX)
    }

    // MARK: Example of setting a button layout
    private func setupBottomButtons() {
        
        let sideMargin: CGFloat = 20
        let bottomMargin: CGFloat = 30
        let height: CGFloat = 50
        
        leftBottomButton.backgroundColor = .gray
        leftBottomButton.setTitle("Left Button", for: .normal)
        view.addSubview(leftBottomButton)
        leftBottomButton.setConstant(edge: .height, value: height)
        leftBottomButton.layoutToSuperview(.left, constant: sideMargin)
        leftBottomButton.layout(.right, to: .centerX, of: view, constant: -sideMargin * 0.5)
        leftBottomButton.layoutToSuperview(.bottom, constant: -bottomMargin)
        
        rightBottomButton.backgroundColor = .gray
        rightBottomButton.setTitle("Right Button", for: .normal)
        view.addSubview(rightBottomButton)
        rightBottomButton.setConstant(edge: .height, value: height)
        rightBottomButton.layoutToSuperview(.right, constant: -sideMargin)
        rightBottomButton.layout(.left, to: .centerX, of: view, constant: sideMargin * 0.5)
        rightBottomButton.layoutToSuperview(.bottom, constant: -bottomMargin)
    }
    
    // MARK: Example of using [UIView] to layout consecutively
    private func setupMultipleLabels() {
        var labelArray: [UILabel] = []
        for _ in 0...13 {
            let label = UILabel()
            label.backgroundColor = UIColor.random
            label.text = String.random(length: Int.random(min: 10, max: 60))
            label.numberOfLines = 0
            view.addSubview(label)
            labelArray.append(label)
        }
        
        labelArray.first!.layout(.top, to: .bottom, of: titleLabel, constant: 16)
        labelArray.layoutToSuperview(axis: .horizontally, constant: 16)
        labelArray.layoutConsecutive(axis: .vertically, constant: 8)
    }
    
    // MARK: Example of setting a scroll-view layout
    private func setupScrollView() {
        view.addSubview(contentScrollView)
        contentScrollView.layout(.top, to: .bottom, of: titleLabel, constant: 20)
        contentScrollView.layout(.bottom, to: .top, of: rightBottomButton, constant: -20)
        contentScrollView.layoutToSuperview(axis: .horizontally)

        // Setup scroll-view custom subviews
        setupScrollSubviews()
    }
    
    // MARK: Demonstrates how one can simply fix a scroll-view subviews programmatically
    private func setupScrollSubviews() {
        var subviewsArray: [UIView] = []
        let lastIndex = 10
        for i in 0...lastIndex {
            let customView = UIView()
            customView.backgroundColor = .random
            contentScrollView.addSubview(customView)
            customView.layoutToSuperview(axis: .horizontally)
            customView.layoutToSuperview(.width)
            
            let randomHeight = CGFloat.random(min: 40, max: 120)
            customView.setConstant(edge: .height, value: randomHeight)
            
            if i == 0 { // First
                customView.layoutToSuperview(.top)
            } else { // Not first
                customView.layout(.top, to: .bottom, of: subviewsArray.last!, constant: 16)
            }
            
            if i == lastIndex { // Last
                customView.layoutToSuperview(.bottom)
            }
            
            subviewsArray.append(customView)
        }
    }
}
