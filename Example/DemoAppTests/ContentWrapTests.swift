//
//  ContentWrapTests.swift
//  DemoAppTests
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import QuickLayout

class ContentWrapTests: QuickSpec {

    override func spec() {
        
        describe("content wrap tests") {
            
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
            
            it("complies to an implicit content wrap") {
                child.forceContentWrap()
                
                expect(child.contentHuggingPriority.horizontal).to(equal(.required))
                expect(child.contentHuggingPriority.vertical).to(equal(.required))
                
                expect(child.contentCompressionResistancePriority.horizontal).to(equal(.required))
                expect(child.contentCompressionResistancePriority.vertical).to(equal(.required))
            }
            
            it("complies to an explicit content wrap") {
                child.forceContentWrap(.vertically, .horizontally)
                
                expect(child.contentHuggingPriority.horizontal).to(equal(.required))
                expect(child.contentHuggingPriority.vertical).to(equal(.required))
                
                expect(child.contentCompressionResistancePriority.horizontal).to(equal(.required))
                expect(child.contentCompressionResistancePriority.vertical).to(equal(.required))
            }
        }
    }
}
