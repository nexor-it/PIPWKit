//
//  PIPWKitEventDispatcher.swift
//  PIPWKit
//
//  Created by Daniele Galiotto on 28/04/2020., started by Taeun Kim on 07/12/2018.
//

import Foundation
import UIKit

open class PIPWKitEventDispatcher {
    
    private weak var rootWindow: PIPWKitWindow?
    private lazy var transitionGesture: UIPanGestureRecognizer = {
        UIPanGestureRecognizer(target: self, action: #selector(onTransition(_:)))
    }()
    
    open var pipPosition: PIPWPosition = .bottomRight
    open var pipEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    private var startOffset: CGPoint = .zero
    private var deviceNotificationObserver: NSObjectProtocol?
    
    deinit {
        deviceNotificationObserver.flatMap {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
     init(rootWindow: PIPWKitWindow) {
        self.rootWindow = rootWindow
        self.pipPosition = rootWindow.initialPosition
        self.pipEdgeInsets = rootWindow.pipEdgeInsets
        
        commonInit()
        updateFrame()
        
        switch rootWindow.initialState {
        case .full:
            didEnterFullScreen()
        case .pip:
            didEnterPIP()
        }
    }
    
    open func enterFullScreen() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.updateFrame()
        }) { [weak self] (_) in
            self?.didEnterFullScreen()
        }
    }

