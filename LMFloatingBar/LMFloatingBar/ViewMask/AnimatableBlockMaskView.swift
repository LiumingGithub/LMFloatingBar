//
//  AnimatableShapeMaskView.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//

import LMTransitionKit

open class AnimatableBlockMaskView: BaseShapeMaskView {
    
    public typealias AnimateClosure = (CGFloat, CGRect) -> ShapeConvertable
    public typealias AnimateCompletion = (Bool) -> Void
    
    open var animateClosure: AnimateClosure? = nil
    open var completion: AnimateCompletion? = nil
    
    var displayLink: CADisplayLink?
    open var automaticallyFire: Bool = true
    open var isFired: Bool = false
    
    public internal(set) var animationDuring: TimeInterval = 0
    private var animationCost: TimeInterval = 0
    
    //MARK: - init & deinit
    public convenience init(
        animationDuring during: TimeInterval,
        automaticallyFire: Bool = true,
        animate: @escaping AnimateClosure,
        completion: AnimateCompletion? = nil) {
        self.init(frame: CGRect.zero)
        self.animationDuring = during
        self.automaticallyFire = automaticallyFire
        self.animateClosure = animate
        self.completion = completion
    }
    
    deinit {
        releaseLink()
    }
    
    //MARK: -
    func prepareDisplayLink() -> Void {
        releaseLink()
        animationCost = 0
        if let _ = animateClosure {
            displayLink = CADisplayLink.init(target: self, selector: #selector(AnimatableBlockMaskView.displayLinkHandler(_:)))
        }
    }
    
    open func fire() -> Void {
        guard !isFired, let link = displayLink else { return }
        link.add(to: RunLoop.main, forMode: .default)
    }
    
    open func releaseLink() -> Void {
        if let link = displayLink {
            link.invalidate()
        }
    }
    
    @objc func displayLinkHandler(_ link: CADisplayLink) -> Void {
        animationCost += link.duration
        if animationCost >= animationDuring {
            link.isPaused = true
            releaseLink()
            displayLinkDrawing(1)
            if let completion = completion {
                completion(true)
            }
            return
        }
        let progress = CGFloat(animationCost / animationDuring)
        displayLinkDrawing(progress)
    }
    
    open func displayLinkDrawing(_ progress: CGFloat) -> Void {
        drawShapesInLayer(animateClosure!(progress, bounds), rect: bounds)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        prepareDisplayLink()
        
        if automaticallyFire {
            fire()
        }
    }
    
    //MARK: - override
    open override func makeShape(inRect rect: CGRect) -> ShapeConvertable {
        if let closure = animateClosure {
            return closure(0, rect)
        }
        return super.makeShape(inRect: rect)
    }
}
