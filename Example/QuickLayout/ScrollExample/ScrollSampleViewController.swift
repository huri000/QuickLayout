//
//  ScrollSampleViewController.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import QuickLayout
import LoremIpsum

class ScrollSampleViewController: ModalViewController {

    override var titleString: String {
        return "QuickLayout Scroll Example"
    }
    
    // MARK: UI Props
    private let contentScrollView = UIScrollView()
    private var scrollViewSubviews: [UIView] = []
    
    // MARK: Setup all subviews programmatically
    override func loadView() {
        super.loadView()
        setupScrollView()
    }
    
    // MARK: Example of setting a scroll-view layout
    private func setupScrollView() {
        view.addSubview(contentScrollView)
        
        // Align contentScrollView's top to bottom of titleLabel with offset of 20
        contentScrollView.layout(.top, to: .bottom, of: titleLabel, constant: 20)
        
        // Align contentScrollView to bottom, left and right of superview simultaniouly
        contentScrollView.layoutToSuperview(edges: .bottom, .left, .right)
        
        // Setup scroll-view custom subviews
        setupCustomViewsInScrollView()
        setupMultipleLabelsInScrollView()
        
        // Align the first subview to the top of the scroll-view
        scrollViewSubviews.first!.layoutToSuperview(.top)
        
        // Align the last subview to the bottom of the scroll-view
        scrollViewSubviews.last!.layoutToSuperview(.bottom)
    }
    
    // MARK: Demonstrates how one can fix a scroll-view subviews programmatically in a simple for-loop
    private func setupCustomViewsInScrollView() {
        for _ in 0...10 {
            let customView = UIView()
            customView.backgroundColor = .random
            contentScrollView.addSubview(customView)
            
            // Align customView to superview's left and right (horizontally stretching)
            customView.layoutToSuperview(axis: .horizontally)
            
            // Align customView to superview's width (Strengthen scroll-view constraints)
            customView.layoutToSuperview(.width)
            
            // Set constant height for customView (Randomize it for fun)
            customView.setConstant(.height, value: .random(min: 40, max: 120))
            
            // Not first item - Align top to previous's bottom, with margin of 16
            if let previous = scrollViewSubviews.last {
                customView.layout(.top, to: .bottom, of: previous, constant: 16)
            }
            
            scrollViewSubviews.append(customView)
        }
    }
    
    // MARK: Example of using [UIView]'s extension  to layout consecutively
    private func setupMultipleLabelsInScrollView() {
        
        let labelsContainerView = UIView()
        contentScrollView.addSubview(labelsContainerView)
        
        // Align labelsContainerView's top to bottom of the last scroll-view's subviews
        labelsContainerView.layout(.top, to: .bottom, of: scrollViewSubviews.last!, constant: 16)
        
        /* Example for aligning labelsContainerView to superview's
         left, right, width simultaniously using variadic parameters */
        labelsContainerView.layoutToSuperview(edges: .left, .right, .width)
        
        scrollViewSubviews.append(labelsContainerView)
        
        var labelArray: [UIView] = []
        for _ in 0...10 {
            let label = UILabel()
            label.backgroundColor = .random
            label.text = LoremIpsum.paragraph()
            label.numberOfLines = 0
            labelsContainerView.addSubview(label)
            labelArray.append(label)
        }
        
        // MARK: Create a colored column view to the left
        let columnView = UIView()
        columnView.backgroundColor = .random
        labelsContainerView.addSubview(columnView)
        
        // Set constant width of 5 to columnView
        columnView.setConstant(.width, value: 5)
        
        // Align columnView to left of superview with 16 margin
        columnView.layoutToSuperview(.left, constant: 16)
        
        // Align top and bottom of columnView with the top of the first, last labels, respectively
        columnView.layout(to: .top, of: labelArray.first!)
        columnView.layout(to: .bottom, of: labelArray.last!)
        
        // Align labels' left to the right of columnView with margin of 8
        labelArray.layout(.left, to: .right, of: columnView, constant: 8)
        
        // Align labels vertically with spacing of 8 between them
        labelArray.spread(.vertically, constant: 8)
        
        // Align the top, bottom of the first, last labels to the scroll-view, respectively
        labelArray.first!.layoutToSuperview(.top)
        labelArray.last!.layoutToSuperview(.bottom)
        
        // Align labels to the right of their superview with margin of 16
        labelArray.layoutToSuperview(.right, constant: -16)
    }
}
