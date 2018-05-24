//
//  VertigoViewController.swift
//  DemoApp
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import QuickLayout

class VertigoViewController: UIViewController {

    private var anchorView: UIView!
    
    // MARK: Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = QLColor.BlueGray.c25
        navigationItem.title = "Vertigo"
        edgesForExtendedLayout = []
        setupSquares()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.repeat, .autoreverse], animations: {
            self.anchorView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.anchorView.layoutIfNeeded()
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
        for _ in 0..<colors.dropLast().count {
            array.append(UIView())
        }
        
        for (index, cur) in array.enumerated().dropFirst() {
            let prev = array[index - 1]
            cur.backgroundColor = colors[index - 1]
            prev.addSubview(cur)
            
            // Only 1 line of code to layout child view in releation to it's parent
            cur.fillSuperview(withSizeRatio: 0.85, priority: .must)
        }
        
        let label = UILabel()
        label.text = "🤘"
        label.font = MainFont.medium.with(size: 50)
        label.textAlignment = .center
        array.last!.addSubview(label)
        label.fillSuperview()
        anchorView = array[1]
    }
}
