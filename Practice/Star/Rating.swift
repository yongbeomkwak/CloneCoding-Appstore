import Foundation

struct Rating {

  // 별 한개당 색칠되어야하는 레벨 
  public static func starFill(rating: Double, fillMode: FillMode) -> Double {
    var level = rating
    level = min(level, 1)
    level = max(level, 0)

    return roundFill(level, fillMode: fillMode)
  }

  static func roundFill(_ level: Double, fillMode: FillMode) -> Double {
    switch fillMode {
    case .full:
      return round(level)
    case .half:
      return round(level * 2) / 2
    case .precise:
      return level
    }
  }

  // convert rating between 0 and totalStars
  static func calcRating(_ rating: Double, totalStars: Int) -> Double {
    var result = min(rating, Double(totalStars))
    result = max(result, 0)
    return result
  }
  
}
