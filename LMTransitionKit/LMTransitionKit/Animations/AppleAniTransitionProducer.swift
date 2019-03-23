//
//  AppleAnimatedTransitioning.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

// 生成系统自带Transition动画的工厂类
public final class AppleAniTransitionProducer: AniTransitionProducerType {
    
    public enum AnimationType: Int {
        case curl = 0, flipVertical, flipHorizontal,crossDissolve
    }
    
    /// animation configuration
    public var animationType: AnimationType = .flipVertical
    public var timeFunction: TransitionConfiguration.TimeFunction = .easeInOut
    
    // MARK: - produce animation
    public func animation(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        For direction: TransitionConfiguration.Direction) -> UIViewControllerAnimatedTransitioning? {
        
        if case .unknown = direction {
            return nil
        }
        
        let appearingView: UIView = toVC.view
        
        //  animation options from configuration
        var options = animationType.appleAnimation(for: direction)
        options.formUnion(timeFunction.asAnimationOptions)
        
        let animation = BlockAnimatedTransitioning(animate: {
            (during, context) in
            UIView.transition(with: context.containerView, duration: during, options: options, animations: {
                context.containerView.addSubview(appearingView)
            }) { (_) in
                let wasCancelled = context.transitionWasCancelled
                context.completeTransition(!wasCancelled)
            }
        })
        
        return animation
    }
}

extension AppleAniTransitionProducer.AnimationType {
    
    fileprivate func appleAnimation(for direction: TransitionConfiguration.Direction) -> UIView.AnimationOptions {
        switch (direction, self) {
        case (.forward, .curl):                 return [.transitionCurlUp]
        case (.forward, .flipVertical):         return [.transitionFlipFromTop]
        case (.forward, .flipHorizontal):       return [.transitionFlipFromLeft]
        case (.forward, .crossDissolve):        return [.transitionCrossDissolve]
        case (.backward, .curl):                return [.transitionCurlDown]
        case (.backward, .flipVertical):        return [.transitionFlipFromBottom]
        case (.backward, .flipHorizontal):      return [.transitionFlipFromRight]
        case (.backward, .crossDissolve):       return [.transitionCrossDissolve]
        default:
            return []
        }
    }
}
