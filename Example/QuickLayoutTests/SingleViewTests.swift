//
//  SingleViewTests.swift
//  QuickLayoutTests
//
//  Created by Daniel Huri on 5/6/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import Quick
import Nimble
@testable import QuickLayout

class SingleViewTests: QuickSpec {
    
    override func spec() {
        
        describe("single view constraints tests") {
            
            context("child-parent views relationship") {
                
                var parentSize: CGSize!
                var childSize: CGSize!
                var parent: QLView!
                var child: QLView!
                
                beforeEach {
                    parentSize = CGSize(width: 100, height: 100)
                    childSize = CGSize(width: parentSize.width * 0.5, height: parentSize.height * 0.5)
                    parent = QLView(frame: CGRect(origin: .zero, size: parentSize))
                    child = QLView()
                    parent.addSubview(child)
                }
                
                it("is valid for layout only when superview exists") {
                    expect(child.isValidForQuickLayout).to(beTrue())
                }
                
                it("is not valid for layout when superview is missing") {
                    child.removeFromSuperview()
                    expect(child.isValidForQuickLayout).to(beFalse())
                }
                
                it("must have a superview in order to quick-layout a single edge") {
                    child.removeFromSuperview()
                    
                    let constraint = child.layoutToSuperview(.centerX)
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraint).to(beNil())
                }
                
                it("must have a superview in order to quick-layout multiple edges") {
                    child.removeFromSuperview()
                    
                    let constraints = child.layoutToSuperview(.left, .right)
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beEmpty())
                }
                
                it("must have a superview in order to quick-layout to a cetrain axis") {
                    child.removeFromSuperview()
                    
                    let constraints = child.layoutToSuperview(axis: .horizontally)
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beNil())
                }
                
