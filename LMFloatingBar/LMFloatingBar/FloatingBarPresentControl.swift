//
//  File.swift
//  LMFloatingBar
//
//  Created by 刘明 on 2019/3/24.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit

extension NameSpaceWrapper where T: UIViewController {
    
    public func reShow(_ viewControllerToPresent: UIViewController,
                       animated flag: Bool,
                       completion:(() -> Void)?) -> Void
    {
        FloatingBarPresentControl.shared.presentAnimate(from: value, to: viewControllerToPresent, animated: flag, completion: completion)
    }
}

// 浮窗的present效果实现
public class FloatingBarPresentControl: NSObject, PresentationInteractiveControlType, UIViewControllerTransitioningDelegate {
    
    // singleton
    public static let shared = FloatingBarPresentControl()
    private override init() {
        super.init()
    }
    
    // properties
    var timeFunc = TransitionConfiguration.TimeFunction.easeIn
    
    open var draggingEdge: InteractiveDraggingEdge?
    open var draggingGesture: UIPanGestureRecognizer? {
        didSet {
            if let t = draggingGesture {
                print("\(t)")
            } else {
                print(" null ")
            }
        }
    }
    
    // MARK: -
    public func presentAnimate(from fromVC: UIViewController, to toVC: UIViewController, animated flag: Bool, completion:(() -> Void)?) -> Void {
        toVC.transitioningDelegate = self
        toVC.modalPresentationStyle = .overFullScreen
        fromVC.present(toVC, animated: flag, completion: completion)
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = draggingGesture {
            let animation = FloatingKeeperDismissTransation(0.3)
            animation.uponAnimationType = .fromRight
            animation.underAnimationType = .crowd
            animation.timeFunction = .easeInOut
            return animation
        }
        
        let floatingBarCurrentFrame = FloatingKeeperManager.shared.floatingBarFrameOfCurrent
        GeneralFloatingBarManager.shared.setFloatingHidden(false, animate: true)
        return produceMaskAnimation(dismissed, initialFrame: floatingBarCurrentFrame, isforPresented: false)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let floatingBarCurrentFrame = FloatingKeeperManager.shared.floatingBarFrameOfCurrent
        GeneralFloatingBarManager.shared.setFloatingHidden(true, animate: true)
        return produceMaskAnimation(presented, initialFrame: floatingBarCurrentFrame, isforPresented: true)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        defer {
            draggingGesture = nil
        }
        if let gesture = draggingGesture, let edge = draggingEdge {
            return FloatingBarPresentInteractive(gesture, draggingEdge: edge)
        }
        return nil
    }
    
    // MARK: - 生成从floatingbar位置的 mask 动画
    fileprivate func produceMaskAnimation(
        _ uponViewController: UIViewController,
        initialFrame: CGRect,
        transitionDuring: TimeInterval = 0.3,
        isforPresented: Bool) -> UIViewControllerAnimatedTransitioning {
        
        let timefuc = self.timeFunc
        return BlockAnimatedTransitioning(transitionDuring, interruptible: false, animate: { (during, context) in
            let uponView: UIView = uponViewController.view
            
            let uponViewFinalFrame = context.finalFrame(for: uponViewController)
            let radius = initialFrame.width * 0.5
            
            // 如果这里frame不做任何改变, animate直接就到completion
            uponView.frame = uponViewFinalFrame.insetBy(dx: 0.5, dy: 0.5)
            
            UIView.animate(withDuration: during, animations: {
                if isforPresented { context.containerView.addSubview(uponView) }
                uponView.frame = uponViewFinalFrame
                
                UIView.performWithoutAnimation {
                    let mask = AnimatableBlockMaskView(animationDuring: during, automaticallyFire: true, animate: { (percent, rect) -> ShapeConvertable in
                        
                        let realPercent = isforPresented ? percent : (1 - percent)
                        //应用timeFunc
                        let newRect = initialFrame.lm.transform(to: rect, percent: timefuc.tranform(from: realPercent))
                        
                        return CGPath(roundedRect: newRect, cornerWidth: radius, cornerHeight: radius, transform: nil)
                    })
                    uponView.mask = mask
                    mask.frame = uponView.bounds
                }
                
            }, completion: { (_) in
                uponView.mask = nil
                let wasCancelled = context.transitionWasCancelled
                context.completeTransition(!wasCancelled)
            })
            
        }, endedClosure: nil)
    }
}

class FloatingKeeperDismissTransation: FloatingKeeperPopTransation {
    override func shouldPerformNextAnimation(for uponVC: UIViewController) -> Bool {
        if let current = FloatingKeeperManager.shared.current {
            FloatingKeeperManager.shared.willReceive(current)
            return true
        }
        return false
    }
}
