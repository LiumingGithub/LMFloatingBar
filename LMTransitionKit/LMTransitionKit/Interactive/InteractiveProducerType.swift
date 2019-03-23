//
//  int.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/17.
//  Copyright © 2019 com.ming. All rights reserved.
//
//  与Transition动画类似, InteractiveTransition 也使用工厂类生产
//  便于扩展

import UIKit

/// Interactive 手势添加的方位，
/// 对应 UIScreenEdgePanGestureRecognizer的 UIRectEdge
public enum InteractiveDraggingEdge: Int {
    case top = 0, bottom, left, right
    public var asRectEdge: UIRectEdge {
        switch self {
        case .top:      return .top
        case .bottom:   return .bottom
        case .left:     return .left
        case .right:    return .right
        }
    }
}

// 根据uppon Viewcontroller动画的方向,和是否 push & pop，推荐拖动手势方向
extension FrameAniTransitionProducer.UponAnimationType {
    public func recommendInteractiveEdge(for direction: TransitionConfiguration.Direction) -> InteractiveDraggingEdge? {
        switch (self, direction) {
        case (.fromRight, .backward), (.fromLeft, .forward):  return .left
        case (.fromLeft, .backward), (.fromRight, .forward):  return .right
        case (.fromTop, .backward), (.fromBottom, .forward):  return .bottom
        case (.fromBottom, .backward), (.fromTop, .forward):  return .top
        default: return nil
        }
    }
}

//Interactive动画工厂类协议
public protocol InteractiveProducerType {
    
    // Interactive动画 支持的手势方向
    // 与Transition动画的interruptible是有区别的
    // 必须是Transition动画interruptible 为true， 并且手势方向在supportEdges之内才会生成Interactive动画
    var supportEdges: [InteractiveDraggingEdge] { get }
    
    //Interactive动画生成方法
    func interactionControllerFor(
        _ animationController: UIViewControllerAnimatedTransitioning,
        draggingGesture: UIPanGestureRecognizer,
        draggingEdg: InteractiveDraggingEdge) -> UIViewControllerInteractiveTransitioning?
}




