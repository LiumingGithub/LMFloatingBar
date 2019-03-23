//
//  GeneralNavigationTransitionControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class GeneralTransitionControl: NSObject, UINavigationControllerDelegate, NavigationInteractiveControlType {
    
    // MARK: - NavigationInteractiveControlType
    /// NavigationInteractiveControlType properties
    open var interactiveProducer: InteractiveProducerType
    open var aniTransitionProducer: AniTransitionProducerType
    open var interactiveEnabled: Bool = true
    open var draggingGesture: UIPanGestureRecognizer? = nil
    open var draggingEdge: InteractiveDraggingEdge? = nil
    
    /// 清除手势，该方法必须将 draggingGesture 设置为nil
    public func clearDraggingGesture() {
        draggingGesture = nil
    }
    
    // MARK: - init
    public init(
        aniTransitionProducer: AniTransitionProducerType,
        interactiveProducer: InteractiveProducerType) {
        self.aniTransitionProducer = aniTransitionProducer
        self.interactiveProducer = interactiveProducer
        super.init()
    }
    public override convenience init() {
        self.init(aniTransitionProducer:FrameAniTransitionProducer(),
                  interactiveProducer: GeneralInteractiveProducer())
    }
    
    // MARK: - UINavigationControllerDelegate 
    /// UI的各种delegate扩展真的麻烦, 这么写只为消除警告
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return noobj_naviController(navigationController, operation, fromVC, toVC)
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return noobj_naviController(navigationController, animationController)
    }
 
}
