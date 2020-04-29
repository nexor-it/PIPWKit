//
//  PIPWKit.swift
//  PIPWKit
//
//  Created by Daniele Galiotto on 28/04/2020., started by Taeun Kim on 07/12/2018.
//

import Foundation
import UIKit

public enum PIPWState {
    case pip
    case full
}

public enum PIPWPosition {
    case topLeft
    case middleLeft
    case bottomLeft
    case topRight
    case middleRight
    case bottomRight
}

 public enum _PIPWState {
    case none
    case pip
    case full
    case exit
}

typealias PIPWKitWindow = (UIWindow & PIPWUsable)

open class PIPWViewWindow: UIWindow, PIPWUsable {
}

open class PIPWKit {
    
    static var isActive: Bool { return floatingWindow != nil }
    static var isPIP: Bool { return state == .pip }

    static var floatingWindow: PIPWViewWindow?
    static var mainWindow: UIWindow?

    static internal var state: _PIPWState = .none
    
    class func show(with viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard !isActive else {
            dismiss(animated: false) {
                PIPWKit.show(with: viewController)
            }
            return
        }
        
        self.mainWindow = window
                                
        self.floatingWindow = PIPWViewWindow()
        self.floatingWindow?.backgroundColor = .black
        self.floatingWindow?.rootViewController = viewController
        self.floatingWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        self.floatingWindow?.makeKeyAndVisible()
        
        self.floatingWindow?.rootViewController?.view.alpha = 0.0
        
        state = (self.floatingWindow?.initialState == .pip) ? .pip : .full
        self.floatingWindow?.setupEventDispatcher()
        
        UIView.animate(withDuration: 0.25, animations: {
            PIPWKit.floatingWindow?.rootViewController?.view.alpha = 1.0
        }) { (_) in
            completion?()
        }
    }
    
    class func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        state = .exit
        self.floatingWindow?.pipDismiss(animated: animated, completion: {
            PIPWKit.reset()
            completion?()
        })
    }
    
    // MARK: - Internal
    class func startPIPMode() {
        guard let floatingWindow = self.floatingWindow else {
            return
        }
        
        // PIP
        state = .pip
        floatingWindow.pipEventDispatcher?.enterPIP()
    }
    
    class func stopPIPMode() {
        guard let floatingWindow = self.floatingWindow else {
            return
        }
        
        // fullScreen
        state = .full
        floatingWindow.pipEventDispatcher?.enterFullScreen()
    }
    
    // MARK: - Private
    private static func reset() {
        PIPWKit.state = .none
        PIPWKit.floatingWindow?.removeFromSuperview()
        PIPWKit.floatingWindow = nil
        mainWindow?.makeKeyAndVisible()
    }
    
}
