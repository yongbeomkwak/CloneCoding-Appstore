import Foundation

public struct LookUpResultModel {
  let resultCount: Int
  let results: [LookUpDetailModel]
}

struct LookUpDetailModel: Hashable {
  var id: UUID = UUID()
  let trackID, download, fileSize: Int
  let appName, appIcon, description, userName, rating ,category, version, contentRating , releaseNotes, minimum, downloadURL, updateDate: String
  let screenshotUrls, language: [String]
}
