//
//  PIPWUsable.swift
//  PIPWKit
//
//  Created by Daniele Galiotto on 28/04/2020., started by Taeun Kim on 07/12/2018.
//


import Foundation
import UIKit

public protocol PIPWUsable {
    var initialState: PIPWState { get }
    var initialPosition: PIPWPosition { get }
    var pipSize: CGSize { get }
    func didChangedState(_ state: PIPWState)
}

public extension PIPWUsable {
    var initialState: PIPWState { return .pip }
    var initialPosition: PIPWPosition { return .bottomRight }
    var pipSize: CGSize { return CGSize(width: 200.0, height: (200.0 * 9.0) / 16.0) }
    func didChangedState(_ state: PIPWState) {}
}

public extension PIPWUsable where Self: PIPWViewWindow {
    func setNeedUpdatePIPSize() {
        guard PIPWKit.isPIP else {
            return
        }
        pipEventDispatcher?.updateFrame()
    }

    func startPIPMode() {
        PIPWKit.startPIPMode()
    }
    
    func stopPIPMode() {
        PIPWKit.stopPIPMode()
    }
    
}

internal extension PIPWUsable where Self: PIPWViewWindow {
    
    func pipDismiss(animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.rootViewController?.view.alpha = 0.0
            }) { [weak self] (_) in
                self?.removeFromSuperview()
                completion?()
            }
        } else {
            self.removeFromSuperview()
            completion?()
        }
    }
    
}
