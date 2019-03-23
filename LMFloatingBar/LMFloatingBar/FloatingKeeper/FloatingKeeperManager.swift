//
//  Manager.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/22.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

// 实现次协议并, 传给FloatingKeeperManager, 即可接入自定义的Floating bar 效果
public protocol FloatingBarManagerType {
    
    /// 将要添加到floatingbar，并准备执行动, 这时候需要去设定floatingbar位置,图片,图片偏移等
    func manager(_ manager: FloatingKeeperManager, willReceive keepable: AnyFloatingKeepAble) -> Void
    
    /// 动画执行完毕
    func manager(_ manager: FloatingKeeperManager, didReceived keepable: AnyFloatingKeepAble) -> Void
}

// MARK: -
public class FloatingKeeperManager {
    
    /// singleton
    public static let shared = FloatingKeeperManager()
    private init() { }
    
    /// 管理floatingBar的对象
    open var floatingBarManager: FloatingBarManagerType? = GeneralFloatingBarManager.shared
    
    /// current floatingBar state
    /// 需要在每次的 manager(_:willReceive:) 方法中设定
    public var floatingBarImage: UIImage?
    public var floatingBackgroundColor = UIColor.gray
    public var floatingBarImageOffset: CGFloat = 0
    public var floatingBarFrameOfCurrent: CGRect = CGRect.zero
    
    ///当前添加的ViewController
    fileprivate var _previousOne: AnyFloatingKeepAble?
    public internal(set) var current: AnyFloatingKeepAble?
    
    // MARK: - KeepAble
    open func willReceive(_ element: AnyFloatingKeepAble) -> Void {
        
        if let old = current {
            print("old:\(old.classForCoder) will be override")
            _previousOne = old
        }
        print("new:\(element.classForCoder) will be append to keeper")
        
        if let manager = floatingBarManager {
            manager.manager(self, willReceive: element)
        }
        current = element
    }
    
    open func didReceived(_ element: AnyFloatingKeepAble) -> Void {
        if let old = _previousOne {
            print("old:\(old.classForCoder) be overrided")
        }
        _previousOne = nil
        print("new:\(current!.classForCoder) be append to keeper")
        
        if let manager = floatingBarManager {
            manager.manager(self, didReceived: element)
        }
    }
    
    open func restoreKeeper() -> Void {
        current = _previousOne
    }
    
    // MARK: -
    public func showCurrentKeepAble(_ rectInWindow: CGRect) -> Void {
        floatingBarFrameOfCurrent = rectInWindow
        NotificationCenter.default.post(name: .lm_shouldReShowKeepAble, object: current)
    }
}

