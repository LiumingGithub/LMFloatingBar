//
//  FloatingKeeperInr.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit

open class FloatingKeeperPopTransation: BaseAnimatedTransitioning {
    struct Constant {
        static let defaultTransationDuring: TimeInterval  = 0.3
        static let defaultInteractiveDuring: TimeInterval = 0.5
    }
    
    public enum UponAnimationType: Int{
        case fromLeft = 0, fromRight
    }
    
    /// animation configuration
    open var uponAnimationType: UponAnimationType  = .fromRight
    open var underAnimationType: FrameAniTransitionProducer.UnderAnimationType = .crowd
    open var timeFunction: TransitionConfiguration.TimeFunction = .easeInOut
    open var shadowEnabled = true
    
    /// 是否支持 interactive
    open override var isInterruptible: Bool {
        get { return true }
        set { }
    }
    
    // MARK: -animate
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let uponVC = transitionContext.viewController(forKey: .from),
            let underVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let during = transitionDuration(using: transitionContext)
        
        let uponView: UIView = uponVC.view
        let underView: UIView = underVC.view
        
        // uponView 动画前后 frame 计算
        let uponInitialFrame = transitionContext.initialFrame(for: uponVC)
        let uponFinalFrame = uponAnimationType.animatedFrame(from: uponInitialFrame)
        
        // underView 动画前后 frame 计算
        let underFinalFrame = transitionContext.finalFrame(for: underVC)
        underView.frame = underAnimationType.animatedFrame(from: underFinalFrame, uponAnimationType.asFrameAnimationType)
        
        //添加阴影效果
        if shadowEnabled { addShadow(For: uponView) }
        
        // 是否被加入到浮窗的标识
        var wasKeeped = false
        
        UIView.animate(withDuration: during, delay: 0, options: timeFunction.asAnimationOptions, animations: {
            transitionContext.containerView.insertSubview(underView, at: 0)
            uponView.frame = uponFinalFrame
            underView.frame = underFinalFrame
        }, completion: { (_) in
            // 如果被添加到浮窗，这就不能再调用 transitionContext.completeTransition(_)
            if wasKeeped { return }
            
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
        
        guard let coordinator = uponVC.transitionCoordinator else { return }
        coordinator.notifyWhenInteractionCancelled { [weak self](context) in
            // 检查是否被加入到了浮窗
            guard let strongSelf = self,
                case let .some(keptVC) = FloatingKeeperManager.shared.current,
                keptVC == uponVC else { return }
            // 如果加入到浮窗，修改wasKeeped， 并执行新的动画
            wasKeeped = true
            
            // 执行动画
            strongSelf.animateForwardFloatingBar(
                transitionContext,
                during: Constant.defaultInteractiveDuring,
                animateView: uponView,
                finalFrame: uponInitialFrame,
                keptVC: keptVC)
        }
    }
    
    // MARK: - private
    /// 添加到floatingbar的动画效果
    private func animateForwardFloatingBar(
        _  transitionContext: UIViewControllerContextTransitioning,
        during: TimeInterval,
        animateView: UIView,
        finalFrame: CGRect,
        keptVC: AnyFloatingKeepAble) -> Void {
        
        // 时间变换
        let timefunc = self.timeFunction

        // 跟随可见部分重绘图片的layer
        let imageLayer = LMSimpleImageLayer()
        imageLayer.backgroundColor = FloatingKeeperManager.shared.floatingBackgroundColor.cgColor
        imageLayer.frame = animateView.bounds
        imageLayer.imageToDraw = FloatingKeeperManager.shared.floatingBarImage?.cgImage
        animateView.layer.addSublayer(imageLayer)
        
        // floatingbar 当前状态
        let floatingBarFrame = FloatingKeeperManager.shared.floatingBarFrameOfCurrent
        let raduis = floatingBarFrame.width * 0.5
        let imageOffset = FloatingKeeperManager.shared.floatingBarImageOffset
        // 在view移动回uponInitialFrame 的过程中，使用mask动画，
        // 形成移动和frame渐变的效果
        UIView.animate(withDuration: during, animations: {
            animateView.frame = finalFrame
            UIView.performWithoutAnimation {
                let mask = AnimatableBlockMaskView.init(animationDuring: during, animate: { (percent, rect) -> ShapeConvertable in
                    // 对percent应用时间变换
                    let newpercent = timefunc.tranform(from: percent)
                    // 计算当前mask的范围
                    let maskdrawRect = rect.lm.transform(to: floatingBarFrame, percent: newpercent)
                
                    //根据mask的范围，在中心绘制图片，并应用透明度渐变效果
                    let opacity = Float(newpercent) * 3
                    if opacity > 0.5 {
                        let imagerect = maskdrawRect.lm.center(of: floatingBarFrame.size).insetBy(dx: imageOffset, dy: imageOffset)
                        imageLayer.rectOfImageInLayer = imagerect
                    }
                    imageLayer.opacity = opacity > 1 ? 1 : opacity
                    
                    return CGPath(roundedRect: maskdrawRect, cornerWidth: raduis, cornerHeight: raduis, transform: nil)
                })
                mask.frame = animateView.bounds
                animateView.mask = mask
            }
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(100), execute: {
                //动画结束后发通知
                NotificationCenter.default.post(name: .lm_didKeptByFloatingBar, object: keptVC)
                FloatingKeeperManager.shared.didReceived(keptVC)
                // 动画结束会必须调用此方法
                transitionContext.completeTransition(true)
                //清除动画残留
                animateView.mask = nil
                imageLayer.removeFromSuperlayer()
            })
        })
    }
    
    /// 阴影效果
    private func addShadow(For view: UIView) -> Void {
        switch uponAnimationType {
        case .fromRight:
            view.layer.shadowOffset = CGSize.init(width: 0, height: -6)
        default:
            view.layer.shadowOffset = CGSize.init(width: 0, height: 6)
        }
        view.layer.shadowOpacity = 0.44
        view.layer.shadowRadius = 13
    }
    
}

extension FloatingKeeperPopTransation.UponAnimationType {
    public func animatedFrame(from frame: CGRect) -> CGRect {
        switch self {
        case .fromLeft:
            return frame.offsetBy(dx: -frame.maxX, dy: 0)
        case .fromRight:
            return frame.offsetBy(dx: frame.maxX, dy: 0)
        }
    }
    public var asFrameAnimationType: FrameAniTransitionProducer.UponAnimationType {
        return FrameAniTransitionProducer.UponAnimationType(rawValue: rawValue)!
    }
}
