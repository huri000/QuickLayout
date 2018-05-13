//
//  TableSampleViewController.swift
//  QuickLayout_Example
//
//  Created by Daniel Huri on 11/21/17.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import QuickLayout

class TableSampleViewController: UIViewController {

    // MARK: Data Source
    private let dataSource = DataSource<Contact>()
    
    // MARK: UI Props
    private let tableView = UITableView()
    
    // MARK: Setup
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        navigationItem.title = "Table View"
        setupDataSource()
        setupContentTableView()
    }
    
    private func setupDataSource() {
        dataSource.setup(from: .contacts) {
            self.tableView.reloadData()
        }
    }
    
    private func setupContentTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.classType)
        tableView.layoutToSuperview(.left, .right, .bottom, .top)
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.classType, for: indexPath) as! ContactTableViewCell
        cell.contact = dataSource[indexPath.row]
        return cell
    }
}
