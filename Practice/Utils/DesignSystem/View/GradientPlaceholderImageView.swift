import UIKit

final class GradientPlaceholderImageView: UIImageView {
  private let gradientLayer = CAGradientLayer()
  override var image: UIImage? {
    didSet {
      if let _ = image {
        stopShimmerAnimation()
      } else {
        startShimmerAnimation()
      }
    }
  }

  init() {
    super.init(frame: .zero)
    setupGradient()
    startShimmerAnimation()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGradient()
    startShimmerAnimation()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }

  private func setupGradient() {
    gradientLayer.colors = [
      UIColor(white: 0.85, alpha: 1.0).cgColor,
      UIColor(white: 0.95, alpha: 1.0).cgColor,
      UIColor(white: 0.85, alpha: 1.0).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.locations = [0.0, 0.5, 1.0]
  }

  private func startShimmerAnimation() {
    layer.addSublayer(gradientLayer)
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [0.0, 0.1, 0.2]
    animation.toValue = [0.8, 0.9, 1.0]
    animation.duration = 1.5
    animation.repeatCount = .infinity
    gradientLayer.add(animation, forKey: "shimmer")
  }

  func stopShimmerAnimation() {
    gradientLayer.removeAnimation(forKey: "shimmer")
    gradientLayer.removeFromSuperlayer()
  }
}
