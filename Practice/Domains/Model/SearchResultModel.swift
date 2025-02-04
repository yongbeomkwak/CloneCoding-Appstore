import Foundation

public struct SearchResultModel {
  let resultCount: Int
  let results: [SearchDetailModel]
}

struct SearchDetailModel: Hashable {
  var id: UUID = UUID()
  let trackID, download: Int
  let rating: Double
  let appName, appIcon, description, userName, category: String
  let screenshotUrls: [String]

  // Hashable 구현
  func hash(into hasher: inout Hasher) {
      hasher.combine(id)  // trackId만으로 고유성 보장
  }

  // Equatable 구현
  static func == (lhs: SearchDetailModel, rhs: SearchDetailModel) -> Bool {
    return lhs.id == rhs.id
  }
}
