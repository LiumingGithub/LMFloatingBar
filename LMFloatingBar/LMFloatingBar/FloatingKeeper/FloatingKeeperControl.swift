//
//  FloatingKeeperControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit

public class FloatingKeepInteractiveProducer: InteractiveProducerType {
    
    public var supportEdges: [InteractiveDraggingEdge] = [.left, .right]
    
    var producer = GeneralInteractiveProducer()
    
    public func interactionControllerFor(_ animationController: UIViewControllerAnimatedTransitioning, draggingGesture: UIPanGestureRecognizer, draggingEdg: InteractiveDraggingEdge) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController is FloatingKeeperPopTransation {
            return FloatingKeeperInteractive(draggingGesture, draggingEdge: draggingEdg)
        }
        
        return producer.interactionControllerFor(animationController, draggingGesture:draggingGesture, draggingEdg: draggingEdg)
    }
    
}

public class FloatingKeepTransitionProducer: AniTransitionProducerType {
    
    open var uponAnimationType: FloatingKeeperPopTransation.UponAnimationType  = .fromRight {
        didSet {
            resetAnimation()
        }
    }
    
    open var underAnimationType: FrameAniTransitionProducer.UnderAnimationType = .squeezed {
        didSet {
            resetAnimation()
        }
    }
    
    var producer: FrameAniTransitionProducer = FrameAniTransitionProducer()
    
    public init() {
       resetAnimation()
    }
    
    fileprivate func resetAnimation() -> Void {
        producer.underAnimationType = underAnimationType
        producer.uponAnimationType = uponAnimationType.asFrameAnimationType
    }
    
    public func animation(from fromVC: UIViewController, to toVC: UIViewController, For direction: TransitionConfiguration.Direction) -> UIViewControllerAnimatedTransitioning? {
        if case .backward = direction, fromVC is FloatingKeepAble {
            let animation = FloatingKeeperPopTransation(FloatingKeeperPopTransation.Constant.defaultTransationDuring, interruptible: true)
            animation.uponAnimationType = uponAnimationType
            animation.underAnimationType = underAnimationType
            return animation
        }
        return producer.animation(from:fromVC, to:toVC, For: direction)
    }
}


open class FloatingKeeperControl: GeneralTransitionControl {
    
    open var floatingTransitionProducer: FloatingKeepTransitionProducer {
        return aniTransitionProducer as! FloatingKeepTransitionProducer
    }
    
    public init() {
        super.init(aniTransitionProducer: FloatingKeepTransitionProducer(), interactiveProducer: FloatingKeepInteractiveProducer())
    }
}
