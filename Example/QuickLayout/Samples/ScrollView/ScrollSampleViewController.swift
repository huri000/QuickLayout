//
//  ScrollSampleViewController.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import QuickLayout

class ScrollSampleViewController: UIViewController {

    // MARK: UI Props
    private let contentScrollView = UIScrollView()
    private let dataSource = DataSource<String>()
    private var scrollViewSubviews: [UIView] = []
    
    // MARK: Setup all subviews programmatically
    override func loadView() {
        super.loadView()
        view.backgroundColor = QLColor.BlueGray.c25
        edgesForExtendedLayout = []
        navigationItem.title = "Scroll View"
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource.setup(from: .sentences) {
            self.setupScrollView()
        }
    }
    
    // MARK: Example of setting a scroll-view layout
    private func setupScrollView() {
        view.addSubview(contentScrollView)
        
        // Align contentScrollView to bottom, left and right of superview simultaniouly
        contentScrollView.layoutToSuperview(.bottom, .top, .left, .right)
        
        // Setup scroll-view custom subviews
        setupMultipleLabelsInScrollView()

        // Align the first subview to the top of the scroll-view
        scrollViewSubviews.first!.layoutToSuperview(.top)
        
        // Align the last subview to the bottom of the scroll-view
        scrollViewSubviews.last!.layoutToSuperview(.bottom)
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
        for index in 0..<dataSource.count {
            let label = UILabel()
            label.backgroundColor = QLColor.BlueGray.random
            label.text = dataSource[index]
            label.textColor = .white
            label.font = MainFont.light.with(size: 14)
            label.numberOfLines = 0
            labelsContainerView.addSubview(label)
            labelArray.append(label)
        }
        
        // MARK: Create a colored column view to the left
        let columnView = UIView()
        columnView.backgroundColor = QLColor.BlueGray.random
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
