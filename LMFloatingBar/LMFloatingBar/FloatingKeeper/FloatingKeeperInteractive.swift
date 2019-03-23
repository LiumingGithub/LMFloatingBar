//
//  WXGestureInteractiveTransition.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/18.
//  Copyright © 2019 com.ming. All rights reserved.
//

import LMTransitionKit

/// 仿微信的效果，在
open class FloatingKeeperInteractive: BaseGestureInteractive {
    
    struct Constant {
        static let buttonSize = FloatingKeeperButton.Constant.recommendSize
        static let minShowingPercent: CGFloat = 0.15
        static let ShowingPercentDistance: CGFloat = 0.3
    }
    
    lazy var wantsKeepedBtn: FloatingKeeperButton = {
        let button = FloatingKeeperButton()
        button.setTitle("浮窗", for: .normal)
        button.setTitle("松开添加浮窗", for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.forDraggingEdge = draggingEdge
        return button
    }()
    
    // 右下角按钮的final frame,
    // 按钮在动画中的位置根据此frame计算
    var buttonInitialFrame: CGRect = CGRect.zero
    
    // 手势是否进入了button的范围，
    // 在状态改边时执行动画
    var touchesInsideButton: Bool = false {
        didSet{
            if oldValue != touchesInsideButton {
                wantsKeepedBtn.isSelected = touchesInsideButton
            }
        }
    }
        
    //MARK: - override
    /// 在 startInteractiveTransition 给 gestur eRecognizer 添加新的action
    /// 来控制监听手势的location 是否在button范围内
    /// 同时需要在deinit中移除action
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        super.startInteractiveTransition(transitionContext)
        
        let containerBounds = transitionContext.containerView.bounds
        
        if case .right = draggingEdge {
            buttonInitialFrame = CGRect(x: -Constant.buttonSize.width, y: containerBounds.height, width: Constant.buttonSize.width, height: Constant.buttonSize.height)
        }
        else {
            buttonInitialFrame = CGRect(x: containerBounds.width, y: containerBounds.height, width: Constant.buttonSize.width, height: Constant.buttonSize.height)
        }
        // bind new action for checking the gesture move inside and outside
        // the drawerview
        gestureRecognizer.addTarget(self, action: #selector(FloatingKeeperInteractive.gestrueTouchPositionHandler(_:)))
    }
    
    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(FloatingKeeperInteractive.gestrueTouchPositionHandler(_:)))
    }
    
    // MARK: - animate wantsKeepedBtn
    open override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        pullOut(percentComplete)
    }
    
    //如果结束时，手势还在button范围内，将控制器
    //添加到 FloatingKeeperManager
    open override func finish() {
        if touchesInsideButton,
            let element = transitionContext!.viewController(forKey: .from) as? AnyFloatingKeepAble {
            NotificationCenter.default.post(name: .lm_willKeptByFloatingBar, object: element)
            FloatingKeeperManager.shared.willReceive(element)
        }
        pullIn()
        super.finish()
    }
    
    open override func cancel() {
        pullIn()
        super.cancel()
    }
    
    // MARK: gesture inside & outside drawer
    @objc private func gestrueTouchPositionHandler(_ gesture: UIPanGestureRecognizer) -> Void {
        switch gesture.state {
        case .changed:
            checkGestureTouchesInsideBtton(gesture)
            break
        default:
            break
        }
    }
    
    private func checkGestureTouchesInsideBtton(_ gesture: UIPanGestureRecognizer) -> Void {
        let container = transitionContext!.containerView
        let point = gesture.location(in: container)
        let pointforbton = container.convert(point, to: wantsKeepedBtn)
        touchesInsideButton = wantsKeepedBtn.point(inside: pointforbton, with: nil)
    }
    
    // MARK: 按钮弹出动画
    open func pullOut(_ percentComplete: CGFloat) -> Void {
        if wantsKeepedBtn.superview == nil {
            let container = transitionContext!.containerView
            container.addSubview(wantsKeepedBtn)
        }
        let offsetPecent = offsetPercent(from: percentComplete)
        let offsetX: CGFloat
        if draggingEdge == .left {
            offsetX = -Constant.buttonSize.width * offsetPecent
        }
        else {
            offsetX = Constant.buttonSize.width * offsetPecent
        }
        let offsetY = -Constant.buttonSize.height * offsetPecent
        wantsKeepedBtn.frame = buttonInitialFrame.offsetBy(dx: offsetX, dy: offsetY)
    }
    
    // 返回0～1
    // 返回0全部收起， 1全部展示
    fileprivate func offsetPercent(from percentComplete: CGFloat) -> CGFloat {
        // 低于动画范围，全部收起
        if percentComplete < Constant.minShowingPercent {
            return 0
        }
        else if percentComplete > (Constant.minShowingPercent + Constant.ShowingPercentDistance) {
            return 1
        }
        return (percentComplete - Constant.minShowingPercent) / Constant.ShowingPercentDistance
    }
    
    // 按钮收起动画
    open func pullIn() -> Void {
        UIView.animate(withDuration: 0.2, animations: {
            self.wantsKeepedBtn.frame = self.buttonInitialFrame
        }) { (_) in
            self.wantsKeepedBtn.removeFromSuperview()
        }
    }
}

