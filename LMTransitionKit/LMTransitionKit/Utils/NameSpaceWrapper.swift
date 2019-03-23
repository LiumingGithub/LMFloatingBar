//
//  NameSpaceWrapper.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/15.
//  Copyright © 2019 com.ming. All rights reserved.
//

import Foundation

public protocol NameSpaceWrapAble { }

public protocol NameSpaceWrapper {
    
    associatedtype T
    
    var value: T { get }
}

extension NameSpaceWrapAble {
    
    public var lm: LMNameSpaceWrapper<Self> {
        return LMNameSpaceWrapper.init(self)
    }
    
    public static var lm: LMNameSpaceWrapper<Self.Type> {
        return LMNameSpaceWrapper.init(Self.self)
    }
}

public struct LMNameSpaceWrapper<T> : NameSpaceWrapper {
    
    public var value: T
    
    init(_ value: T) {
        self.value = value
    }
}

// MARK: -
extension NSObject: NameSpaceWrapAble { }
