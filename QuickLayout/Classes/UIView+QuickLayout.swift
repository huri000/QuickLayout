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

// MARK: Possible axes enum
public enum LayoutAxis {
    case horizontally
    case vertically
    var attributes: (NSLayoutAttribute, NSLayoutAttribute) {
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
        return (first: first, second: second)
    }
}

// MARK: Layout priorities which are mostly used
public extension UILayoutPriority {
    public static let must = UILayoutPriority(rawValue: 999)
    public static let zero = UILayoutPriority(rawValue: 0)
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
    
    // MARK: Constant Edge
    @discardableResult
    public func setConstant(edge: NSLayoutAttribute, value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint?
    {
        // Enable autolayout mechanism
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        constraint.priority = priority
        
        addConstraint(constraint)
        
        return constraint
    }
    
    // MARK: Layout in relation to other views
    @discardableResult
    public func layout(_ firstAttribute: NSLayoutAttribute, to secondAttribute: NSLayoutAttribute, of view: UIView, relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        guard let selfValidationSuccess = try? validate(), selfValidationSuccess == true else {
            print("\(String(describing: self)) Error in func: \(#function)")
            return nil
        }
        let constraint = NSLayoutConstraint(item: self, attribute: firstAttribute, relatedBy: .equal, toItem: view, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        superview!.addConstraint(constraint)
        return constraint
    }
    
    // MARK: Layout to superview edge (.width , .height, .left, .right, .leading, .trailing)
    @discardableResult
    public func layoutToSuperview(_ edge: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        guard let validated = try? validate(), validated else {
            print("\(String(describing: self)) Error in func: \(#function)")
            return nil
        }
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: edge, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        superview!.addConstraint(constraint)
        return constraint
    }
    
    // MARK: Layout to superview axis (.verically, .horizontally)
    @discardableResult
    public func layoutToSuperview(axis: LayoutAxis, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> (NSLayoutConstraint?, NSLayoutConstraint?)? {
        let attributes = axis.attributes
        let firstConstraint = layoutToSuperview(attributes.0, constant: constant, priority: priority)
        let secondConstraint = layoutToSuperview(attributes.1, constant: -constant, priority: priority)
        
        guard firstConstraint != nil && secondConstraint != nil else { return nil }
        
        return (firstConstraint!, secondConstraint!)
    }
    
    // MARK: Size superview (.width, .height)
    @discardableResult
    public func sizeToSuperview(withMultiplier mult: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> (NSLayoutConstraint?, NSLayoutConstraint?)?
    {
        let widthConstraint = layoutToSuperview(.width, multiplier: mult, constant: constant, priority: priority)
        let heightConstraint = layoutToSuperview(.height, multiplier: mult, constant: constant, priority: priority)
        
        guard widthConstraint != nil && heightConstraint != nil else { return nil }
        
        return (widthConstraint!, heightConstraint!)
    }
    
    // MARK: Center in superview
    @discardableResult
    public func centerInSuperview(withMultiplier mult: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> (NSLayoutConstraint?, NSLayoutConstraint?)?
    {
        let centerX = layoutToSuperview(.centerX, multiplier: mult, constant: constant)
        let centerY = layoutToSuperview(.centerY, multiplier: mult, constant: constant)
        
        guard centerX != nil && centerY != nil else { return nil }
        
        return (centerX!, centerY!)
    }
    
    // MARK: Fill superview totally.
    @discardableResult
    public func fillSuperview(withMultiplier mult: CGFloat = 1, andConstant const: CGFloat = 0, priority: UILayoutPriority = .required) -> (NSLayoutConstraint?, NSLayoutConstraint?, NSLayoutConstraint?, NSLayoutConstraint?)?
    {
        let sizeConstraints = sizeToSuperview(withMultiplier: mult, constant: const, priority: priority)
        let centerConstraints = centerInSuperview(priority: priority)
        
        guard sizeConstraints != nil && centerConstraints != nil else { return nil }
        
        return (centerConstraints!.0, centerConstraints!.1, sizeConstraints!.0, sizeConstraints!.1)
    }
    
    // MARK: Privately used - validates the view has superview, and sets it's 'translatesAutoresizingMaskIntoConstraints' to false.
    func validate() throws -> Bool {
        
        // Implies it is the caller responsibility to make sure the view has superview
        guard let _ = superview else {
            throw ConstraintErrorType.nullifiedSuperview("Superview is nil");
        }
        
        // Enable autolayout mechanism
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        return true
    }
}
