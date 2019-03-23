//
//  Util.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/14.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

// MARK: - extensions of CGPoint
extension CGRect: NameSpaceWrapAble { }

extension NameSpaceWrapper where T == CGRect {
    
    public var bottomRightPoint: CGPoint {
        return CGPoint(x: value.maxX, y: value.maxY)
    }
    
    public var bottomLeftPoint: CGPoint {
        return CGPoint(x: value.minX, y: value.maxY)
    }
    
    public var topRightPoint: CGPoint {
        return CGPoint(x: value.maxX, y: value.minY)
    }
    
    public var topLeftPoint: CGPoint {
        return CGPoint(x: value.minX, y: value.minY)
    }
    
    public func creatNewRect(by transform:(inout CGRect) -> Void) -> CGRect {
        var rect = value
        transform(&rect)
        return rect
    }
    
    public func transform(to toRect: CGRect, percent: CGFloat) -> CGRect {
        if percent < 0 {
            return value
        }
        else if percent > 1 {
            return toRect
        }
        let x = (toRect.minX - value.minX) * percent + value.minX
        let y = (toRect.minY - value.minY) * percent + value.minY
        let width = (toRect.width - value.width) * percent + value.width
        let height = (toRect.height - value.height) * percent + value.height
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    
    public func center(of size: CGSize) -> CGRect {
        let insetX = (value.width - size.width) * 0.5
        let insetY = (value.height - size.height) * 0.5
        return value.insetBy(dx: insetX, dy: insetY)
    }
}

// MARK: - extensions of CGPoint
extension CGPoint: NameSpaceWrapAble { }

extension NameSpaceWrapper where T == CGPoint {
    
    public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint.init(x: value.x + dx, y: value.y + dy)
    }
}
