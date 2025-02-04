import UIKit

public protocol ContainerViewType{
  var contentView: UIView { get }
}

public extension ContainerViewType where Self: UIViewController {

  func add(_ viewController: UIViewController) {
    addChild(viewController) // add children([ViewController]) for hi
    contentView.addSubview(viewController.view) // add SubView
    viewController.didMove(toParent: self) // register parentVC
    viewController.view.fillSuperview()
  }

  func remove(_ viewController: UIViewController) {
    viewController.willMove(toParent: nil) // unRegister parentVC
    viewController.view.removeFromSuperview() // remove superView
    viewController.removeFromParent() // remove from children([ViewController])
  }
}
