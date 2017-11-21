//
//  ContactTableViewCell.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    // MARK: UI Props
    private let thumbView = ThumbView()
    private let nameLabel = UILabel()
    
    var name: String {
        set {
            var value = newValue
            if value.isEmpty {
                value = "Anonymous"
            }
            nameLabel.text = value
            thumbView.name = value
        }
        get {
            return nameLabel.text ?? "Anonymous"
        }
    }
    
    // MARK: Setup
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupThumbView()
        setupNameLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupThumbView() {
        contentView.addSubview(thumbView)
        thumbView.layoutToSuperview(axis: .vertically, constant: 20, priority: .must)
        thumbView.layoutToSuperview(.centerY)
        thumbView.layoutToSuperview(.left, constant: 16)
        thumbView.setConstant(edges: .width, .height, value: 50)
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.layout(.left, to: .right, of: thumbView, constant: 10)
        nameLabel.layout(to: .centerY, of: thumbView)
        nameLabel.layoutToSuperview(.right, constant: -20)
    }
}
