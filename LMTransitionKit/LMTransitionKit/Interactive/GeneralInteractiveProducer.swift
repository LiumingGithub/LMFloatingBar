//
//  GeneralInteractiveProducer.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class GeneralInteractiveProducer: InteractiveProducerType {
    
    // Interactive动画 支持的手势方向
    // 与Transition动画的interruptible是有区别的
    // 必须是Transition动画interruptible 为true， 并且手势方向在supportEdges之内才会生成Interactive动画
    open var supportEdges: [InteractiveDraggingEdge] = [.left, .right, .left, .right]
    
    public init() {}
    
    open func interactionControllerFor(
        _ animationController: UIViewControllerAnimatedTransitioning,
        draggingGesture: UIPanGestureRecognizer,
        draggingEdg: InteractiveDraggingEdge) -> UIViewControllerInteractiveTransitioning? {
        
        if let interruptible = animationController as? AnimatedTransitioningInterruptible, interruptible.isInterruptible {
            //BaseGestureInteractive 支持所有的方向所以，就不必验证draggingEdg了
            return BaseGestureInteractive(draggingGesture, draggingEdge: draggingEdg)
        }
        return nil
    }
}
