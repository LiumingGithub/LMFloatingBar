//
//  NavigationAnimating.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

// MARK: Transitioning Animation Only
public protocol NavigationTransitionControlType {
    
    // 生成Transition动画，使用协定定义，便于替换和扩展
    var aniTransitionProducer: AniTransitionProducerType { get}
}

extension NavigationTransitionControlType where Self: UINavigationControllerDelegate {
    
    public func noobj_naviController(
        _ naviController: UINavigationController,
        _ operation: UINavigationController.Operation,
        _ fromVC: UIViewController,
        _ toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return aniTransitionProducer.animation(from: fromVC, to: toVC, For: TransitionConfiguration.Direction(operation))
    }
}
