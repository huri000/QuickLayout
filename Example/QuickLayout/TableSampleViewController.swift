//
//  TableSampleViewController.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import LoremIpsum
import QuickLayout

class TableSampleViewController: ModalViewController {

    override var titleString: String {
        return "QuickLayout Table Example"
    }
    
    // MARK: Data Source
    private var contacts: [String] = []
    
    // MARK: UI Props
    private let contentTableView = UITableView()
    
    // MARK: Setup
    override func loadView() {
        super.loadView()
        setupDataSource()
        setupContentTableView()
    }
    
    private func setupDataSource() {
        for _ in 0...49 {
            contacts.append(LoremIpsum.name())
        }
    }
    
    private func setupContentTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        view.addSubview(contentTableView)
        contentTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: String(describing: ContactTableViewCell.self))
        contentTableView.layout(.top, to: .bottom, of: titleLabel, constant: 20)
        contentTableView.layoutToSuperview(edges: .left, .right, .bottom)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TableSampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self), for: indexPath) as! ContactTableViewCell
        cell.name = contacts[indexPath.row]
        return cell
    }
}
