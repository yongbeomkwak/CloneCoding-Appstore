import UIKit

public struct StarDefaultSetting {
  // MARK: Property
  static let defaultColor: UIColor = .systemGray
  static let borderWidth: Double = 1.0
  static let totalStars = 5
  static let size: Double = 20
  static let margin: Double = 5.0

  static let starPoints: [CGPoint] = [
    CGPoint(x: 49.5,  y: 0.0),
    CGPoint(x: 60.5,  y: 35.0),
    CGPoint(x: 99.0, y: 35.0),
    CGPoint(x: 67.5,  y: 58.0),
    CGPoint(x: 78.5,  y: 92.0),
    CGPoint(x: 49.5,  y: 71.0),
    CGPoint(x: 20.5,  y: 92.0),
    CGPoint(x: 31.5,  y: 58.0),
    CGPoint(x: 0.0,   y: 35.0),
    CGPoint(x: 38.5,  y: 35.0)
  ]

  // MARK: Init
  init() {}
}


public struct StarSetting {
  static let `default`: StarSetting = .init()

  // MARK: Property
  public var borderWidth: Double = StarDefaultSetting.borderWidth
  public var emptyBorderColor: UIColor = StarDefaultSetting.defaultColor
  public var filledBorderColor: UIColor = StarDefaultSetting.defaultColor
  public var emptyColor: UIColor = .clear
  public var filledColor: UIColor = StarDefaultSetting.defaultColor
  public var size: Double = StarDefaultSetting.size
  public var fillMode: FillMode = .precise
  public var totalStars: Int = StarDefaultSetting.totalStars
  public var margin: Double = StarDefaultSetting.margin
  public var starPoints: [CGPoint] = StarDefaultSetting.starPoints

  // MARK: Init
  public init() {}
  public init(size: Double, margin: Double) {
    self.size = size
    self.margin = margin
  }

}
