import UIKit

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        return UIWindow.current?.screen
    }
}

public func APP_WIDTH() -> CGFloat {
    return UIScreen.current?.bounds.width ?? .zero
}

public func APP_HEIGHT() -> CGFloat {
    return UIScreen.current?.bounds.height ?? .zero
}
