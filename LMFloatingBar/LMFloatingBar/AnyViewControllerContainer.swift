//
//  AnyViewControllerContainer.swift
//  LMFloatingBar
//
//  Created by 刘明 on 2019/3/24.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class AnyViewControllerContainer: UIViewController {
    
    public var contentChild: UIViewController!
    
    // MARK: -
    public init(contentChild: UIViewController) {
        self.contentChild = contentChild
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARk: -
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        addChild(contentChild)
        contentChild.willMove(toParent: self)
        view.addSubview(contentChild.view)
    }
    
    //MARk: -
    open override func viewDidLayoutSubviews() {
        contentChild.view.frame = view.bounds
    }
    
    //MARK: -
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        contentChild.willTransition(to: newCollection, with: coordinator)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        contentChild.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: -
    open override var navigationItem: UINavigationItem {
        return contentChild.navigationItem
    }
    open override var childForStatusBarStyle: UIViewController? {
        return contentChild
    }
    open override var childForStatusBarHidden: UIViewController? {
        return contentChild
    }
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        return contentChild
    }
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return contentChild
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return contentChild.supportedInterfaceOrientations
    }
}

