//
//  NavigationController.swift
//  Example
//
//  Created by 刘明 on 2019/3/23.
//  Copyright © 2019 刘明. All rights reserved.
//

import LMTransitionKit
import LMFloatingBar

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    open var isInteractivePopEnabled = false
    
    /*
     //普通转场动画控制器初始化方法
     let generateControl: GeneralTransitionControl = {
     //transaction动画
     let transactionProducer = FrameAniTransitionProducer()
     //设置动画效果
     transactionProducer.underAnimationType = .pushed
     transactionProducer.uponAnimationType = .fromLeft
     
     //interactive动画
     let interactiveProducer = GeneralInteractiveProducer()
     
     return GeneralTransitionControl(aniTransitionProducer: transactionProducer, interactiveProducer: interactiveProducer)
     }()
     */
    
    // 微信悬浮窗效果的转场动画控制器
    let floatingControl: FloatingKeeperControl = {
        let control = FloatingKeeperControl()
        // 设定需要动画效果
        control.floatingTransitionProducer.underAnimationType = .squeezed
        control.floatingTransitionProducer.uponAnimationType = .fromRight
        
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.black
        
        // 设定好转场动画控制器之后，设置为UINavigationController 的delegate
        // 若已设置, 则需要实现NavigationInteractiveControlType，并
        // 重写 navigationController(_:animationControllerFor:from:to:) 和 navigationController(_:interactionControllerFor:)方法，
        // 可参照 GeneralTransitionControl
        delegate = floatingControl
        
        FloatingKeeperManager.shared.floatingBarPresenthandler = self
        
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension NavigationController: FloatingBarPresentHandler {
    
    func willReShow(_ keepAble: AnyFloatingKeepAble) -> UIViewController? {
        return self
    }
}
