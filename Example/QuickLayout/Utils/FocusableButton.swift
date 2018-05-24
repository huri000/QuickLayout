//
//  FocusableButton.swift
//  QuickLayout
//
//  Created by Daniel Huri on 5/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class FocusableButton: UIButton {

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            self.setFocusState()
        }, completion: nil)
    }
    
    private func setFocusState() {
        isFocused ? setupFocus() : setupUnfocused()
    }
    
    private func setupFocus() {
        backgroundColor = QLColor.BlueGray.c100
    }
    
    private func setupUnfocused() {
        backgroundColor = QLColor.BlueGray.c400
    }
}