    open func enterPIP() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.updateFrame()
        }) { [weak self] (_) in
            self?.didEnterPIP()
        }
    }
    
    open func updateFrame() {
        guard let mainWindow = PIPWKit.mainWindow,
            let rootWindow = rootWindow else {
                return
        }
        
        switch PIPWKit.state {
        case .full:
            rootWindow.frame = mainWindow.bounds
        case .pip:
            updatePIPFrame()
        default:
            break
        }
        
        rootWindow.setNeedsLayout()
        rootWindow.layoutIfNeeded()
    }


    // MARK: - Private
    private func commonInit() {
        rootWindow?.addGestureRecognizer(transitionGesture)
        
        if let pipShadow = rootWindow?.pipShadow {
            rootWindow?.layer.shadowColor = pipShadow.color.cgColor
            rootWindow?.layer.shadowOpacity = pipShadow.opacity
            rootWindow?.layer.shadowOffset = pipShadow.offset
            rootWindow?.layer.shadowRadius = pipShadow.radius
        }
        
        if let pipCorner = rootWindow?.pipCorner {
            rootWindow?.layer.cornerRadius = pipCorner.radius
            if let curve = pipCorner.curve {
                if #available(iOS 13.0, *) {
                    rootWindow?.layer.cornerCurve = curve
                }
            }
        }
        
        deviceNotificationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                                                            object: nil,
                                                                            queue: nil) { [weak self] (noti) in
                                                                                UIView.animate(withDuration: 0.15, animations: {
                                                                                    self?.updateFrame()
                                                                                }, completion:nil)
        }
    }
    
    private func didEnterFullScreen() {
        transitionGesture.isEnabled = false
        
        let rootViewController: PIPWUsable? = rootWindow?.rootViewController as? PIPWUsable
        rootViewController?.didChangedState(.full)
    }
    
    private func didEnterPIP() {
        transitionGesture.isEnabled = true
        
        let rootViewController: PIPWUsable? = rootWindow?.rootViewController as? PIPWUsable
        rootViewController?.didChangedState(.pip)
    }
    
    private func updatePIPFrame() {
        guard let mainWindow = PIPWKit.mainWindow,
            let rootWindow = rootWindow else {
                return
        }
        
        var origin = CGPoint.zero
        let rootViewController: PIPWUsable? = rootWindow.rootViewController as? PIPWUsable
        let pipSize = rootViewController?.pipSize ?? rootWindow.pipSize
        var safeAreaInsets = UIEdgeInsets.zero
        
        if #available(iOS 11.0, *) {
            safeAreaInsets = mainWindow.safeAreaInsets
        }
                
        switch pipPosition {
        case .topLeft:
            origin.x = safeAreaInsets.left + pipEdgeInsets.left
            origin.y = safeAreaInsets.top + pipEdgeInsets.top
        case .middleLeft:
            origin.x = safeAreaInsets.left + pipEdgeInsets.left
            let vh = (mainWindow.frame.height - (safeAreaInsets.top + safeAreaInsets.bottom)) / 3.0
            origin.y = safeAreaInsets.top + (vh * 2.0) - ((vh + pipSize.height) / 2.0)
        case .bottomLeft:
            origin.x = safeAreaInsets.left + pipEdgeInsets.left
            origin.y = mainWindow.frame.height - safeAreaInsets.bottom - pipEdgeInsets.bottom - pipSize.height
        case .topRight:
            origin.x = mainWindow.frame.width - safeAreaInsets.right - pipEdgeInsets.right - pipSize.width
            origin.y = safeAreaInsets.top + pipEdgeInsets.top
        case .middleRight:
            origin.x = mainWindow.frame.width - safeAreaInsets.right - pipEdgeInsets.right - pipSize.width
            let vh = (mainWindow.frame.height - (safeAreaInsets.top + safeAreaInsets.bottom)) / 3.0
            origin.y = safeAreaInsets.top + (vh * 2.0) - ((vh + pipSize.height) / 2.0)
        case .bottomRight:
            origin.x = mainWindow.frame.width - safeAreaInsets.right - pipEdgeInsets.right - pipSize.width
            origin.y = mainWindow.frame.height - safeAreaInsets.bottom - pipEdgeInsets.bottom - pipSize.height
        }
        
        rootWindow.frame = CGRect(origin: origin, size: pipSize)
    }
    
    private func updatePIPPosition() {
        guard let mainWindow = PIPWKit.mainWindow,
            let rootWindow = rootWindow else {
                return
        }
        
        let center = rootWindow.center
        var safeAreaInsets = UIEdgeInsets.zero
        
        if #available(iOS 11.0, *) {
            safeAreaInsets = mainWindow.safeAreaInsets
        }
        
        let vh = (mainWindow.frame.height - (safeAreaInsets.top + safeAreaInsets.bottom)) / 3.0
        
        switch center.y {
        case let y where y < safeAreaInsets.top + vh:
            pipPosition = center.x < mainWindow.frame.width / 2.0 ? .topLeft : .topRight
        case let y where y > mainWindow.frame.height - safeAreaInsets.bottom - vh:
            pipPosition = center.x < mainWindow.frame.width / 2.0 ? .bottomLeft : .bottomRight
        default:
            pipPosition = center.x < mainWindow.frame.width / 2.0 ? .middleLeft : .middleRight
        }
        
        let rootViewController: PIPWUsable? = rootWindow.rootViewController as? PIPWUsable
        rootViewController?.didChangePosition(pipPosition)
    }
    
    // MARK: - Action
    @objc
    private func onTransition(_ gesture: UIPanGestureRecognizer) {
        guard PIPWKit.isPIP else {
            return
        }
        guard let mainWindow = PIPWKit.mainWindow,
            let rootWindow = rootWindow else {
            return
        }
        
        switch gesture.state {
        case .began:
            startOffset = rootWindow.center
        case .changed:
            let transition = gesture.translation(in: mainWindow)
            let rootViewController: PIPWUsable? = rootWindow.rootViewController as? PIPWUsable
            let pipSize = rootViewController?.pipSize ?? rootWindow.pipSize
            var safeAreaInsets = UIEdgeInsets.zero
            
            if #available(iOS 11.0, *) {
                safeAreaInsets = mainWindow.safeAreaInsets
            }

            var offset = startOffset
            offset.x += transition.x
            offset.y += transition.y
            offset.x = max(safeAreaInsets.left + pipEdgeInsets.left + (pipSize.width / 2.0),
                           min(offset.x,
                               (mainWindow.frame.width - safeAreaInsets.right - pipEdgeInsets.right) - (pipSize.width / 2.0)))
            offset.y = max(safeAreaInsets.top + pipEdgeInsets.top + (pipSize.height / 2.0),
                           min(offset.y,
                               (mainWindow.frame.height - (safeAreaInsets.bottom) - pipEdgeInsets.bottom) - (pipSize.height / 2.0)))

            rootWindow.center = offset
        case .ended:
            updatePIPPosition()
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.updatePIPFrame()
            }
        default:
            break
        }
    }
    
}

extension PIPWViewWindow {
    struct AssociatedKeys {
        static var pipEventDispatcher = "pipEventDispatcher"
    }
    
    var pipEventDispatcher: PIPWKitEventDispatcher? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.pipEventDispatcher) as? PIPWKitEventDispatcher }
        set { objc_setAssociatedObject(self, &AssociatedKeys.pipEventDispatcher, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setupEventDispatcher() {
        self.pipEventDispatcher = PIPWKitEventDispatcher(rootWindow: self)
    }
}
