//
//  NavigationTransitionAnimationMaker.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//
//  定义Transition动画的工厂类 的协议,
//  通过工厂类生成动画，更加灵活
//

import UIKit

///Transition动画工厂类协议
public protocol AniTransitionProducerType {
    
    /// 生成各种Transition动画
    /// - Parameter fromVC: 对应在 navigationController(_:animationControllerFor:from:to)中的fromVC。直接说就是要消失的那个
    /// - Parameter toVC: 对应在 navigationController(_:animationControllerFor:from:to)中的toVC。直接说就是要显示的那个
    /// - Parameter direction: forward对应push & present, backward对应pop & dimiss
    func animation(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        For direction: TransitionConfiguration.Direction) -> UIViewControllerAnimatedTransitioning?
    
}

extension AniTransitionProducerType {
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation(from: presenting, to: presented, For: .forward)
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController,
        from presenting: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation(from: dismissed, to: presenting, For: .backward)
    }
}

