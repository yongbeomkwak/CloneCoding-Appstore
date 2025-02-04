import UIKit

final class StarsView: UIView {
  // MARK: Property
  public var rating: Double = .zero {
    didSet {
      if oldValue != rating {
        update()
      }
    }
  }

  public var settings: StarSetting = .default {
    didSet {
      update()
    }
  }

  private var size = CGSize()

  // MARK: Init
  init(settings: StarSetting = .default) {
    super.init(frame: .zero)
    self.settings = settings
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Override
  override var intrinsicContentSize: CGSize {
    return size
  }

}

extension StarsView {
  func update() {
    let layers = StarLayers.createLayers(rating, setting: settings)
    layer.sublayers = layers
    updateSize(layers)
  }

  // MARK: Private
  private func calcSizeToFitLayers(_ layers: [CALayer]) -> CGSize {
    var size = CGSize()
    for layer in layers {
      size.width = max(layer.frame.maxX, size.width)
      size.height = max(size.height, layer.frame.maxY)
    }
    return size
  }

  private func updateSize(_ layers: [CALayer]) {
    size = calcSizeToFitLayers(layers)
    invalidateIntrinsicContentSize()
    frame.size = intrinsicContentSize
  }
}
