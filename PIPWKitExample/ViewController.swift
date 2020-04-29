//
//  ViewController.swift
//  PipWindow
//
//  Created by Daniele on 28/04/2020.
//  Copyright © 2020 nexor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    class func viewController() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("ViewController is null")
        }
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pipShow(_ sender: Any) {
        let vc = PIPViewController()
        PIPWKit.show(with: vc)
    }

    @IBAction func pipDismiss(_ sender: Any) {
        PIPWKit.dismiss(animated: true)
    }
    
    @IBAction func pipAnotherShow(_ sender: Any) {
        PIPWKit.show(with: PIPXibViewController.viewController())
    }

    @IBAction func showViewController(_ sender: Any) {
        let viewController = ViewController.viewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func presentViewController(_ sender: Any) {
        let viewController = ViewController.viewController()
        let naviController = UINavigationController(rootViewController: viewController)
        present(naviController, animated: true) { [unowned viewController] in
            viewController.setupDismissNavigationItem()
        }
    }
    
    // MARK: - Private
    private func setupDismissNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(onDismiss(_:)))
    }

    // MARK: - Action
    @objc
    private func onDismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

class PIPViewController: UIViewController, PIPWUsable {
    
    var initialState: PIPWState { return .pip }
    var pipSize: CGSize { return CGSize(width: 200.0, height: 200.0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1.0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if PIPWKit.isPIP {
            PIPWKit.floatingWindow?.stopPIPMode()
        } else {
            PIPWKit.floatingWindow?.startPIPMode()
        }
    }
    
    func didChangedState(_ state: PIPWState) {
        switch state {
        case .pip:
            print("PIPViewController.pip")
        case .full:
            print("PIPViewController.full")
        }
    }
}

class PIPXibViewController: UIViewController, PIPWUsable {
    
    var initialState: PIPWState { return .full }
    var initialPosition: PIPWPosition { return .topRight }
    var pipSize: CGSize = CGSize(width: 100.0, height: 100.0)
 
    class func viewController() -> PIPXibViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PIPXibViewController") as? PIPXibViewController else {
            fatalError("PIPXibViewController is null")
        }
        return viewController
    }
    
    func didChangedState(_ state: PIPWState) {
        switch state {
        case .pip:
            print("PIPXibViewController.pip")
        case .full:
            print("PIPXibViewController.full")
        }
    }
    
    // MARK: - Action
    @IBAction private func onFullAndPIP(_ sender: UIButton) {
        if PIPWKit.isPIP {
            PIPWKit.floatingWindow?.stopPIPMode()
        } else {
            PIPWKit.floatingWindow?.startPIPMode()
        }
    }
    
    @IBAction private func onUpdatePIPSize(_ sender: UIButton) {
        pipSize = CGSize(width: 100 + Int(arc4random_uniform(100)),
                         height: 100 + Int(arc4random_uniform(100)))
        PIPWKit.floatingWindow?.setNeedUpdatePIPSize()
    }
    
    @IBAction private func onDismiss(_ sender: UIButton) {
        PIPWKit.dismiss(animated: true) {
            print("PIPXibViewController.dismiss")
        }
    }
}

