//
//  GestureInteractiveTransition.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class BaseGestureInteractive: UIPercentDrivenInteractiveTransition {
    
    public let gestureRecognizer: UIPanGestureRecognizer
    public let draggingEdge: InteractiveDraggingEdge
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    // MARK: - init & deinit
    public init(
        _ gesture: UIPanGestureRecognizer,
        draggingEdge: InteractiveDraggingEdge ) {
        
        self.gestureRecognizer = gesture
        self.draggingEdge = draggingEdge
        super.init()
        
        //给手势绑定action
        gesture.addTarget(self, action: #selector(BaseGestureInteractive.gestureHander(_:)))
    }
    
    // 需要在deinit中移除绑定的action
    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(BaseGestureInteractive.gestureHander(_:)))
    }
    
    // MARK: - override
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    open override func update(_ percentComplete: CGFloat) {
        if percentComplete <= 0 {
            super.update(0)
        }
        else if percentComplete >= 1 {
            super.update(1)
        }
        else {
            super.update(percentComplete)
        }
    }
    
    // MARK: - calculate percent
    // 根据拖动的距离，计算出动画执行的百分比
    open func percent(for gesture: UIPanGestureRecognizer) -> CGFloat {
        
        guard  let context = transitionContext else {
            cancel()
            return 1
        }
        
        let container = context.containerView
        let location = gesture.translation(in: container)
        
        let width = container.frame.width
        let height = container.frame.height
        
        // 拖动手势从右和从下时，locationInContainer 会为负值，这里进行处理和变换
        let offsetY = location.y
        let offsetX = location.x
        
        let percent: CGFloat
        switch draggingEdge {
        case .top:          percent = offsetY / height;         break
        case .bottom:       percent = -offsetY / height;        break
        case .left:         percent = offsetX / width;          break
        case .right:        percent = -offsetX / width;         break
        }
        return percent
    }
    
    //MARK: - gesture handler
    @objc func gestureHander(_ gesture: UIPanGestureRecognizer) -> Void {
        switch gesture.state {
        case .began:
            break
        case .changed:
            let pecent = percent(for: gesture)
            update(pecent)
            break
        case .ended:
            if percent(for: gesture) > 0.5 {
                finish()
            }else {
                cancel()
            }
            break
        default:
            cancel()
        }
    }
}

