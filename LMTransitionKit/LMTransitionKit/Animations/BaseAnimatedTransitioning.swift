//
//  AnimatedTransitioning.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//


import UIKit

// 自定义的Transition动画如果Interruptible， 需要实现此协议并返回true
public protocol AnimatedTransitioningInterruptible {
    
    var isInterruptible: Bool { get }
}

//  自定义的Transition动画的基类
open class BaseAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning, AnimatedTransitioningInterruptible {
    
    /// 是否支持interactive动画
    open var isInterruptible: Bool = false
    
    open var transitionDuration: TimeInterval
    
    public init(_ duration: TimeInterval = 0.5, interruptible: Bool = false) {
        self.transitionDuration = duration
        self.isInterruptible = interruptible
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclass[\(self.classForCoder)] Must implement this method")
    }
    
    open func animationEnded(_ transitionCompleted: Bool) {
        print("[func: \(#function)][Line: \(#line)] \n isCompleted: \(transitionCompleted) ")
    }
}

public final class BlockAnimatedTransitioning: BaseAnimatedTransitioning {
    
    public typealias AnimateTransitionExecution = (TimeInterval, UIViewControllerContextTransitioning) -> Void
    public typealias AnimationEndedExecution = (Bool, UIViewControllerContextTransitioning?) -> Void
    
    var animatingExecution: AnimateTransitionExecution
    var animationEndedExecution: AnimationEndedExecution?
    
    var context: UIViewControllerContextTransitioning? = nil
    
    public init(
                _ during: TimeInterval = 0.5,
                interruptible: Bool = false,
                animate: @escaping AnimateTransitionExecution,
                endedClosure: AnimationEndedExecution? = nil) {
        self.animatingExecution = animate
        self.animationEndedExecution = endedClosure
        super.init(during, interruptible: interruptible)
    }
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let during = transitionDuration(using: transitionContext)
        self.context = transitionContext
        animatingExecution(during, transitionContext)
    }
    
    public override func animationEnded(_ transitionCompleted: Bool) {
        if let ended = animationEndedExecution {
            ended(transitionCompleted, context)
        }
        print("[func: \(#function)][Line: \(#line)] \n isCompleted: \(transitionCompleted) ")
    }
}
