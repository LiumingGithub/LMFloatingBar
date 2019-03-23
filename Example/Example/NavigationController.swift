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
        
        interactivePopGestureRecognizer?.delegate = self
        
        addNotification()
    }
    
    deinit {
        removeNotification()
    }
    
    // MARK: - Notifer
    func addNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(NavigationController.reshowKeepable(_:)), name: .lm_shouldReShowKeepAble, object: nil)
    }
    
    func removeNotification() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reshowKeepable(_ notification: Notification) -> Void {
        if let keepAble = notification.object as? AnyFloatingKeepAble {
            let viewcontroller = PushedContainerViewController(keepAble)
            lm.preset(UINavigationController(rootViewController: viewcontroller), animated: true, completion: nil)
        }
    }
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return isInteractivePopEnabled && viewControllers.count > 1
    }
}

class PushedContainerViewController: UIViewController {
    
    var keepAbleChild: AnyFloatingKeepAble!
    
    public init(_ keepAbleChild: AnyFloatingKeepAble) {
        self.keepAbleChild = keepAbleChild
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(keepAbleChild)
        view.addSubview(keepAbleChild.view)
        keepAbleChild.willMove(toParent: self)
        
        navigationItem.title = "Presented"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PushedContainerViewController.doClosed))
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        keepAbleChild.view.bounds = view.bounds
    }
    
    // MARK: -
    deinit {
        print("func:[\(#function)], class: [\(self.classForCoder)]")
    }
    
    // MARK: - actions
    @objc func doClosed() -> Void {
        (navigationController ?? self).dismiss(animated: true, completion: nil)
        GeneralFloatingBarManager.shared.setFloatingHidden(false, animate: true)
    }
}

