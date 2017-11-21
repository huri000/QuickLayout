//
//  UIView+QuickLayout.swift
//  QuickLayout
//
//  Created by Daniel Huri on 11/19/17.
//

import Foundation
import UIKit

public extension UIView {
    
    // MARK: Set constant edge (Single edge) - Convenience
    @discardableResult
    public func setConstant(_ edge: NSLayoutAttribute, value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        constraint.priority = priority
        addConstraint(constraint)
        return constraint
    }
    
    // MARK: Set constant edges of view (Variadic parameters).
    @discardableResult
    func setConstant(edges: [NSLayoutAttribute], value: CGFloat, priority: UILayoutPriority = .required) -> QLMultipleConstraints {
        var constraints: QLMultipleConstraints = [:]
        let uniqueEdges = Set(edges)
        for edge in uniqueEdges {
            let constraint = setConstant(edge, value: value, priority: priority)
            constraints[edge] = constraint
        }
        return constraints
    }
    
    // MARK: Convenience workaround in order to work with variadic parameters
    @discardableResult
    public func setConstant(edges: NSLayoutAttribute..., value: CGFloat, priority: UILayoutPriority = .required) -> QLMultipleConstraints {
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
    public func layoutToSuperview(edges: NSLayoutAttribute..., multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLMultipleConstraints? {
        guard !edges.isEmpty && isValidForQuickLayout else {
            return nil
        }
        var constraints: QLMultipleConstraints = [:]
        let uniqueEdges = Set(edges)
        
        for edge in uniqueEdges {
            let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: superview, attribute: edge, multiplier: multiplier, constant: constant)
            constraint.priority = priority
            superview!.addConstraint(constraint)
            constraints[edge] = constraint
        }
        return constraints
    }
    
    // MARK: Layout to superview axis (.verically, .horizontally)
    @discardableResult
    public func layoutToSuperview(axis: LayoutAxis, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLAxisConstraints? {
        let attributes = axis.attributes
        guard let first = layoutToSuperview(attributes.first, constant: constant, priority: priority) else {
            return nil
        }
        guard let second = layoutToSuperview(attributes.second, constant: -constant, priority: priority) else {
            return nil
        }
        return QLAxisConstraints(first: first, second: second)
    }
    
    // MARK: Size superview (.width, .height)
    @discardableResult
    public func sizeToSuperview(withMultiplier multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLSizeConstraints? {
        guard let size = layoutToSuperview(edges: .width, .height, multiplier: multiplier, constant: constant, priority: priority) else {
            return nil
        }
        return QLSizeConstraints(width: size[.width]!, height: size[.height]!)
    }
    
    // MARK: Center in superview
    @discardableResult
    public func centerInSuperview(constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLCenterConstraints? {
        guard let center = layoutToSuperview(edges: .centerX, .centerY, constant: constant) else {
            return nil
        }
        return QLCenterConstraints(x: center[.centerX]!, y: center[.centerY]!)
    }
    
    // MARK: Fill superview totally.
    @discardableResult
    public func fillSuperview(withSizeMultiplier sizeMultiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> QLFillConstraints? {
        guard let center = centerInSuperview(priority: priority) else {
            return nil
        }
        guard let size = sizeToSuperview(withMultiplier: sizeMultiplier, constant: constant, priority: priority) else {
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
