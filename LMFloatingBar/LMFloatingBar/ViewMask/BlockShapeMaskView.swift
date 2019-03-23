//
//  BlockShapeMakerMaskView.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import LMTransitionKit

public final class BlockShapeMaskView: BaseShapeMaskView {
    
    public typealias ShapeMakingExecution = (CGRect) -> ShapeConvertable
    public var shapemaker: ShapeMakingExecution? = nil
    
    public convenience init(execute: @escaping ShapeMakingExecution) {
        self.init(frame: CGRect.zero)
        self.shapemaker = execute
    }
    
    public override func makeShape(inRect rect: CGRect) -> ShapeConvertable {
        if let closure = shapemaker {
            return closure(rect)
        }
        return super.makeShape(inRect: rect)
    }
}

public class ImageLayer: CALayer {
    
    struct Constant {
        static let text: NSString = "刘"
    }
    
    let image: UIImage?
    
    var imageRect: CGRect = CGRect.zero
    
    public init(_ image: UIImage? = nil) {
        self.image = image
        super.init()
//        prepareDrawing()
    }
    public override init(layer: Any) {
        image = nil
        super.init(layer: layer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        image = nil
        super.init(coder: aDecoder)

    }
    
    public override func display() {
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        draw(in: ctx)
    }
    
    public override func draw(in ctx: CGContext) {
        
        guard let cgLayer = CGLayer(ctx, size: imageRect.size, auxiliaryInfo: nil),
        let cgLayerContex = cgLayer.context else { return }
        cgLayerContex.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
        UIGraphicsPushContext(cgLayerContex)
        let font = UIFont.systemFont(ofSize: 20)
        Constant.text.draw(in: imageRect, withAttributes: [NSAttributedString.Key.font: font])
        UIGraphicsPopContext()
        
        ctx.translateBy(x: imageRect.width * 0.5, y: imageRect.height * 0.5)
        
        for i in 0...9 {
            ctx.rotate(by: LMGlobalConstant.Circle.degree_180 / CGFloat(10 * i * 2))
            ctx.draw(cgLayer, at: CGPoint.zero)
        }
        
    }
    
    public func drawImage(inRect: CGRect) -> Void {
        setNeedsDisplay()
    }
    
}
