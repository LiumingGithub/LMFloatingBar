//
//  FloatingBarView.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/22.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

class FloatingBarView: UIView {
    struct Constant {
        static let floatingBarImage: UIImage = UIImage(named: "floatingBar_default")!
    }
    
    // 绘制图片的layer，相当于Imageview
    // 可以应用图片裁剪效果
    let imageLayer = LMSimpleImageLayer()
    
    // 当前显示的图片
    private var _floatingBarImage: UIImage = Constant.floatingBarImage
    public var currentImage: UIImage { return _floatingBarImage }
    
    // 图片和边界的间隔
    public var imageOffset: CGFloat = 0 {
        didSet{ setNeedsLayout() }
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }
    
    fileprivate func initialise() -> Void {
        layer.addSublayer(imageLayer)
    }
    
    // MARK: - Public
    /// 设为nil时，会清除之前的图片, 并使用默认的图片进行绘制
    public func setImage(_ image: UIImage?) -> Void {
        _floatingBarImage = image ?? Constant.floatingBarImage
        setNeedsLayout()
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        imageLayer.frame = bounds
        imageLayer.imageToDraw = currentImage.cgImage
        imageLayer.rectOfImageInLayer = bounds.insetBy(dx: imageOffset, dy: imageOffset)
        imageLayer.setNeedsDisplay()
    }
}
