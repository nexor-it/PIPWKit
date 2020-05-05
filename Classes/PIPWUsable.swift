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
    var pipEdgeInsets: UIEdgeInsets { get }
    var pipSize: CGSize { get }
    var pipShadow: PIPWShadow? { get }
    var pipCorner: PIPWCorner? { get }
    func didChangedState(_ state: PIPWState)
    func didChangePosition(_ position: PIPWPosition)
}

public extension PIPWUsable {
    var initialState: PIPWState { return .pip }
    var initialPosition: PIPWPosition { return .bottomRight }
    var pipEdgeInsets: UIEdgeInsets { return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15) }
    var pipSize: CGSize { return CGSize(width: 200.0, height: (200.0 * 9.0) / 16.0) }
    var pipShadow: PIPWShadow? { return PIPWShadow(color: .black, opacity: 0.3, offset: CGSize(width: 0, height: 8), radius: 10) }
    var pipCorner: PIPWCorner? {
        if #available(iOS 13.0, *) {
            return PIPWCorner(radius: 6, curve: .continuous)
        } else {
            return PIPWCorner(radius: 6, curve: nil)
        }
    }
    func didChangedState(_ state: PIPWState) {}
    func didChangePosition(_ position: PIPWPosition) {}
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
                self?.rootViewController?.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
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
