//
//  FloatingKeepAble.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    public static let lm_willKeptByFloatingBar = Notification.Name(rawValue:"notifer.willbeKeptByFloatingBar")
    
    public static let lm_didKeptByFloatingBar = Notification.Name(rawValue:"notifer.didKeepByFloatingBar")
    
    public static let lm_shouldReShowKeepAble = Notification.Name(rawValue:"notifer.shouldReShowKeepAble")
}

// a viewcontroller Confirmed this protocol
// can be append to keeper
public protocol FloatingKeepAble {
    var floatingBarImage: UIImage? { get }
}

public typealias AnyFloatingKeepAble = FloatingKeepAble & UIViewController
