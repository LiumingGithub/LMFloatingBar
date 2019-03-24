//
//  FloatingBarPresentContainer.swift
//  LMFloatingBar
//
//  Created by 刘明 on 2019/3/24.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit

// 用来控制被添加到浮窗的控制器，又重新被加载的协议
public protocol FloatingKeepAbleReloading {
    func didReloadInNavigationController(_ naviController: UINavigationController) -> Void
}

extension NameSpaceWrapper where T: UIViewController {
    public var floatingNavigationController: UINavigationController? {
        if let p = value.parent as? FloatingBarPresentContainer {
            return p.navigationController
        }
        return nil
    }
}

//用来包装floatingbar点击后，重新显示的ViewController
class FloatingBarPresentContainer: AnyViewControllerContainer {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navi = navigationController else { return }
        navi.setNavigationBarHidden(false, animated: false)
        
        if let reloadingChild = contentChild as? FloatingKeepAbleReloading {
            reloadingChild.didReloadInNavigationController(navi)
        }
        
        //清除侧滑pop，添加侧滑dissmiss
        contentChild.clearInteractiveGestures()
        if let gesture = navi.lm.interactiveDismiss(.left, completion: nil) {
            contentChild.view.addGestureRecognizer(gesture)
        }
    }
    deinit {
        print("function: \(#function) class: \(self.classForCoder)")
    }
}
