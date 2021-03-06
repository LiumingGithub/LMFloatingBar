//
//  File.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/17.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

extension NameSpaceWrapper where T: UIViewController {
    
    /// 生成interactive动画手势
    /// - Parameter draggingEdge: 手势方位，详见 UIRectEdge
    /// - Parameter execution: 手势触发时，执行的方法。即 push & pop操作
    public func interactiveTransitioning (
        _ draggingEdge: InteractiveDraggingEdge,
        execution closure: @escaping () -> Void ) -> UIScreenEdgePanGestureRecognizer? {
        
        guard let navicontroller = value.navigationController,
            var interactiveControl = navicontroller.delegate as? NavigationInteractiveControlType
            else {
                return nil
        }
        
        let gesture = _InteractiveGestureRecognizer.init(target: value, action: #selector(UIViewController._interactiveGestureHandler(_:)))
        gesture.bind {
            interactiveControl.draggingEdge = draggingEdge
            interactiveControl.draggingGesture = gesture
            closure()
        }
        gesture.edges = draggingEdge.asRectEdge
        return gesture
    }
    
    /// 生成interactive动画手势，执行Pop
    /// - Parameter draggingEdge: 手势方位，详见 UIRectEdge
    public func interactivePop(_ draggingEdge: InteractiveDraggingEdge = .left) -> UIScreenEdgePanGestureRecognizer? {
        return interactiveTransitioning(draggingEdge) { [weak value] in
            guard let strongValue = value,
                let naviController = strongValue.navigationController else {
                    return
            }
            naviController.popViewController(animated: true)
        }
    }
}

extension UIViewController {
    
    @objc fileprivate func _interactiveGestureHandler(_ gesture: UIPanGestureRecognizer) -> Void {
        if let gesture = gesture as? _InteractiveGestureRecognizer,
            case .began = gesture.state {
            gesture.resume()
        }
    }
    
    public func clearInteractiveGestures() -> Void {
        if let needClear = view.gestureRecognizers?.filter({$0 is _InteractiveGestureRecognizer}) {
            needClear.forEach({ $0.removeTarget(self, action: #selector(UIViewController._interactiveGestureHandler(_:)))})
        }
    }
}

// a UIScreenEdgePanGestureRecognizer can bind execute
class _InteractiveGestureRecognizer: UIScreenEdgePanGestureRecognizer {
    
    typealias ExecuteClosure = () -> Void
    var execution: ExecuteClosure?
    
    func bind(execute closure: @escaping ExecuteClosure) -> Void {
        self.execution = closure
    }
    
    func resume() -> Void {
        execution?()
    }
}

public protocol PresentationInteractiveControlType {
    
    var draggingEdge: InteractiveDraggingEdge? { get set}
    
    var draggingGesture: UIPanGestureRecognizer? { get set }
}


extension NameSpaceWrapper where T: UIViewController {
    
    public func interactivePresentation (
        draggingEdge: InteractiveDraggingEdge,
        execution closure: @escaping () -> Void) -> UIScreenEdgePanGestureRecognizer? {
        guard let delegate = value.transitioningDelegate ?? value.presentingViewController?.transitioningDelegate,
            var interactive = delegate as? PresentationInteractiveControlType
            else {
                return nil
        }
        
        let gesture = _InteractiveGestureRecognizer(target: value, action: #selector(UIViewController._interactiveGestureHandler(_:)))
        gesture.bind {
            interactive.draggingEdge = draggingEdge
            interactive.draggingGesture = gesture
            closure()
        }
        gesture.edges = draggingEdge.asRectEdge
        return gesture
    }
    
    public func interactiveDismiss (
        _ draggingEdge: InteractiveDraggingEdge = .left,
        completion: (() -> Void)? = nil) -> UIScreenEdgePanGestureRecognizer? {
        return interactivePresentation(draggingEdge: draggingEdge){ [weak value] in
            guard let strongValue = value else {
                return
            }
            strongValue.dismiss(animated: true, completion: completion)
        }
    }
}

