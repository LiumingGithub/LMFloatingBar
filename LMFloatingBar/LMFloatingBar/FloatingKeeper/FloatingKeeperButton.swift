//
//  subscription.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/18.
//  Copyright © 2019 com.ming. All rights reserved.
//
//  微信版的稍后阅读按钮

import LMTransitionKit

open class FloatingKeeperButton: UIButton {
    
    struct Constant {
        static let ImageLayoutPercent: CGFloat = 0.5
        static let drawingOffset: CGFloat = 15
        static let recommendSize = CGSize(width: 150, height: 150)
    }
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect.init(style: .dark))
    
    let imageDivider = RectDivider.top(.percent(Constant.ImageLayoutPercent))
    
    var forDraggingEdge: InteractiveDraggingEdge = .left {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var isFeedbackEnabled: Bool = true
    //震动反馈
    let feedback: Any? = {
        if #available(iOS 10.0, *) {
            return UIImpactFeedbackGenerator(style: .medium)
        }
        return nil
    }()
    
    private var _offset: CGFloat = Constant.drawingOffset
    open override var isSelected: Bool {
        didSet {
            _offset = isSelected ? 0 : Constant.drawingOffset
            feedbackIfAllowed()
            setNeedsDisplay()
        }
    }
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(blurEffectView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARk: - Public
    func feedbackIfAllowed() -> Void {
        if #available(iOS 10.0, *) {
            if isSelected, let feedback = feedback as? UIImpactFeedbackGenerator {
                feedback.impactOccurred()
            }
        }
    }
    
    // MARk: - resent content rect
    open override func contentRect(forBounds bounds: CGRect) -> CGRect {
        let offset = bounds.width - bounds.width / CGFloat(sqrt(2.0))
        switch forDraggingEdge {
        case .right:
            return bounds.lm.creatNewRect(by: { (rect) in
                rect.origin.y = offset
                rect.size.width =  rect.width - offset
                rect.size.height = rect.height - offset
            })
        default:
            return bounds.lm.creatNewRect(by: { (rect) in
                rect.origin.x = offset
                rect.origin.y = offset
                rect.size.width =  rect.width - offset
                rect.size.height = rect.height - offset
            })
        }
    }
    
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return imageDivider.divedeRect(contentRect)
    }
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return imageDivider.rectAfterDivision(contentRect)
    }
    
    // MARK: 修改按钮的event 接受范围
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return contentRect(forBounds: bounds).contains(point)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = self.bounds
        let radiusOffsetX = self._offset
        
        // 使用mask 使按钮显示扇形
        let edg = forDraggingEdge
        let mask = BlockShapeMaskView { (rect) in
            let drawRect: CGRect
            switch edg {
            case .right:
                drawRect = rect.lm.creatNewRect(by: { (frame) in
                    frame.origin.x = -rect.width
                    frame.size.width = rect.width * 2
                    frame.size.height = rect.height * 2
                })
            default:
                drawRect = rect.lm.creatNewRect(by: { (frame) in
                    frame.size.width = rect.width * 2
                    frame.size.height = rect.height * 2
                })
            }
            return CGPath(ellipseIn: drawRect.insetBy(dx: radiusOffsetX, dy: radiusOffsetX), transform: nil)
        }
        
        mask.frame = self.bounds
        self.mask = mask
    }
}
