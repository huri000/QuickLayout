//
//  DataSource.swift
//  DemoApp
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var firstName: String
    var lastName: String
    var userName: String
    var email: String
}

class DataSource<T: Decodable> {
    
    enum ResourceName: String {
        case contacts
        case sentences
    }
    
    typealias SetupCompletion = () -> ()
    
    var data: [T] = []
    
    private(set) subscript(index: Int) -> T {
        set {
            data[index] = newValue
        }
        get {
            return data[index]
        }
    }
    
    var count: Int {
        return data.count
    }
    
    func setup(from resource: ResourceName, with completion: @escaping SetupCompletion) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let path = Bundle.main.path(forResource: resource.rawValue, ofType: "json") else {
                return
            }
            
            guard let rawData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let data = try? decoder.decode([T].self, from: rawData) else {
                return
            }
            
            self.data.append(contentsOf: data)
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
