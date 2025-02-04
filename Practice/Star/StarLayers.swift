import UIKit

// 복수 별 Layer
final class StarLayers {

  static func createLayers(_ rating: Double, setting: StarSetting) -> [CALayer] {
    var remainRating = Rating.calcRating(rating, totalStars: setting.totalStars)

    var layers: [CALayer] = []

    for _ in 0..<setting.totalStars {
      let fillLevel = Rating.starFill(rating: remainRating , fillMode: setting.fillMode) // 0~1
      let starLayer = createSpecificLayer(fillLevel, setting: setting)

      layers.append(starLayer)
      remainRating -= 1
    }
    positionStarLayers(layers, margin: setting.margin)

    return layers
  }

  static func createSpecificLayer(_ level: Double, setting: StarSetting) -> CALayer {
    if level >= 1 {
      return createLayer(true, setting: setting) // 꽉찬 별
    } else if level == 0 {
      return createLayer(false, setting: setting) // 비어 있는 별
    } else {
      return createPartialLayer(level, setting: setting) // 부분 별
    }
  }
  // 꽉찬 별 또는 비어있는 별
  static func createLayer(_ isFilled: Bool, setting: StarSetting) -> CALayer {

    let fillColor = isFilled ? setting.filledColor : setting.emptyColor
    let strokeColor = isFilled ? setting.filledBorderColor : setting.emptyBorderColor

    return StarLayer.create(
      setting.starPoints,
      size: setting.size,
      lineWidth: setting.borderWidth,
      fillColor: fillColor,
      strokeColor: strokeColor)

  }

  // 부분 별
  static func createPartialLayer(_ level: Double, setting: StarSetting) -> CALayer {

    let filledStarLayer = createLayer(true, setting: setting)
    let emptyStarLayer = createLayer(false, setting: setting)

    let superLayer = CALayer()
    superLayer.contentsScale = UIScreen.main.scale
    superLayer.bounds = CGRect(origin: CGPoint(), size: CGSize(width: setting.size, height: setting.size))
    superLayer.anchorPoint = CGPoint()
    superLayer.addSublayer(emptyStarLayer)
    superLayer.addSublayer(filledStarLayer)

    filledStarLayer.bounds.size.width *= CGFloat(level) // filledStarLayer의 width를 level로 조정해 부분 별 표시

    return superLayer
  }

  // 별 간 간격 조절
  static func positionStarLayers(_ layers: [CALayer], margin: Double) {
    var positionX: CGFloat = 0

    for layer in layers {
      layer.position.x = positionX
      positionX += layer.bounds.width + CGFloat(margin) // 다음 별 위치 = 현재 layer widh + margin
    }
  }
}

// 단일 별 Layer
struct StarLayer {

  static func create(
    _ starPoints: [CGPoint],
    size: Double,
    lineWidth: Double,
    fillColor: UIColor,
    strokeColor: UIColor
  ) -> CALayer {
    let containerLayer = createContainerLayer(size)
    let path = createStarPath(starPoints, size: size, lineWidth: lineWidth)

    let shapeLayer = createShapeLayer(
      path.cgPath, lineWidth: lineWidth,
      fillColor: fillColor,
      strokeColor: strokeColor,
      size: size
    )

    containerLayer.addSublayer(shapeLayer)

    return containerLayer
  }

  static func createContainerLayer(_ size: Double) -> CALayer {
    let layer = CALayer()
    layer.contentsScale = UIScreen.main.scale
    layer.anchorPoint = CGPoint()
    layer.masksToBounds = true
    layer.bounds.size = CGSize(width: size, height: size)
    layer.isOpaque = true
    return layer
  }

  static func createShapeLayer(
    _ path: CGPath,
    lineWidth: Double,
    fillColor: UIColor,
    strokeColor: UIColor,
    size: Double
  ) -> CALayer {

    let layer = CAShapeLayer()
    layer.anchorPoint = CGPoint()
    layer.contentsScale = UIScreen.main.scale
    layer.strokeColor = strokeColor.cgColor
    layer.fillColor = fillColor.cgColor
    layer.lineWidth = CGFloat(lineWidth)
    layer.bounds.size = CGSize(width: size, height: size)
    layer.masksToBounds = true
    layer.path = path
    layer.isOpaque = true
    return layer
  }

  // 별 경로 그리기
  static func createStarPath(
    _ starPoints: [CGPoint],
    size: Double,
    lineWidth: Double
  ) -> UIBezierPath {
    let lineWidthLocal = lineWidth + ceil(lineWidth * 0.3)
    let sizeWithoutLineWidth = size - lineWidthLocal * 2
    let points = scaleStar(starPoints, factor: sizeWithoutLineWidth / 100,
                           lineWidth: lineWidthLocal)

    let path = UIBezierPath()

    path.move(to: points[0])
    let remainingPoints = Array(points[1..<points.count])

    for point in remainingPoints {
      path.addLine(to: point)
    }

    path.close()
    return path
  }

  // 비율과 테두리를 반영하여 좌표 이동
  static func scaleStar(_ starPoints: [CGPoint], factor: Double, lineWidth: Double) -> [CGPoint] {
    return starPoints.map { point in
      return CGPoint(
        x: point.x * CGFloat(factor) + CGFloat(lineWidth),
        y: point.y * CGFloat(factor) + CGFloat(lineWidth)
      )
    }
  }

}
