//
//  QLCompatibility.swift
//  Pods
//
//  Created by Daniel Huri on 5/12/18.
//

import Foundation

#if os(iOS)
import UIKit
public typealias QLView = UIView
public typealias QLViewController = UIViewController
public typealias QLPriority = UILayoutPriority
public typealias QLAttribute = NSLayoutAttribute
public typealias QLRelation = NSLayoutRelation
#else
import AppKit
public typealias QLView = NSView
public typealias QLViewController = NSViewController
public typealias QLPriority = NSLayoutConstraint.Priority
public typealias QLAttribute = NSLayoutConstraint.Attribute
public typealias QLRelation = NSLayoutConstraint.Relation
#endif
