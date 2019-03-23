//
//  LMSimpleImageLayer.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/22.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

/// 在指定位置绘制图片的 CALayer
class LMSimpleImageLayer: CALayer {
    
    public enum ClipType {
        case none               // 无裁剪
        case radius(CGFloat)    // 裁剪为圆角
        case ellipse            // 内切圆裁剪
    }
    
    /// 裁剪方式
    public var clipType = ClipType.ellipse
    
    /// 需要绘制绘图
    public var imageToDraw: CGImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 备用图片, 当imageToDraw为nil时使用
    public var substituteImage: CGImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 绘图的位置
    private var _rectOfImage: CGRect?
    var rectOfImageInLayer: CGRect {
        get { return _rectOfImage ?? bounds }
        set {
            _rectOfImage = newValue
            setNeedsDisplay()
        }
    }
    
    // MARK: - draw layer
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        let rectToDraw = rectOfImageInLayer
        guard let image = imageToDraw ?? substituteImage,
            let cglayer = CGLayer.init(ctx, size: rectToDraw.size, auxiliaryInfo: nil),
            let cgContext = cglayer.context else {
            return
        }
        let cglayerRect = CGRect.init(origin: CGPoint.zero, size: rectToDraw.size)
        UIGraphicsPushContext(cgContext)
        // 变化CTM后图片不回颠倒
        cgContext.translateBy(x: 0, y: rectToDraw.height)
        cgContext.scaleBy(x: 1, y: -1)
        //图片裁剪
        switch clipType {
        case .ellipse:
            cgContext.addEllipse(in: cglayerRect)
            cgContext.clip()
        case .radius(let radius):
            cgContext.addPath(CGPath(roundedRect: cglayerRect, cornerWidth: radius, cornerHeight: radius, transform: nil))
            cgContext.clip()
        default:
            break
        }
        cgContext.draw(image, in:cglayerRect)
        UIGraphicsPopContext()
        
        ctx.draw(cglayer, at: rectToDraw.origin)
    }
}
