//
//  RectDivider.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/18.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

public enum RectDivider {
    
    public enum DividerType {
        // 按百分比切割
        case percent(CGFloat)
        
        // 直接按给定长度切割
        case direct(CGFloat)
    }
    
    //上下切分，取上部
    case top(DividerType)
    
     //上下切分，取下部
    case bottom(DividerType)
    
    //左右切分，取右部
    case right(DividerType)
    
    //左右切分，取左部
    case left(DividerType)
}

extension RectDivider.DividerType {
    
    fileprivate func distance(From length: CGFloat) -> CGFloat {
        switch self {
        case .percent(let percent):
            return length * percent
        case .direct(let distance):
            return distance
        }
    }
}

extension RectDivider {
    
    //返回拆分出来的 rect
    public func divedeRect(_ rectToDiveded: CGRect) -> CGRect {
        switch self {
        case .top(let type):
            let distance = type.distance(From: rectToDiveded.height)
            return rectToDiveded.lm.creatNewRect {
                $0.size.height = distance
            }
        case .left(let type):
            let distance = type.distance(From: rectToDiveded.width)
            return rectToDiveded.lm.creatNewRect {
                $0.size.width = distance
            }
        case .bottom(let type):
            let distance = type.distance(From: rectToDiveded.height)
            let originY = rectToDiveded.maxY - distance
            return rectToDiveded.lm.creatNewRect {
                $0.origin.y = originY
                $0.size.height = distance
            }
        case .right(let type):
            let distance = type.distance(From: rectToDiveded.width)
            let originX = rectToDiveded.maxX - distance
            return rectToDiveded.lm.creatNewRect {
                $0.origin.x = originX
                $0.size.width = distance
            }
        }
    }
    
    //返回拆分后剩余的rect
    public func rectAfterDivision(_ rectToDiveded: CGRect) -> CGRect {
        switch self {
        case .top(let type):
            let distance = rectToDiveded.height - type.distance(From: rectToDiveded.height)
            return RectDivider.bottom(.direct(distance)).divedeRect(rectToDiveded)
        case .left(let type):
            let distance = rectToDiveded.width - type.distance(From: rectToDiveded.width)
            return RectDivider.right(.direct(distance)).divedeRect(rectToDiveded)
        case .bottom(let type):
            let distance = rectToDiveded.height - type.distance(From: rectToDiveded.height)
            return RectDivider.top(.direct(distance)).divedeRect(rectToDiveded)
        case .right(let type):
            let distance = rectToDiveded.width - type.distance(From: rectToDiveded.width)
            return RectDivider.left(.direct(distance)).divedeRect(rectToDiveded)
        }
    }
}

