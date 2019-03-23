//
//  NavigationInteractiveTransitionControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

public protocol NavigationInteractiveControlType: NavigationTransitionControlType {
    
    // 生成侧滑动画，使用协定定义，便于替换和扩展
    var interactiveProducer: InteractiveProducerType { get }
    
    // 是否使用自定义侧滑返回
    var interactiveEnabled: Bool { get }
    
    // 每次触发侧滑返回时，需要获取侧滑返回的手势和滑动的方向
    var draggingEdge: InteractiveDraggingEdge? { get set}
    var draggingGesture: UIPanGestureRecognizer? { get set }
    
    // 将draggingGesture 设置为 nil
    // 会在每次生成InteractiveTransitioning后调用
    // 否则会有点击系统返回按钮后，卡死的bug
    func clearDraggingGesture() -> Void
}

extension NavigationInteractiveControlType where Self: UINavigationControllerDelegate {
    
    public func noobj_naviController(_ naviController: UINavigationController, _ animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        ///该处一定要将draggingGesture在返回前设置为nil，否则会出现系统返回失效的bug
        defer {
            clearDraggingGesture()
        }
        guard interactiveEnabled,
            let gesture = draggingGesture,
            let edge = draggingEdge else {
                return nil
        }
        return interactiveProducer.interactionControllerFor(animationController, draggingGesture: gesture, draggingEdg: edge)
    }
    
}


extension NavigationInteractiveControlType where Self: UINavigationController {
    
    public mutating func interactivePush(
        _ viewController: UIViewController,
        using draggingGesture: UIPanGestureRecognizer,
        draggingEdge: InteractiveDraggingEdge) -> Void {
        
        self.draggingGesture = draggingGesture
        self.draggingEdge = draggingEdge
        
        pushViewController(viewController, animated: true)
    }
    
    public mutating func interactivePop(
        using draggingGesture: UIPanGestureRecognizer,
        draggingEdge: InteractiveDraggingEdge) -> Void {
        
        self.draggingGesture = draggingGesture
        self.draggingEdge = draggingEdge
        
        popViewController(animated: true)
    }
}
