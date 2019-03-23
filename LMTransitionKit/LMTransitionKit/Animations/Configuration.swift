//
//  TransitionConfiguration.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/22.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

public struct TransitionConfiguration {
    //动画方向
    public enum Direction: Int {
        case unknown = 0
        /// push & presente
        case forward
        /// pop & dismiss
        case backward
    }
    
    // 时间变化效果
    public enum TimeFunction: Int {
        case easeInOut = 0, easeIn, easeOut, linear
    }
    
}

extension TransitionConfiguration.Direction {
    // init with UINavigationController Operation
    public init(_ operation: UINavigationController.Operation) {
        switch operation {
        case .push:    self = .forward;   break
        case .pop:     self = .backward;  break
        default:       self = .unknown;   break
        }
    }
    
    // init with flag of whether the animation is for a viewController presented from another
    public init(_ isForPresenting: Bool ){
        if isForPresenting {
            self = .forward
        }
        else {
            self = .backward
        }
    }
}

extension TransitionConfiguration.TimeFunction {
    
    public var asAnimationOptions: UIView.AnimationOptions {
        switch self {
        case .easeIn:     return [.curveEaseIn]
        case .easeOut:    return [.curveEaseOut]
        case .linear:     return [.curveEaseOut]
        default:          return [.curveEaseInOut]
        }
    }
    
    // 将0～1之间线形变化的fromValue, 转换为非线形变化
    public func tranform(from fromValue: CGFloat) -> CGFloat {
        switch self {
        case .easeIn:
            return sqrt(fromValue)
        case .easeOut:
            return pow(fromValue, 2)
        case .easeInOut:
            return 0.5 - 0.5 * cos(fromValue * LMGlobalConstant.Circle.degree_180)
        default:
            return fromValue
        }
    }
}

