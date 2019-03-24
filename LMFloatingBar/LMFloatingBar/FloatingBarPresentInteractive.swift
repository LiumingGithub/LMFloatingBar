//
//  FloatingBarPresentInteractive.swift
//  LMFloatingBar
//
//  Created by 刘明 on 2019/3/24.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit

class FloatingBarPresentInteractive: BaseGestureInteractive {
    struct Constant {
        static let tansform: CGFloat = 1.66
    }
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        GeneralFloatingBarManager.shared.setFloatingBarAlpha(percentComplete * Constant.tansform)
    }
    
    override func finish() {
        super.finish()
        GeneralFloatingBarManager.shared.setFloatingHidden(true, animate: false)
    }
    
    override func cancel() {
        super.cancel()
        GeneralFloatingBarManager.shared.setFloatingHidden(true, animate: false)
    }
}
