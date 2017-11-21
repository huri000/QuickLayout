//
//  QLUtils.swift
//  QuickLayout
//
//  Created by Daniel Huri on 11/21/17.
//

import Foundation
import UIKit

// MARK: WIP
private enum QLConstraintIdentifier: String {
    
    case constantWidth
    case constantHeight
    
    case centerXInSuperview
    case centerYInSuperview
    
    case widthToSuperview
    case heightToSuperview
    case leftToSuperview
    case rightToSuperview
    case topToSuperview
    case bottomToSuperview
    case leadingToSuperview
    case trailingToSuperview
    
    case leftToRightOfView
    case rightToLeftOfView
    case topToBottomOfView
    case bottomToTopOfView
    
    case centerXToLeftOfView
    case centerXToRightOfView
    case centerXToLeadingOfView
    case centerXToTrailingOfView
    
    case centerYToTopOfView
    case centerYToBottomOfView
    
    var value: String {
        return "ql_\(rawValue)"
    }
}
// MARK: Layout priorities which are mostly used
public extension UILayoutPriority {
    public static let must = UILayoutPriority(rawValue: 999)
    public static let zero = UILayoutPriority(rawValue: 0)
}

// MARK: Represents pair of attributes
public struct QLAttributePair {
    let first: NSLayoutAttribute
    let second: NSLayoutAttribute
}

// MARK: Represents size constraints
public struct QLSizeConstraints {
    let width: NSLayoutConstraint
    let height: NSLayoutConstraint
}

// MARK: Represents axis constraints (might be .top and .bottom, .left and .right, .leading and .trailing)
public struct QLAxisConstraints {
    let first: NSLayoutConstraint
    let second: NSLayoutConstraint
}

// MARK: Represents center constraints
public struct QLCenterConstraints {
    let x: NSLayoutConstraint
    let y: NSLayoutConstraint
}

// MARK: Represents center and size constraints
public struct QLFillConstraints {
    let center: QLCenterConstraints
    let size: QLSizeConstraints
}

// MARK: Represent pair of priorities
public struct QLPriorityPair {
    let horizontal: UILayoutPriority
    let vertical: UILayoutPriority
    
    static var required: QLPriorityPair {
        return QLPriorityPair(horizontal: .required, vertical: .required)
    }
}

public typealias QLMultipleConstraints = [NSLayoutAttribute : NSLayoutConstraint]

// MARK: Represents axis
public enum LayoutAxis {
    case horizontally
    case vertically
    var attributes: QLAttributePair {
        let first: NSLayoutAttribute
        let second: NSLayoutAttribute
        switch self {
        case .horizontally:
            first = .left
            second = .right
        case .vertically:
            first = .top
            second = .bottom
        }
        return QLAttributePair(first: first, second: second)
    }
}
