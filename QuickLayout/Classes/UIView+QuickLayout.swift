//
//  UIView+QuickLayout.swift
//  QuickLayout
//
//  Created by Daniel Huri on 11/19/17.
//

import Foundation
import UIKit

public enum ConstraintErrorType : Error {
    case nullifiedSuperview(NSString?)
    case mismatchedEdgesCount(NSString?)
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

public extension UIView {
    
    // MARK: Content Wrap (Compression and Hugging)
    public func forceContentWrap() {
        contentHuggingPriority = (.required, .required)
        contentCompressionResistancePriority = (.required, .required)
    }
    
    // MARK: Content Hugging Priority
    public var verticalHuggingPriority: UILayoutPriority {
        set {
            setContentHuggingPriority(newValue, for: .vertical)
        }
        get {
            return contentHuggingPriority(for: .vertical)
        }
    }
    
    public var horizontalHuggingPriority: UILayoutPriority {
        set {
            setContentHuggingPriority(newValue, for: .horizontal)
        }
        get {
            return contentHuggingPriority(for: .horizontal)
        }
    }
    
    public var contentHuggingPriority: (vertical: UILayoutPriority, horizontal: UILayoutPriority) {
        set {
            verticalHuggingPriority = newValue.vertical
            horizontalHuggingPriority = newValue.horizontal
        }
        get {
            return (verticalHuggingPriority, horizontalHuggingPriority)
        }
    }
    
    // MARK: Content Compression Resistance
    public var verticalCompressionResistancePriority: UILayoutPriority {
        set {
            setContentCompressionResistancePriority(newValue, for: .vertical)
        }
        get {
            return contentCompressionResistancePriority(for: .vertical)
        }
    }
    
    public var horizontalCompressionResistancePriority: UILayoutPriority {
        set {
            setContentCompressionResistancePriority(newValue, for: .horizontal)
        }
        get {
            return contentCompressionResistancePriority(for: .horizontal)
        }
    }
    
    public var contentCompressionResistancePriority: (vertical: UILayoutPriority, horizontal: UILayoutPriority) {
        set {
            verticalCompressionResistancePriority = newValue.vertical
            horizontalCompressionResistancePriority = newValue.horizontal
        }
        get {
            return (verticalCompressionResistancePriority, horizontalCompressionResistancePriority)
        }
    }
        
    // MARK: Set constant edge (Single edge) - Convenience
    @discardableResult
    public func setConstant(_ edge: NSLayoutAttribute, value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        constraint.priority = priority
        addConstraint(constraint)
        return constraint
    }
    
    // MARK: Set constant edges of view (Variadic parameters).
    @discardableResult
    func setConstant(edges: [NSLayoutAttribute], value: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        for edge in edges {
            let constraint = setConstant(edge, value: value, priority: priority)
            constraints.append(constraint)
        }
        return constraints
    }
    
    // MARK: Workaround in order to ork with variadic parameters
    @discardableResult
    public func setConstant(edges: NSLayoutAttribute..., value: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return setConstant(edges: edges, value: value, priority: priority)
    }
    
    // MARK: Layout in relation to other views
    @discardableResult
    public func layout(_ firstAttribute: NSLayoutAttribute? = nil, to secondAttribute: NSLayoutAttribute, of view: UIView, relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        guard isValidForQuickLayout else {
            print("\(String(describing: self)) Error in func: \(#function)")
            return nil
        }
        let constraint = NSLayoutConstraint(item: self, attribute: firstAttribute ?? secondAttribute, relatedBy: .equal, toItem: view, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        superview!.addConstraint(constraint)
        return constraint
    }
    
    // MARK: Layout to superview edges (.width , .height, .left, .right, .leading, .trailing, ...)
    @discardableResult
    public func layoutToSuperview(_ edge: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        guard isValidForQuickLayout else {
            print("\(String(describing: self)) Error in func: \(#function)")
            return nil
        }
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: edge, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        superview!.addConstraint(constraint)
        return constraint
    }
    
    // MARK: Layout to superview edges (.width , .height, .left, .right, .leading, .trailing, ...)
    @discardableResult
    public func layoutToSuperview(edges: NSLayoutAttribute..., multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValidForQuickLayout else {
            return nil
        }
        var constraints: [NSLayoutConstraint] = []
        for edge in edges {
            let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: edge, multiplier: multiplier, constant: constant)
            constraint.priority = priority
            superview!.addConstraint(constraint)
            constraints.append(constraint)
        }
        return constraints
    }
    
    // MARK: Layout to superview axis (.verically, .horizontally)
    @discardableResult
    public func layoutToSuperview(axis: LayoutAxis, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLAxisConstraints? {
        let attributes = axis.attributes
        guard let constraints = layoutToSuperview(edges: attributes.first, attributes.second, constant: constant, priority: priority) else {
            return nil
        }
        return QLAxisConstraints(first: constraints.first!, second: constraints.last!)
    }
    
    // MARK: Size superview (.width, .height)
    @discardableResult
    public func sizeToSuperview(withMultiplier multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLSizeConstraints? {
        guard let size = layoutToSuperview(edges: .width, .height, multiplier: multiplier, constant: constant, priority: priority) else {
            return nil
        }
        return QLSizeConstraints(width: size.first!, height: size.last!)
    }
    
    // MARK: Center in superview
    @discardableResult
    public func centerInSuperview(withMultiplier multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLCenterConstraints? {
        guard let center = layoutToSuperview(edges: .centerX, .centerY, constant: constant) else {
            return nil
        }
        return QLCenterConstraints(x: center.first!, y: center.last!)
    }
    
    // MARK: Fill superview totally.
    @discardableResult
    public func fillSuperview(withSizeMultiplier multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLFillConstraints? {
        guard let center = centerInSuperview(priority: priority) else {
            return nil
        }
        guard let size = sizeToSuperview(withMultiplier: multiplier, constant: constant, priority: priority) else {
            return nil
        }
        return QLFillConstraints(center: center, size: size)
    }
    
    // MARK: Test validity of view and prepare for auto-layout
    var isValidForQuickLayout: Bool {
        guard let _ = superview else {
            print("\(String(describing: self)):\(#function) - superview is unexpectedly nullified")
            return false
        }
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        return true
    }
}
