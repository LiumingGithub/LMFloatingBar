//
//  ViewMaskAnimation.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//

import LMTransitionKit

open class BaseShapeMaskView: UIView {
    
    // is false, the animatedLayer will be the mask
    var clockwise: Bool = true {
        didSet{
            setNeedsDisplay()
        }
    }
    
    let maskColor: UIColor = .clear
    let noMaskColor: UIColor = .black
    
    // the lay in which drawing any shapes
    var animatedLayer = CAShapeLayer()
    
    // maskview needs no backgroundColor
    open override var backgroundColor: UIColor? {
        set { }
        get { return nil }
    }
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.needsDisplayOnBoundsChange = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    // MARK: - drawing func
    open override func draw(_ rect: CGRect) {
        prepareBeforeMakingShapeIn(rect)
        
        drawShapesInLayer(makeShape(inRect: rect), rect: rect)
    }
    
    /// override this method to setup animatedLayer befor draw any shape
    open func prepareBeforeMakingShapeIn(_ rect: CGRect) -> Void {
        layer.insertSublayer(animatedLayer, at: 0)
        animatedLayer.fillRule = .evenOdd
        animatedLayer.fillColor = noMaskColor.cgColor
        animatedLayer.frame = rect
        animatedLayer.masksToBounds = true
    }
    
    /// override this method to make any shape you want.
    /// Using this as the mask, only content of the view behind the shape will be visible if 'clockwise' is true,
    /// otherwise will be invisible
    open func makeShape(inRect rect: CGRect) -> ShapeConvertable {
        return CGPath.init(rect: rect, transform: nil)
    }
    
    ///use this method to draw shapes in animatedLayer directly
    public func drawShapesInLayer(_ anyShape: ShapeConvertable, rect: CGRect) -> Void {
        let clockwiseShape = Shape(rect: rect, transform: nil)
        clockwise ? animatedLayer.draw(anyShape: anyShape) : animatedLayer.draw(anyShapes: [clockwiseShape, anyShape])
    }
}

