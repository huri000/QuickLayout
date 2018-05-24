//
//  UtilsTests.swift
//  QuickLayoutTests
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import Quick
import Nimble
@testable import QuickLayout

extension QLView {
    func quickLayoutIfNeeded() {
        #if os(OSX)
        layoutSubtreeIfNeeded()
        #else
        layoutIfNeeded()
        #endif
    }
    
    func setUpdateConstraints() {
        #if os(OSX)
        updateConstraintsForSubtreeIfNeeded()
        #else
        setNeedsLayout()
        #endif
    }
}

class UtilsTests: QuickSpec {
    
    override func spec() {
        
        describe("Quick Layout accessories tests") {
            
            context("QLAttributePair validity") {
                
                it("is filled with proper values") {
                    
                    let pair = QLAttributePair(first: .leading, second: .trailing)
                    
                    expect(pair.first).to(equal(.leading))
                    expect(pair.second).to(equal(.trailing))
                }
            }
            
            context("QLPriorityPair validity") {
                
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
            
            context("QLAxis validity") {
                
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
    }
}
