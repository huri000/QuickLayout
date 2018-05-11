//
//  VertigoViewController.swift
//  DemoApp
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import QuickLayout

class VertigoViewController: UIViewController {

    var size: QLSizeConstraints!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = QLColor.BlueGray.c25
        edgesForExtendedLayout = []
        setupSquares()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.repeat, .autoreverse], animations: {
            self.size.height.constant += 50
            self.size.width.constant += 50
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Each child view fills it's parent
    private func setupSquares() {
        let colors = [QLColor.BlueGray.c50,
                      QLColor.BlueGray.c100,
                      QLColor.BlueGray.c200,
                      QLColor.BlueGray.c300,
                      QLColor.BlueGray.c400,
                      QLColor.BlueGray.c500,
                      QLColor.BlueGray.c600,
                      QLColor.BlueGray.c700,
                      QLColor.BlueGray.c800,
                      QLColor.BlueGray.c900]
        
        var array = [view!]
        for _ in 0..<colors.count {
            array.append(UIView())
        }
        
        for (index, cur) in array.enumerated().dropFirst() {
            let prev = array[index - 1]
            cur.backgroundColor = colors[index - 1]
            prev.addSubview(cur)
            
            // Only 1 line of code to layout child view in releation to it's parent
            let size = cur.fillSuperview(withSizeRatio: 0.8, priority: .must)?.size
            
            if self.size == nil {
                self.size = size
            }
        }
    }
}

