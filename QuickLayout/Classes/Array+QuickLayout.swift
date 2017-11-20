//
//  Array+QuickLayout.swift
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
    public func setConstant(edge: NSLayoutAttribute, value: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        var constraintsArray: [NSLayoutConstraint] = []
        for view in self {
            let constraint = view.setConstant(edge: edge, value: value)!
            constraintsArray.append(constraint)
        }
        return constraintsArray
    }
    
    // MARK: Layout views consecutively according to a given axis (.vertically, .horizontally)
    @discardableResult
    public func layoutConsecutive(axis: LayoutAxis, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValid else {
            return nil
        }
        let attributes = axis.attributes
        var constraintsArray: [NSLayoutConstraint] = []
        for (index, view) in enumerated() {
            guard index > 0 else {
                continue
            }
            let constraint = view.layout(attributes.0, to: attributes.1, of: self[index-1], constant: constant, priority: priority)!
            constraintsArray.append(constraint)
        }
        return constraintsArray
    }
    
    // MARK: Layout views to superview axis (.vertically, .horizontally)
    @discardableResult
    public func layoutToSuperview(axis: LayoutAxis, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> ([NSLayoutConstraint], [NSLayoutConstraint])? {
        let firstAttribute: NSLayoutAttribute
        let secondAttribute: NSLayoutAttribute
        switch axis {
        case .horizontally:
            firstAttribute = .left
            secondAttribute = .right
        case .vertically:
            firstAttribute = .top
            secondAttribute = .bottom
        }
        
        guard let firstConstraints = layoutToSuperview(firstAttribute, constant: constant, priority: priority) else {
            return nil
        }
        guard let secondConstraints = layoutToSuperview(secondAttribute, constant: -constant, priority: priority) else {
            return nil
        }
        return (firstConstraints, secondConstraints)
    }
    
    // MARK: Layout UIView elements edge to superview
    @discardableResult
    public func layoutToSuperview(_ edge: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValid else {
            return nil
        }
        return layout(to: edge, of: first!.superview!, multiplier: multiplier, margin: constant, priority: priority)
    }
    
    // MARK: Layout UIView elements edge to anchorView edge
    @discardableResult
    public func layout(_ firstEdge: NSLayoutAttribute? = nil, to anchorEdge: NSLayoutAttribute, of anchorView: UIView, multiplier: CGFloat = 1, margin: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint]? {
        guard isValid else {
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
            let constraint = view.layout(edge, to: anchorEdge, of: anchorView, multiplier: multiplier, constant: margin, priority: priority)!
            result.append(constraint)
        }
        
        return result
    }
    
    // MARK: Keep multiple views edge to anotherEdge of view
    //    @discardableResult
    //    public func layout(views: [UIView], edges: [NSLayoutAttribute], to anchorEdges: [NSLayoutAttribute], of anchorView: UIView, multiplier: CGFloat = 1, margin: CGFloat = 0) -> [[NSLayoutConstraint]]? {
    //        guard validate(views: views) else {
    //            return nil
    //        }
    //
    //        guard edges.count == anchorEdges.count else {
    //            print("Warning: Edges must be identical")
    //            return nil
    //        }
    //
    //        var result: [[NSLayoutConstraint]] = []
    //        for view in views {
    //            var viewConstraints: [NSLayoutConstraint] = []
    //            for (edge, anchorEdge) in zip(edges, anchorEdges) {
    //                let constraint = view.layout(edge, to: anchorEdge, of: anchorView, multiplier: multiplier, constant: margin)!
    //                viewConstraints.append(constraint)
    //            }
    //            result.append(viewConstraints)
    //        }
    //        return result
    //    }
    //
    private var isValid: Bool {
        guard !isEmpty else {
            print("\(String(describing: self)) Error in func: \(#function), Views collection is empty!")
            return false
        }
        
        for view in self {
            guard let validated = try? view.validate(), validated else {
                print("\(String(describing: self)) Error in func: \(#function)")
                return false
            }
        }
        return true
    }
}
