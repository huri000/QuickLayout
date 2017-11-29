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
        contentScrollView.layout(.top, to: .bottom, of: titleLabel, offset: 20)
        
        // Align contentScrollView to bottom, left and right of superview simultaniouly
        contentScrollView.layoutToSuperview(.bottom, .left, .right)
        
        // Setup scroll-view custom subviews
        setupMultipleLabelsInScrollView()
        setupCustomViewsInScrollView()

        // Align the first subview to the top of the scroll-view
        scrollViewSubviews.first!.layoutToSuperview(.top)
        
        // Align the last subview to the bottom of the scroll-view
        scrollViewSubviews.last!.layoutToSuperview(.bottom)
    }
    
    // MARK: Demonstrates how one can fix a scroll-view subviews programmatically in a simple for-loop
    private func setupCustomViewsInScrollView() {
        let customViewsContainer = UIView()
        contentScrollView.addSubview(customViewsContainer)
        
        // Align top with the bottom of scroll-view's last subview
        customViewsContainer.layout(.top, to: .bottom, of: scrollViewSubviews.last!, offset: 16)
        
        // Align customView to superview's left and right (horizontally stretching)
        customViewsContainer.layoutToSuperview(axis: .horizontally)
        
        // Align customView to superview's width (Strengthen scroll-view's anchor constraints)
        customViewsContainer.layoutToSuperview(.width)
        
        let maxRowsCount = 10
        var rowViews: [UIView] = []
        for rowIndex in 0..<maxRowsCount {
            let rowView = UIView()
            customViewsContainer.addSubview(rowView)
            
            let customViewsCount = 3
            var customViews: [UIView] = []
            for i in 0..<customViewsCount {
                let customView = UIView()
                customView.backgroundColor = .random
                rowView.addSubview(customView)
                if i == 0 {
                    customView.layoutToSuperview(.leading)
                } else {
                    customView.layout(.leading, to: .trailing, of: customViews[i-1])
                }
                
                if i == customViewsCount - 1 {
                    customView.layoutToSuperview(.trailing)
                }
                customView.layoutToSuperview(axis: .vertically)
                customView.layoutToSuperview(.width, ratio: 1.0/CGFloat(customViewsCount))
                
                customViews.append(customView)
            }

            // Align customView to superview's left and right (horizontally stretching)
            rowView.layoutToSuperview(axis: .horizontally)

            // Set constant height for customView (Randomize it for fun)
            rowView.set(.height, of: .random(min: 40, max: 120))

            // Not first item - Align top to previous's bottom, with margin of 16
            if let previous = rowViews.last {
                rowView.layout(.top, to: .bottom, of: previous)
            } else {
                rowView.layoutToSuperview(.top)
            }
            
            if rowIndex == maxRowsCount - 1 {
                rowView.layoutToSuperview(.bottom)
            }
            
            rowViews.append(rowView)
        }
        
        scrollViewSubviews.append(customViewsContainer)
    }
    
    // MARK: Example of using [UIView]'s extension  to layout consecutively
    private func setupMultipleLabelsInScrollView() {
        
        let labelsContainerView = UIView()
        contentScrollView.addSubview(labelsContainerView)
        
        /* Example for aligning labelsContainerView to superview's
         left, right, width simultaniously using variadic parameters */
        labelsContainerView.layoutToSuperview(.left, .right, .width)
        
        scrollViewSubviews.append(labelsContainerView)
        
        var labelArray: [UIView] = []
        for _ in 0...10 {
            let label = UILabel()
            label.backgroundColor = .random
            label.text = LoremIpsum.paragraph()
            label.textColor = .white                                
            label.numberOfLines = 0
            labelsContainerView.addSubview(label)
            labelArray.append(label)
        }
        
        // MARK: Create a colored column view to the left
        let columnView = UIView()
        columnView.backgroundColor = .random
        labelsContainerView.addSubview(columnView)
        
        // Set constant width of 5 to columnView
        columnView.set(.width, of: 5)
        
        // Align columnView to left of superview with 16 margin
        columnView.layoutToSuperview(.left, offset: 16)
        
        // Align top and bottom of columnView with the top of the first, last labels, respectively
        columnView.layout(to: .top, of: labelArray.first!)
        columnView.layout(to: .bottom, of: labelArray.last!)
        
        // Align labels' left to the right of columnView with margin of 8
        labelArray.layout(.left, to: .right, of: columnView, offset: 8)
        
        // Align labels vertically with spacing of 8 between them, stretch to superview also
        labelArray.spread(.vertically, stretchEdgesToSuperview: true, offset: 8)
        
        // Align labels to the right of their superview with margin of 16
        labelArray.layoutToSuperview(.right, offset: -16)
    }
}