                it("must have a superview in order to center in superview") {
                    child.removeFromSuperview()
                    
                    let constraints = child.centerInSuperview()
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beNil())
                }
                
                it("must have a superview in order to size to superview") {
                    child.removeFromSuperview()
                    
                    let constraints = child.sizeToSuperview()
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beNil())
                }
                
                it("must have a superview in order to fill it") {
                    child.removeFromSuperview()
                    
                    let constraints = child.fillSuperview()
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beNil())
                }
                
                it("must have a edges set in order to quick-layout") {
                    
                    let constraints = child.layoutToSuperview()
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beEmpty())
                }
                
                it("is centered and has constant size") {
                    child.layoutToSuperview(.centerX, .centerY)
                    child.set(.width, of: childSize.width)
                    child.set(.height, of: childSize.height)
                    parent.quickLayoutIfNeeded()
                    
                    expect(child.frame.midX).to(equal(parent.bounds.width * 0.5))
                    expect(child.frame.midY).to(equal(parent.bounds.height * 0.5))
                    expect(child.frame.width).to(equal(childSize.width))
                    expect(child.frame.height).to(equal(childSize.height))
                }
                
                it("fills its parent") {
                    child.fillSuperview()
                    parent.quickLayoutIfNeeded()
                    expect(child.frame).to(equal(parent.bounds))
                }
                
                it("fills its parent with size ratio") {
                    
                    let ratio: CGFloat = 0.5
                    
                    child.fillSuperview(withSizeRatio: ratio)
                    parent.quickLayoutIfNeeded()
                    
                    let origin = CGPoint(x: parentSize.width * ratio * 0.5, y: parentSize.height * ratio * 0.5)
                    let size = CGSize(width: parentSize.width * ratio, height: parentSize.height * ratio)
                    let expectedFrame = CGRect(origin: origin, size: size)
                    
                    expect(child.frame).to(equal(expectedFrame))
                }
                
                it("layouts to parent horizontally and vertically with offset") {
                    
                    let offset: CGFloat = 10
                    let hAxis = child.layoutToSuperview(axis: .horizontally, offset: offset)
                    let vAxis = child.layoutToSuperview(axis: .vertically, offset: offset)
                    
                    expect(hAxis).toEventuallyNot(beNil())
                    expect(hAxis!.first.constant).to(equal(offset))
                    expect(hAxis!.second.constant).to(equal(-offset))
                    
                    expect(vAxis).toEventuallyNot(beNil())
                    expect(vAxis!.first.constant).to(equal(offset))
                    expect(vAxis!.second.constant).to(equal(-offset))
                    
                    parent.quickLayoutIfNeeded()
                    expect(child.frame.width).to(equal(parent.bounds.width - offset * 2))
                    expect(child.frame.height).to(equal(parent.bounds.height - offset * 2))
                }
                
                it("layouts to parent's top left edges, and width and height are constant") {
                    
                    let edge: CGFloat = 10
                    
                    child.layoutToSuperview(.top, .left)
                    child.set(.width, .height, of: edge)
                    parent.quickLayoutIfNeeded()

                    #if os(OSX)
                    expect(child.frame.origin).to(equal(CGPoint(x: 0, y: parentSize.height - edge)))
                    #else
                    expect(child.frame.origin).to(equal(.zero))
                    #endif
                    expect(child.frame.size).to(equal(CGSize(width: edge, height: edge)))
                }
                
                it("layouts to parent's left but changes priority to right") {
                    
                    let leftConstraint = child.layoutToSuperview(.left, priority: .must)
                    let rightConstraint = child.layoutToSuperview(.right, priority: .defaultLow)
                    
                    expect(leftConstraint).toEventuallyNot(beNil())
                    expect(rightConstraint).toEventuallyNot(beNil())
                    
                    child.layoutToSuperview(.top)
                    child.set(.width, .height, of: 10)
                    parent.quickLayoutIfNeeded()

                    leftConstraint!.priority = .defaultLow
                    rightConstraint!.priority = .must
                    parent.setUpdateConstraints()
                    parent.quickLayoutIfNeeded()
                    
                    expect(child.frame.maxX).to(equal(parent.bounds.width))
                }
            }
            
            context("child-child relationship, within a parent view") {
                
                var parentSize: CGSize!
                var parent: QLView!
                var child1: QLView!
                var child2: QLView!
                
                beforeEach {
                    parentSize = CGSize(width: 100, height: 100)
                    parent = QLView(frame: CGRect(origin: .zero, size: parentSize))
                    child1 = QLView()
                    child2 = QLView()
                    parent.addSubview(child1)
                    parent.addSubview(child2)
                }
                
                it("must have a superview in order to layout multiple edges to another child") {
                    child2.layoutToSuperview(.left, .right, .top, .bottom)
                    child1.removeFromSuperview()
                    
                    let constraints = child1.layout(.left, .right, .top, .bottom, to: child2)
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraints).to(beEmpty())
                }
                
                it("must have a superview in order to be layout an edge to another child's edge") {
                    child2.layoutToSuperview(.left, .top, .bottom)
                    child2.layoutToSuperview(.width, ratio: 0.5)
                    child1.removeFromSuperview()
                    
                    let constraint = child1.layout(.left, to: .right, of: child2)
                    
                    parent.quickLayoutIfNeeded()
                    expect(constraint).to(beNil())
                }
                
                it("can layout to another child and parent") {
                    child2.layoutToSuperview(.left, .right, .top, .bottom)
                    child1.layout(.left, .right, .top, .bottom, to: child2)
                    parent.quickLayoutIfNeeded()
                    
                    expect(child1.frame).to(equal(child1.frame))
                    expect(child1.frame).to(equal(parent.bounds))
                    expect(child2.frame).to(equal(parent.bounds))
                }
                
                it("can layout horizontally and to parent") {
                    child1.layoutToSuperview(.left, .top, .bottom)
                    child1.layout(.right, to: .centerX, of: parent)
                    
                    child2.layoutToSuperview(.right, .top, .bottom)
                    child2.layout(.left, to: .centerX, of: parent)
                    
                    parent.quickLayoutIfNeeded()
                    
                    expect(child1.frame.maxX).to(equal(child2.frame.minX))
                    expect(child1.frame.minY).to(equal(child2.frame.minY))
                    expect(child1.frame.maxY).to(equal(child2.frame.maxY))
                    
                    expect(child2.frame.maxX).to(equal(parent.bounds.width))
                }
            }
        }
    }
}
