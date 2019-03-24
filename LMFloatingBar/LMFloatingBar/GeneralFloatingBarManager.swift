//
//  Manager.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/22.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

public class GeneralFloatingBarManager: UIViewController {
    struct Constant {
        struct FloatingBar {
            static let length: CGFloat = 70               // 默认边长
            static let backgroundColor = UIColor.gray     // 背景颜色
            static let imageOffset: CGFloat = 8           // 图片和边框之间的距离
            static let minOffsetToBorder: CGFloat = 15    // floatingBar到边界的最小距离
            static let initalFrame =  CGRect(x: minOffsetToBorder, y: UIScreen.main.bounds.height * 0.5, width: length, height: length) // 初始frame
            static let animateDuring: TimeInterval = 0.5  // 显示和隐藏动画时间
        }
        // 右下角浮窗按钮尺寸
        static let keepButtonSize = FloatingKeeperButton.Constant.recommendSize
        static let keepButtonAnimateDuring: TimeInterval = 0.2  // keepButton展示和收起的动画时间
    }
    
    /// singleton
    public static let shared = GeneralFloatingBarManager()
    
    // transparent Window
    let transparentWindow = _LMTransparentWindow(frame: UIScreen.main.bounds)
    
    // floatingBar
    let floatingBar: FloatingBarView = FloatingBarView()
    //floatingbar 的hidden状态
    fileprivate var _floatingBarIsHidden = true
    // 缓存floatingBar 的 frame
    fileprivate var rectOfFloatingBarStored = CGRect.zero
    
    //  右下角浮窗按钮
    var wantsKeptBtn = FloatingKeeperButton()
    // 缓存floatingBar frame
    fileprivate var wantsKeptBtnRect = CGRect.zero
    // touches是否在 wantsKeptBtn 内
    fileprivate var touchesInsideButton: Bool = false {
        didSet{
            if oldValue != touchesInsideButton {
                wantsKeptBtn.isSelected = touchesInsideButton
            }
        }
    }
    
