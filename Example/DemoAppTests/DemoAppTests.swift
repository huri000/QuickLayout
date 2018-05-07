//
//  DemoAppTests.swift
//  DemoAppTests
//
//  Created by Daniel Huri on 5/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import QuickLayout

class DemoAppTests: QuickSpec {
    
    override func spec() {
        
        describe("a testing of utils") {
        
            context("QLAttributePair") {
                
                it("is filled with proper values") {
                    let pair = QLAttributePair(first: .leading, second: .trailing)
                    expect(pair.first).to(equal(.leading))
                    expect(pair.second).to(equal(.trailing))
                }
            }
            
            context("QLPriorityPair") {
                
                it("has working getter required/must") {
                    
                    expect(QLPriorityPair.required.horizontal).to(equal(.required))
                    expect(QLPriorityPair.required.vertical).to(equal(.required))
                    
                    expect(QLPriorityPair.must.horizontal).to(equal(.must))
                    expect(QLPriorityPair.must.vertical).to(equal(.must))
                }
                
                it("is filled with proper custom values") {
                    let pair = QLPriorityPair(.required, .must)
                    expect(pair.horizontal).to(equal(.required))
                    expect(pair.vertical).to(equal(.must))
                }
            }
            
            context("QLAxis") {
                
                it("has proper horizontal attributes") {
                    let hAxis = QLAxis.horizontally
                    expect(hAxis.attributes.first).to(equal(.left))
                    expect(hAxis.attributes.second).to(equal(.right))
                }

                it("has proper vertical attributes") {
                    let vAxis = QLAxis.vertically
                    expect(vAxis.attributes.first).to(equal(.top))
                    expect(vAxis.attributes.second).to(equal(.bottom))
                }
            }
        }
        
        describe("Generic view validity") {
            
            it("is not valid for Quick Layout - single view") {
                expect(UIView().isValidForQuickLayout).to(beFalse())
            }
            
            it("is not valid for Quick Layout - array of views") {
                expect([UIView(), UIView()].isValidForQuickLayout).to(beFalse())
            }
            
            it("is valid for Quick Layout - single view") {
                let parent = UIView()
                let child = UIView()
                parent.addSubview(child)
                expect(child.isValidForQuickLayout).to(beTrue())
            }
        }
        
        describe("content wrap of a view") {
            var parentSize: CGSize!
            var parent: UIView!
            var child: UIView!
            
            beforeEach {
                parentSize = CGSize(width: 100, height: 100)
                parent = UIView(frame: CGRect(origin: .zero, size: parentSize))
                child = UIView()
                parent.addSubview(child)
            }
            
            it("complies to content compression resistance change") {
                child.contentCompressionResistancePriority = .init(.must, .must)
                expect(child.contentCompressionResistancePriority.horizontal).to(equal(.must))
                expect(child.contentCompressionResistancePriority.vertical).to(equal(.must))
            }
            
            it("complies to content hugging priority change") {
                child.contentHuggingPriority = .init(.must, .must)
                expect(child.contentHuggingPriority.horizontal).to(equal(.must))
                expect(child.contentHuggingPriority.vertical).to(equal(.must))
            }
            
            it("complies to content wrap implicit") {
                child.forceContentWrap()
                
                expect(child.contentHuggingPriority.horizontal).to(equal(.required))
                expect(child.contentHuggingPriority.vertical).to(equal(.required))
                
                expect(child.contentCompressionResistancePriority.horizontal).to(equal(.required))
                expect(child.contentCompressionResistancePriority.vertical).to(equal(.required))
            }
            
            it("complies to content wrap explicit") {
                child.forceContentWrap(.vertically, .horizontally)
                
                expect(child.contentHuggingPriority.horizontal).to(equal(.required))
                expect(child.contentHuggingPriority.vertical).to(equal(.required))
                
                expect(child.contentCompressionResistancePriority.horizontal).to(equal(.required))
                expect(child.contentCompressionResistancePriority.vertical).to(equal(.required))
            }
        }
        
        describe("a testing of view constraints") {
            
            describe("how a child layout to its superview") {
                
                var parentSize: CGSize!
                var childSize: CGSize!
                var parent: UIView!
                var child: UIView!
                
                beforeEach {
                    parentSize = CGSize(width: 100, height: 100)
                    childSize = CGSize(width: parentSize.width * 0.5, height: parentSize.height * 0.5)
                    parent = UIView(frame: CGRect(origin: .zero, size: parentSize))
                    child = UIView()
                    parent.addSubview(child)
                }
                
                it("is centered and has constant size") {
                    child.layoutToSuperview(.centerX, .centerY)
                    child.set(.width, of: childSize.width)
                    child.set(.height, of: childSize.height)
                    parent.layoutIfNeeded()
                    
                    expect(child.frame.midX).to(equal(parent.bounds.width * 0.5))
                    expect(child.frame.midY).to(equal(parent.bounds.height * 0.5))
                    expect(child.frame.width).to(equal(childSize.width))
                    expect(child.frame.height).to(equal(childSize.height))
                }
                
                it("fills its parent") {
                    child.fillSuperview()
                    parent.layoutIfNeeded()
                    expect(child.frame).to(equal(parent.bounds))
                }
                
                it("fills its parent with size ratio") {
                    let ratio: CGFloat = 0.5
                    child.fillSuperview(withSizeRatio: ratio)
                    parent.layoutIfNeeded()
                    let expectedFrame = CGRect(x: parentSize.width * ratio * 0.5, y: parentSize.height * ratio * 0.5, width: parentSize.width * ratio, height: parentSize.height * ratio)
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
                    
                    parent.layoutIfNeeded()
                    expect(child.frame.width).to(equal(parent.bounds.width - offset * 2))
                    expect(child.frame.height).to(equal(parent.bounds.height - offset * 2))
                }
                
                it("layouts to parent's top left edges, and width and height are constant") {
                    let edge: CGFloat = 10
                    child.layoutToSuperview(.top, .left)
                    child.set(.width, .height, of: edge)
                    parent.layoutIfNeeded()
                    expect(child.frame.origin).to(equal(.zero))
                    expect(child.frame.size).to(equal(CGSize(width: edge, height: edge)))
                }
                
                it("layouts to parent's top left edges, and width and height are constant") {
                    let edge: CGFloat = 10
                    child.layoutToSuperview(.top, .left)
                    child.set(.width, .height, of: edge)
                    parent.layoutIfNeeded()
                    expect(child.frame.origin).to(equal(.zero))
                    expect(child.frame.size).to(equal(CGSize(width: edge, height: edge)))
                }
                
                it("layouts to parent's left but changes priority to right") {
                    
                    let leftConstraint = child.layoutToSuperview(.left, priority: .must)
                    let rightConstraint = child.layoutToSuperview(.right, priority: .defaultLow)
                    
                    expect(leftConstraint).toEventuallyNot(beNil())
                    expect(rightConstraint).toEventuallyNot(beNil())
                    
                    child.layoutToSuperview(.top)
                    child.set(.width, .height, of: 10)
                    parent.layoutIfNeeded()

                    leftConstraint!.priority = .defaultLow
                    rightConstraint!.priority = .must
                    parent.setNeedsLayout()
                    parent.layoutIfNeeded()
                    
                    expect(child.frame.maxX).to(equal(parent.bounds.width))
                }
            }
            
            describe("how 2 child views layout to one another") {
                
                var parentSize: CGSize!
                var parent: UIView!
                var child1: UIView!
                var child2: UIView!
                
                beforeEach {
                    parentSize = CGSize(width: 100, height: 100)
                    parent = UIView(frame: CGRect(origin: .zero, size: parentSize))
                    child1 = UIView()
                    child2 = UIView()
                    parent.addSubview(child1)
                    parent.addSubview(child2)
                }
                
                it("layout horizontally and to parent") {
                    child1.layoutToSuperview(.left, .top, .bottom)
                    child1.layout(.right, to: .centerX, of: parent)
                    
                    child2.layoutToSuperview(.right, .top, .bottom)
                    child2.layout(.left, to: .centerX, of: parent)
                    
                    parent.layoutIfNeeded()
                    
                    expect(child1.frame.maxX).to(equal(child2.frame.minX))
                    expect(child1.frame.minY).to(equal(child2.frame.minY))
                    expect(child1.frame.maxY).to(equal(child2.frame.maxY))
                    
                    expect(child2.frame.maxX).to(equal(parent.bounds.width))
                }
            }
        }
        
        describe("testing an array of views") {
            
            context("layout array of children to parent") {
                
                var parentSize: CGSize!
                var parent: UIView!
                var children: [UIView]!
                
                beforeEach {
                    parentSize = CGSize(width: 100, height: 100)
                    parent = UIView(frame: CGRect(origin: .zero, size: parentSize))
                    children = [UIView](repeating: UIView(), count: 10)
                    children.forEach { parent.addSubview($0) }
                }
                
                it("layouts to parent edges and distributed properly") {
                    let hAxisConstraints = children.layoutToSuperview(axis: .horizontally)
                    
                    expect(hAxisConstraints).toEventuallyNot(beNil())
                    expect(hAxisConstraints!.count).to(equal(children.count))
                    
                    children.spread(.vertically, stretchEdgesToSuperview: true)
                    parent.layoutIfNeeded()
                    
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
                    parent.layoutIfNeeded()
                    
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
                    parent.layoutIfNeeded()
                    
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
                    parent.layoutIfNeeded()
                    
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
                    parent.layoutIfNeeded()
                    
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
}
