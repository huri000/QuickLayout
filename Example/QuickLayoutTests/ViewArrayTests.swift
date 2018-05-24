//
//  ViewArrayTests.swift
//  QuickLayoutTests
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import Quick
import Nimble
@testable import QuickLayout

class ViewArrayTests: QuickSpec {
    
    override func spec() {
        
        describe("views-array tests") {
            
            var parentSize: CGSize!
            var parent: QLView!
            var children: [QLView]!
            
            beforeEach {
                parentSize = CGSize(width: 100, height: 100)
                parent = QLView(frame: CGRect(origin: .zero, size: parentSize))
                children = [QLView](repeating: QLView(), count: 10)
                children.forEach { parent.addSubview($0) }
            }
            
            it("is not valid for layout when superview is missing") {
                children.first!.removeFromSuperview()
                expect(children.isValidForQuickLayout).to(beFalse())
            }
            
            it("must not be empty in order to be valid for layout") {
                children.removeAll()
                expect(children.isValidForQuickLayout).to(beFalse())
            }
            
            it("must have a superview in order to layout to superview edge") {
                children.first!.removeFromSuperview()
                
                let constraints = children.layoutToSuperview(axis: .vertically)
                
                expect(constraints).to(beEmpty())
            }
            
            it("must have a superview in order to spread across an axis") {
                children.first!.removeFromSuperview()
                
                let constraints = children.spread(.vertically)
                
                expect(constraints).to(beEmpty())
            }
            
            it("must have a superview in order to layout edge to another view edge") {
                children.first?.removeFromSuperview()
                
                let constraints = children.layout(.centerX, to: .centerX, of: parent)
                
                expect(constraints).to(beEmpty())
            }
            
            it("must have a superview in order to layout multiple esges to another view edge") {
                children.first?.removeFromSuperview()
                
                let constraints = children.layout(.centerX, .centerY, to: parent)
                
                expect(constraints).to(beEmpty())
            }
            
            it("layouts to parent edges and distributed properly") {
                
                let hAxisConstraints = children.layoutToSuperview(axis: .horizontally)
                
                expect(hAxisConstraints).toEventuallyNot(beNil())
                expect(hAxisConstraints.count).to(equal(children.count))
                
                children.spread(.vertically, stretchEdgesToSuperview: true)
                parent.quickLayoutIfNeeded()
                
                for child in children {
                    expect(child.frame.width).to(equal(parent.bounds.width))
                    expect(child.frame.minX).to(equal(parent.bounds.minX))
                    expect(child.frame.maxX).to(equal(parent.bounds.maxX))
//                        expect(child.frame.height).to(equal(parent.bounds.height / CGFloat(children.count)))
                }
            }
            
            it("layouts to parent edges and height is constant") {
                
                let constantHeight: CGFloat = 10
                
                children.layoutToSuperview(axis: .horizontally)
                children.set(.height, of: constantHeight)
                children.layoutToSuperview(.centerY)
                parent.quickLayoutIfNeeded()
                
                for child in children {
                    expect(child.frame.midY).to(equal(parent.bounds.height / 2))
                    expect(child.frame.height).to(equal(constantHeight))
                    expect(child.frame.minX).to(equal(parent.bounds.minX))
                    expect(child.frame.maxX).to(equal(parent.bounds.maxX))
                }
            }
            
            it("layouts to parent edges and edges both are constant - indirect way through parent") {
                
                let constantEdge: CGFloat = 10
                
                children.set(.height, .width, of: constantEdge)
                children.layoutToSuperview(.centerX)
                children.layoutToSuperview(.centerY)
                parent.quickLayoutIfNeeded()
                
                for child in children {
                    expect(child.frame.midY).to(equal(parent.bounds.height / 2))
                    expect(child.frame.midX).to(equal(parent.bounds.width / 2))
                    expect(child.frame.height).to(equal(constantEdge))
                    expect(child.frame.width).to(equal(constantEdge))
                    expect(child.frame.minY).to(equal((parent.bounds.height - child.frame.height) * 0.5))
                }
            }
            
            it("layouts to parent edges and edges both are constant - direct way") {
                
                let constantEdge: CGFloat = 20
                
                children.set(.height, .width, of: constantEdge)
                children.layout(.centerX, to: .centerX, of: parent)
                children.layout(.centerY, to: .centerY, of: parent)
                parent.quickLayoutIfNeeded()
                
                expect(children.isValidForQuickLayout).to(beTrue())
                
                for child in children {
                    expect(child.frame.midY).to(equal(parent.bounds.height / 2))
                    expect(child.frame.midX).to(equal(parent.bounds.width / 2))
                    expect(child.frame.height).to(equal(constantEdge))
                    expect(child.frame.width).to(equal(constantEdge))
                    expect(child.frame.minY).to(equal((parent.bounds.height - child.frame.height) * 0.5))
                }
            }
            
            it("layouts multiple edges to parent - direct way") {
                
                let constantEdge: CGFloat = 30
                
                children.set(.height, of: constantEdge)
                children.layoutToSuperview(.centerY)
                children.layout(.left, .right, to: parent)
                parent.quickLayoutIfNeeded()
                
                expect(children.isValidForQuickLayout).to(beTrue())
                
                for child in children {
                    expect(child.frame.midY).to(equal(parent.bounds.height / 2))
                    expect(child.frame.midX).to(equal(parent.bounds.width / 2))
                    expect(child.frame.height).to(equal(constantEdge))
                    expect(child.frame.width).to(equal(parent.bounds.width))
                    expect(child.frame.minY).to(equal((parent.bounds.height - child.frame.height) * 0.5))
                }
            }
        }
    }
}