    // MARK: -  init
    private override init(nibName nibNameOrNil: String?,
                          bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        rectOfFloatingBarStored = Constant.FloatingBar.initalFrame
        view.backgroundColor = UIColor.clear
        
        FloatingKeeperManager.shared.floatingBarManager = self
        
        // floatingBar config
        view.addSubview(floatingBar)
        floatingBar.imageOffset = Constant.FloatingBar.imageOffset
        floatingBar.layer.cornerRadius = Constant.FloatingBar.length * 0.5
        floatingBar.backgroundColor = Constant.FloatingBar.backgroundColor
        floatingBar.clipsToBounds = true
        floatingBar.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(GeneralFloatingBarManager.panGestureHandler(_:))))
        floatingBar.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(GeneralFloatingBarManager.tapGestureHandler(_:))))
        setFloatingHidden(true)
        
        // keepButton config
        view.insertSubview(wantsKeptBtn, at: 0)
        wantsKeptBtn.setTitle("浮窗", for: .normal)
        wantsKeptBtn.setTitle("松开移除浮窗", for: .selected)
        wantsKeptBtn.titleLabel?.textAlignment = .center
        wantsKeptBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        wantsKeptBtn.setTitleColor(UIColor.white, for: .normal)
        wantsKeptBtn.backgroundColor = UIColor.red
        wantsKeptBtn.blurEffectView.isHidden = true
        wantsKeptBtn.forDraggingEdge = .left
        wantsKeptBtn.isHidden = true
    }
    
    // MARK: -  ViewController Layout
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewBounds = view.bounds
        floatingBar.frame = rectOfFloatingBarStored
        
        wantsKeptBtnRect = CGRect(x: viewBounds.width, y: viewBounds.height, width: Constant.keepButtonSize.width, height: Constant.keepButtonSize.height)
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //如果横屏变成竖屏，或者竖屏变成横屏。变换rectOfFloatingBarStored的x y即可
        if newCollection.horizontalSizeClass != traitCollection.horizontalSizeClass
        || newCollection.verticalSizeClass != newCollection.verticalSizeClass {
            rectOfFloatingBarStored = CGRect.init(x: rectOfFloatingBarStored.minY, y: rectOfFloatingBarStored.minX, width: rectOfFloatingBarStored.width, height: rectOfFloatingBarStored.height)
        }
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    // MARK: - Window
    public func startWork() -> Void {
        if !isWindowVisible {
            makeWindowVisible()
        }
    }
    
    public func stop() -> Void {
        transparentWindow.isHidden = true
        clearFloatingBar()
    }
    
    public var isWindowVisible: Bool {
        return transparentWindow.rootViewController != nil &&
            !transparentWindow.isHidden
    }
    
    func makeWindowVisible() -> Void {
        if transparentWindow.rootViewController != self {
            transparentWindow.touchesDelegate = self
            transparentWindow.rootViewController = self
        }
        transparentWindow.isHidden = false
    }
    
    // MARK: - Floatingbar
    // hide & show floatingbar
    public var isFloatingHidden: Bool {
        return _floatingBarIsHidden
    }
    
    public func setFloatingHidden(_ isFloatingHidden: Bool,
                           animate: Bool = false) -> Void {
        _floatingBarIsHidden = isFloatingHidden
        
        if !isFloatingHidden {
            floatingBar.frame = rectOfFloatingBarStored
        }
    
        let targetAlpha: CGFloat = isFloatingHidden ? 0 : 1
        if animate {
            floatingBar.alpha = 1 - targetAlpha
            floatingBar.isHidden = false
            UIView.animate(withDuration: Constant.FloatingBar.animateDuring,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                self.floatingBar.alpha = targetAlpha
            }) { (_) in
                self.floatingBar.isHidden = isFloatingHidden
            }
        } else {
            floatingBar.alpha = targetAlpha
            floatingBar.isHidden = isFloatingHidden
        }
    }
    
    public func setFloatingBarAlpha(_ alpha: CGFloat) -> Void {
        floatingBar.isHidden = false
        floatingBar.alpha = alpha
    }
    
    // 根据手势位移，移动floatingbar
    func moveFloatingBar(_ gesture: UIPanGestureRecognizer) -> Void {
        let translation = gesture.translation(in: view)
        
        let targetFrame = rectOfFloatingBarStored.offsetBy(dx: translation.x, dy: translation.y)
        
        if view.bounds.contains(targetFrame) {
            floatingBar.frame = targetFrame
        }
    }
    
    /// 清除floatingbar，隐藏并还原为初始位置
    func clearFloatingBar() -> Void {
        setFloatingHidden(true)
        floatingBar.setImage(nil)
        rectOfFloatingBarStored = Constant.FloatingBar.initalFrame
    }
    
    /// 手势结束后，自动调整floatingbar位置
    func endAdjuestFloatingBarFrame() -> Void {
        //如果wantskeptButton 被选中,将清除floatingbar
        if touchesInsideButton {
            let barTargetFrame = floatingBar.frame.offsetBy(dx: Constant.keepButtonSize.width, dy: Constant.keepButtonSize.height)
            UIView.animate(withDuration: 0.2, animations: {
                self.floatingBar.frame = barTargetFrame
            }) { (_) in
                self.clearFloatingBar()
            }
            return
        }
        
        // 没有则将floatingbar 平移到靠左或者靠右
        let safeRect: CGRect
        if #available(iOS 11.0, *) {
            safeRect = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: Constant.FloatingBar.minOffsetToBorder, dy: Constant.FloatingBar.minOffsetToBorder)
        } else {
            safeRect = view.bounds.insetBy(dx: Constant.FloatingBar.minOffsetToBorder, dy: Constant.FloatingBar.minOffsetToBorder)
        }
        
        let currentBarFrame = floatingBar.frame
        var targetFrame = currentBarFrame
        
        if currentBarFrame.midX < safeRect.midX {
            targetFrame.origin.x = safeRect.minX
        }
        else {
            targetFrame.origin.x = safeRect.maxX - currentBarFrame.width
        }
        
        if currentBarFrame.minY < safeRect.minY {
            targetFrame.origin.y = safeRect.minY
        }
        else if currentBarFrame.maxY > safeRect.maxY {
            targetFrame.origin.y = safeRect.maxY - currentBarFrame.height
        }
        
        rectOfFloatingBarStored = targetFrame
        UIView.animate(withDuration: Constant.keepButtonAnimateDuring,
                       animations: {
            self.floatingBar.frame = targetFrame
        }, completion: nil)
    }
    
     // MARK: - WantsKeptButton
    /// 检查拖动手势是否进入WantsKeptButton范围
    func checkGestureTouchesInsideBtton(_ gesture: UIPanGestureRecognizer) -> Void {
        let point = gesture.location(in: view)
        let pointforbton = view.convert(point, to: wantsKeptBtn)
        touchesInsideButton = wantsKeptBtn.point(inside: pointforbton, with: nil)
    }
    
    /// WantsKeptButton弹出动画
    func pullOut() -> Void {
        let targetFrame = wantsKeptBtnRect.offsetBy(dx: -Constant.keepButtonSize.width, dy: -Constant.keepButtonSize.height)
        wantsKeptBtn.isHidden = false
        wantsKeptBtn.frame = wantsKeptBtnRect
        UIView.animate(withDuration: Constant.keepButtonAnimateDuring) {
            self.wantsKeptBtn.frame = targetFrame
        }
    }
    /// WantsKeptButton收起动画
    func pullIn() -> Void {
        let targetFrame = wantsKeptBtnRect
        UIView.animate(withDuration: Constant.keepButtonAnimateDuring,
                       animations: {
            self.wantsKeptBtn.frame = targetFrame
        }) { (_) in
            self.wantsKeptBtn.isHidden = true
            self.touchesInsideButton = false
        }
    }
    
    // MARK: - Gesture
    @objc func panGestureHandler(_ gesture: UIPanGestureRecognizer) -> Void {
        switch gesture.state {
        case .began:
            rectOfFloatingBarStored = floatingBar.frame
            pullOut()
        case .changed:
            moveFloatingBar(gesture)
            checkGestureTouchesInsideBtton(gesture)
        default:
            endAdjuestFloatingBarFrame()
            pullIn()
        }
    }
    
    @objc func tapGestureHandler(_ gesture: UITapGestureRecognizer) -> Void {
        rectOfFloatingBarStored = floatingBar.frame
        FloatingKeeperManager.shared.showCurrentKeepAble(rectOfFloatingBarStored)
    }
}

extension GeneralFloatingBarManager: _LMTransparentWindowTouchesHandling {
    public func window(_ window: UIWindow?, shouldReceiveTouchAt point: CGPoint) -> Bool {
        return window == transparentWindow && floatingBar.frame.contains(transparentWindow.convert(point, to: view))
    }
}

extension GeneralFloatingBarManager: FloatingBarManagerType {
    
    public func manager(_ manager: FloatingKeeperManager, willReceive keepable: AnyFloatingKeepAble) {
        makeWindowVisible()
        floatingBar.setImage(keepable.floatingBarImage)
        manager.floatingBarImage = floatingBar.currentImage
        manager.floatingBarFrameOfCurrent = rectOfFloatingBarStored
        manager.floatingBarImageOffset = Constant.FloatingBar.imageOffset
        manager.floatingBackgroundColor = floatingBar.backgroundColor ?? Constant.FloatingBar.backgroundColor
        setFloatingHidden(true)
    }
    
    public func manager(_ manager: FloatingKeeperManager, didReceived keepable: AnyFloatingKeepAble) {
        setFloatingHidden(false)
    }
}
