import UIKit

public extension UIView {
  // use: addSubview(firstView, secondView)
  func addSubviews(_ views: UIView...) {
    views.forEach { self.addSubview($0) }
  }

  func setAnchor(
    top: NSLayoutYAxisAnchor? = nil,
    paddingTop: CGFloat = 0,
    leading: NSLayoutXAxisAnchor? = nil,
    paddingLeading: CGFloat = 0,
    bottom: NSLayoutYAxisAnchor? = nil,
    paddingBottom: CGFloat = 0,
    trailing: NSLayoutXAxisAnchor? = nil,
    paddingTrailing: CGFloat = 0,
    width: CGFloat? = nil,
    height: CGFloat? = nil
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false

    if let top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }

    if let leading {
      self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
    }

    if let bottom {
      self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }

    if let trailing {
      self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
    }

    if let width {
      self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    if let height {
      self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }

  func setTop(anchor: NSLayoutYAxisAnchor, constant: CGFloat) {
    self.setAnchor(top: anchor, paddingTop: constant)
  }

  func setLeading(anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
    self.setAnchor(leading: anchor, paddingLeading: constant)
  }

  func setBottom(anchor: NSLayoutYAxisAnchor, constant: CGFloat) {
    self.setAnchor(bottom: anchor, paddingBottom: constant)
  }

  func setBottom(lessThanOrEqualTo: NSLayoutYAxisAnchor, constant: CGFloat) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.bottomAnchor.constraint(lessThanOrEqualTo: lessThanOrEqualTo, constant: -constant).isActive = true
  }

  func setBottom(greaterThanOrEqualTo: NSLayoutYAxisAnchor, constant: CGFloat) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.bottomAnchor.constraint(greaterThanOrEqualTo: greaterThanOrEqualTo, constant: -constant).isActive = true
  }

  func setTrailing(anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
    self.setAnchor(trailing: anchor, paddingTrailing: constant)
  }

  func setCenter(view: UIView, offset: CGPoint) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).isActive = true
    self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).isActive = true
  }

  func setHorizontal(view: UIView,constant: CGFloat) {
    self.setLeading(anchor: view.leadingAnchor, constant: constant)
    self.setTrailing(anchor: view.trailingAnchor, constant: constant)
  }

  func setHorizontal(layoutGuide: UILayoutGuide,constant: CGFloat) {
    self.setLeading(anchor: layoutGuide.leadingAnchor, constant: constant)
    self.setTrailing(anchor: layoutGuide.trailingAnchor, constant: constant)
  }

  func setVertical(layoutGuide: UILayoutGuide,constant: CGFloat) {
    self.setTop(anchor: layoutGuide.topAnchor, constant: constant)
    self.setBottom(anchor: layoutGuide.bottomAnchor, constant: constant)
  }

  func setVertical(view: UIView,constant: CGFloat) {
    self.setTop(anchor: view.topAnchor, constant: constant)
    self.setBottom(anchor: view.bottomAnchor, constant: constant)
  }

  func setCenterX(
    view: UIView,
    topAnchor: NSLayoutYAxisAnchor? = nil,
    paddingTop: CGFloat = 0
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    if let topAnchor {
      self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
    }
  }

  func setCenterY(view: UIView, constant: CGFloat = 0) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
  }

  func setDimensions(width: CGFloat, height: CGFloat) {
    self.setAnchor(width: width, height: height)
  }

  func setHeight(_ height: CGFloat) {
    self.setAnchor(height: height)
  }

  func setHeight(_ dimension: NSLayoutDimension) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(equalTo: dimension).isActive = true
  }

  func setWidth(_ dimension: NSLayoutDimension) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalTo: dimension).isActive = true
  }

  func setWidth(_ width: CGFloat) {
    self.setAnchor(width: width)
  }

  func fillSuperview() {
    self.translatesAutoresizingMaskIntoConstraints = false
    guard let view = self.superview else { return }
    self.setAnchor(
      top: view.topAnchor,
      leading: view.leadingAnchor,
      bottom: view.bottomAnchor,
      trailing: view.trailingAnchor
    )
  }
}
