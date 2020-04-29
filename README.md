![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/PIPWKit.svg?style=flat)](https://cocoapods.org/pods/PIPKit)

# PIPWKit
Picture in Picture **Window** for iOS

![pip_default](https://github.com/nexor-it/PIPWKit/tree/master/Screenshot/default.gif)
![pip_transition](https://github.com/nexor-it/PIPWKit/tree/master/Screenshot/transition.gif)

## Ready for
- Device orientation 
- iOS11+ with iOS13 modal style support
- Swift 5.x
- XCode 11.5
- Over modal context

*If your project is IOS13+, you must to set the mainWindow parameter in the show function*

## Installation

#### CocoaPods
PIPKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PIPWKit'
```

## Usage

#### PIPUsable

```swift
protocol PIPWUsable {
    var initialState: PIPWState { get }
    var initialPosition: PIPWPosition { get }
    var pipSize: CGSize { get }
    func didChangedState(_ state: PIPWState)
}

```

#### PIPKit

```swift
open class PIPWKit {
    
    static var isActive: Bool { return floatingWindow != nil }
    static var isPIP: Bool { return state == .pip }

    static var floatingWindow: PIPWViewWindow?
    static var mainWindow: UIWindow?

    class func show(with viewController: UIViewController, mainWindow: UIWindow? = nil, completion: (() -> Void)? = nil) { ... }
    class func dismiss(animated: Bool, completion: (() -> Void)? = nil) { ... }
}
```

#### PIPWViewWindow: UIViewController, PIPWUsable
```swift
func setNeedUpdatePIPSize()
func startPIPMode()
func stopPIPMode()
```

## At a Glance

#### Show & Dismiss
```swift
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

let vc = PIPViewController()
PIPWKit.show(with: vc)
PIPWKit.dismiss(animated: true)
```

#### Update PIPSize

![pip_resize](https://github.com/nexor-it/PIPWKit/tree/master/Screenshot/resize.gif)

```swift
class PIPViewController: UIViewController, PIPWUsable {

    func onUpdatePIPSize(_ sender: UIButton) {
        pipSize = CGSize(width: 100 + Int(arc4random_uniform(100)),
                         height: 100 + Int(arc4random_uniform(100)))
        PIPWKit.floatingWindow?.setNeedUpdatePIPSize()
    }
}
```

#### FullScreen <-> PIP Mode
```swift
class PIPViewController: UIViewController, PIPWUsable {

    func fullScreenAndPIPMode() {
        if PIPWKit.isPIP {
            PIPWKit.floatingWindow?.stopPIPMode()
        } else {
            PIPWKit.floatingWindow?.startPIPMode()
        }
    }

    func didChangedState(_ state: PIPWState) {}
}
```

## Authors

**PIPWKit** is made with love by Daniele Galiotto ([gali8](https://github.com/gali8)), CIO at [Nexor Technology] (https://www.nexor.it)

**PIPWKit** is inspired to PIPKit.
PIPKit is by Taeun Kim (kofktu), <https://github.com/Kofktu/PIPKit>

## License

PIPWKit (like PIPKit) is available under the ```MIT``` license. See the ```LICENSE``` file for more info.