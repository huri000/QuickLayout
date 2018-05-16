//
//  ContactTableViewCell.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import QuickLayout

class ContactTableViewCell: UITableViewCell {

    // MARK: UI Props
    private let thumbView = ThumbView()
    private let emailLabel = UILabel()
    private let fullNameLabel = UILabel()
    private let userNameLabel = UILabel()
    
    var contact: Contact! {
        didSet {
            userNameLabel.text = contact.userName
            emailLabel.text = contact.email
            
            let name = "\(contact.firstName) \(contact.lastName)"
            fullNameLabel.text = name
            thumbView.name = name
        }
    }
    
    // MARK: Setup
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupThumbView()
        setupUserNameLabel()
        setupFullNameLabel()
        setupEmailLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupThumbView() {
        contentView.addSubview(thumbView)
        thumbView.layoutToSuperview(.top, offset: 16, priority: .must)
        thumbView.layoutToSuperview(.left, offset: 16)
        thumbView.set(.width, .height, of: 45)
    }
    
    private func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        userNameLabel.font = MainFont.medium.with(size: 14)
        userNameLabel.layout(.left, to: .right, of: thumbView, offset: 10)
        userNameLabel.layout(to: .top, of: thumbView)
        userNameLabel.layoutToSuperview(.right, offset: -16)
    }
    
    private func setupFullNameLabel() {
        contentView.addSubview(fullNameLabel)
        fullNameLabel.font = MainFont.light.with(size: 14)
        fullNameLabel.layout(to: .left, of: userNameLabel)
        fullNameLabel.layout(to: .right, of: userNameLabel)
        fullNameLabel.layout(.top, to: .bottom, of: userNameLabel, offset: 5)
    }
    
    private func setupEmailLabel() {
        contentView.addSubview(emailLabel)
        emailLabel.font = MainFont.light.with(size: 12)
        emailLabel.layout(to: .left, of: userNameLabel)
        emailLabel.layout(to: .right, of: userNameLabel)
        emailLabel.layout(.top, to: .bottom, of: fullNameLabel, offset: 5)
        emailLabel.layoutToSuperview(.bottom, offset: -16, priority: .must)
    }
}
