//
//  CGPathConvertable.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/15.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

public typealias Shape = CGPath
public typealias MutableShape = CGMutablePath

public protocol ShapeConvertable {
    
    func asShape() -> Shape
}

extension ShapeConvertable {
    
    public func asMutableShape() -> MutableShape {
        return asShape().asMutableShape()
    }
}

extension Shape: ShapeConvertable {
    public func asShape() -> Shape {
        return self
    }
}

extension UIBezierPath: ShapeConvertable {
    public func asShape() -> Shape {
        return cgPath
    }
}

// MARK
/// a ShapeProducer can conbine any other ShapeConvertable
public protocol ShapeComposable {
    
    func asMutableShape() -> MutableShape
    
    func compose(other: ShapeConvertable) -> MutableShape
}

extension ShapeComposable where Self: Shape {
    
    public func asMutableShape() -> MutableShape {
        let mutl = MutableShape()
        mutl.addPath(self)
        return mutl
    }
    
    public func compose(other: ShapeConvertable) -> MutableShape {
        let mult = asMutableShape()
        mult.addPath(asShape().asShape())
        return mult
    }
}

extension ShapeComposable where Self: MutableShape {
    
    public func asMutableShape() -> MutableShape {
        return self
    }
    
    public func compose(other: ShapeConvertable) -> MutableShape {
        addPath(other.asShape())
        return self
    }
    
    public func compose(shapeMaker execute: () -> ShapeConvertable) -> MutableShape {
        return compose(other: execute())
    }
}

extension Shape: ShapeComposable {
    public func compose(anyOtherShapes shapes: [ShapeConvertable]) -> MutableShape {
        return shapes.reduce(asMutableShape()) { $0.compose(other: $1) }
    }
}

//MARK: -
/// draw one shape or amount of shape into a CAShapeLayer instance
extension CAShapeLayer {
    
    public func draw(anyShape: ShapeConvertable) -> Void {
        self.path = anyShape.asShape()
    }
    
    public func draw(anyShapes: [ShapeConvertable],
                     into aMutableShape: MutableShape? = nil) -> Void {
        draw(anyShape: (aMutableShape ?? MutableShape()).compose(anyOtherShapes: anyShapes))
    }
    
    public func draw(shapeMaker execute: () -> ShapeConvertable) -> Void {
        draw(anyShape: execute())
    }
    
    public func drawInherit(shapeMaker execute: () -> ShapeConvertable) -> Void {
        if let old = path?.copy() {
            draw(anyShape: old.asMutableShape().compose(shapeMaker: execute))
        }else {
            draw(shapeMaker: execute)
        }
    }
}
