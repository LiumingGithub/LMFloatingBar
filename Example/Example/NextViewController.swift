//
//  NextViewController.swift
//  Example
//
//  Created by 刘明 on 2019/3/23.
//  Copyright © 2019 刘明. All rights reserved.
//

import LMTransitionKit
import LMFloatingBar

// 普通ViewController，只应用转场动画 (如果没有禁用系统自带的侧滑返回，还是会使用系统的)
class NextViewController: UIViewController {
    
    public let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            imageView.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            imageView.frame = view.bounds
        }
    }
    
    deinit {
        print("func:[\(#function), class:[\(self.classForCoder)]]")
    }
}

// 支持自定义的侧滑返回
class InteractiveViewController: NextViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 根据转场动画的方向，来判断侧滑返回手势添加的位置
        // 如果是确定的方向，直接设定方向添加即可
        if let control = navigationController?.delegate as? NavigationInteractiveControlType,
            let producer = control.aniTransitionProducer as? FloatingKeepTransitionProducer
            {
            let edg: InteractiveDraggingEdge
            switch producer.uponAnimationType {
            case .fromLeft:
                edg = .right
                break
            default:
                edg = .left
                break
            }
            if let gesture = lm.interactivePop(edg) {
                view.addGestureRecognizer(gesture)
            }
        }
    }
}

class FloatingAbleViewController: InteractiveViewController, FloatingKeepAble {
    
    var floatingBarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(FloatingAbleViewController.willMoveToFloatingBar(_:)), name: .lm_willKeptByFloatingBar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FloatingAbleViewController.didMoveToFloatingBar(_:)), name: .lm_didKeptByFloatingBar, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification
    @objc func willMoveToFloatingBar(_ notification: Notification) -> Void {
        print("[\(self.classForCoder)] will be kept by floating bar")
    }
    
    @objc func didMoveToFloatingBar(_ notification: Notification) -> Void {
        print("[\(self.classForCoder)] Was kept by floating bar")
    }
}

extension FloatingAbleViewController: FloatingKeepAbleReloading {
    
    func didReloadInNavigationController(_ naviController: UINavigationController) {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(FloatingAbleViewController.didCancellReShow))
        navigationItem.title = "ReShow FloatingAble"
        naviController.navigationBar.barStyle = .default
    }
    
    @objc func didCancellReShow() -> Void {
        lm.floatingNavigationController!.dismiss(animated: true, completion: nil)
    }
}
