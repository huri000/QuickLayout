//
//  UIViewArray+QuickLayout.swift
//  QuickLayout
//
//  Created by Daniel Huri on 11/20/17.
//

import Foundation
import UIKit

// MARK: Multiple Views in Array
extension Array where Element: UIView {
    
    // MARK: Set constant edge for each and every view in Array
    @discardableResult
    public func setConstant(_ edge: NSLayoutAttribute, value: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        var constraints: [NSLayoutConstraint] = []
        for view in self {
            let constraint = view.setConstant(edge, value: value)
            constraints.append(constraint)
        }
        return constraints
    }
    
    // MARK: Set constant edges (plural)
    @discardableResult
    public func setConstant(edges: NSLayoutAttribute..., value: CGFloat, priority: UILayoutPriority = .required) -> [QLMultipleConstraints] {
        var constraintsArray: [QLMultipleConstraints] = []
        for view in self {
            let constraints = view.setConstant(edges: edges, value: value, priority: priority)
            constraintsArray.append(constraints)
        }
        return constraintsArray
    }
    
    // MARK: Spread views consecutively according to a given axis. Values might be: .vertically, .horizontally
    @discardableResult
    public func spread(_ axis: LayoutAxis, stretchEdgesToSuperview: Bool = false, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValidForQuickLayout else {
            return nil
        }
        let attributes = axis.attributes
        var constraints: [NSLayoutConstraint] = []
        
        if stretchEdgesToSuperview {
            let constraint = first!.layoutToSuperview(attributes.first, constant: constant)!
            constraints.append(constraint)
        }
        
        for (index, view) in enumerated() {
            guard index > 0 else {
                continue
            }
            let previousView = self[index-1]
            let constraint = view.layout(attributes.first, to: attributes.second, of: previousView, constant: constant, priority: priority)!
            constraints.append(constraint)
        }
        
        if stretchEdgesToSuperview {
            let constraint = last!.layoutToSuperview(attributes.second, constant: -constant)!
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    // MARK: Layout views to superview axis (.vertically, .horizontally)
    @discardableResult
    public func layoutToSuperview(axis: LayoutAxis, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [QLAxisConstraints]? {
        let attributes = axis.attributes
        guard let firstConstraints = layoutToSuperview(attributes.first, constant: constant, priority: priority) else {
            return nil
        }
        guard let secondConstraints = layoutToSuperview(attributes.second, constant: -constant, priority: priority) else {
            return nil
        }
        var constraints: [QLAxisConstraints] = []
        for (first, second) in zip(firstConstraints, secondConstraints) {
            constraints.append(QLAxisConstraints(first: first, second: second))
        }
        return constraints
    }
    
    // MARK: Layout UIView elements edge to superview
    @discardableResult
    public func layoutToSuperview(_ edge: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValidForQuickLayout else {
            return nil
        }
        return layout(to: edge, of: first!.superview!, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    // MARK: Layout UIView elements edge to anchorView edge
    @discardableResult
    public func layout(_ firstEdge: NSLayoutAttribute? = nil, to anchorEdge: NSLayoutAttribute, of anchorView: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValidForQuickLayout else {
            return nil
        }
        
        let edge: NSLayoutAttribute
        if let firstEdge = firstEdge {
            edge = firstEdge
        } else {
            edge = anchorEdge
        }
        
        var result: [NSLayoutConstraint] = []
        for view in self {
            let constraint = view.layout(edge, to: anchorEdge, of: anchorView, multiplier: multiplier, constant: constant, priority: priority)!
            result.append(constraint)
        }
        return result
    }
    
    // MARK: Layout elements edges to anchorView's edge
    @discardableResult
    public func layout(_ edges: NSLayoutAttribute..., to anchorView: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [QLMultipleConstraints]? {
        guard !edges.isEmpty && isValidForQuickLayout else {
            return nil
        }
        // Avoid duplicities
        let uniqueEdges = Set(edges)
        var result: [QLMultipleConstraints] = []
        for view in self {
            var multipleConstraints: QLMultipleConstraints = [:]
            for edge in uniqueEdges {
                let constraint = view.layout(to: edge, of: anchorView, multiplier: multiplier, constant: constant, priority: priority)!
                multipleConstraints[edge] = constraint
            }
            result.append(multipleConstraints)
        }
        return result
    }
    
    // MARK: Test for validity
    private var isValidForQuickLayout: Bool {
        guard !isEmpty else {
            print("\(String(describing: self)) Error in func: \(#function), Views collection is empty!")
            return false
        }
        
        for view in self {
            guard view.isValidForQuickLayout else {
                print("\(String(describing: self)) Error in func: \(#function)")
                return false
            }
        }
        return true
    }
}
