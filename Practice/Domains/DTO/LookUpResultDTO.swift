import Foundation

struct LookUpResultDTO: Decodable {
  let resultCount: Int
  let results: [LookUpDetailDTO]
  public func toDomain() -> LookUpResultModel {
    .init(resultCount: resultCount,results: results.map{$0.toDomain()})
  }
}

struct LookUpDetailDTO: Codable {
  let trackId, userRatingCount: Int?
  let averageUserRating: Double?
  let trackName ,artworkUrl100, description, sellerName, version, contentAdvisoryRating, releaseNotes, currentVersionReleaseDate, fileSizeBytes, minimumOsVersion, trackViewUrl: String?
  let screenshotUrls, genres, languageCodesISO2A: [String]?

  public func toDomain() -> LookUpDetailModel {
    let formmater: DateFormatter = DateFormatter()
    formmater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z''"
    let updateDate =  (formmater.date(from: currentVersionReleaseDate ?? "") ?? Date()).day
    let now: Date = Date.now
    let diff: Int = Calendar.current.getDateGap(from: updateDate, to: now)
    let size: Int = Int(fileSizeBytes ?? "0") ?? 0
    let updateDateString = updateDateToString(diff: diff)

    return LookUpDetailModel(
      trackID: trackId ?? 0,
      download: userRatingCount ?? 0,
      fileSize: size,
      appName: trackName ?? "",
      appIcon: artworkUrl100 ?? "",
      description: description ?? "",
      userName: sellerName ?? "",
      rating: String(Double(round((averageUserRating ?? .zero) * 10) / 10 )),
      category: genres?.first ?? "",
      version: version ?? "",
      contentRating: contentAdvisoryRating ?? "",
      releaseNotes: releaseNotes ?? "",
      minimum: minimumOsVersion ?? "",
      downloadURL: trackViewUrl ?? "",
      updateDate: updateDateString,
      screenshotUrls: screenshotUrls ?? [],
      language: languageCodesISO2A ?? []
    )
  }

  private func updateDateToString(diff: Int) -> String {
    if diff >= 365 {
      return "\(diff/365)년 전"
    } else if diff >= 30 {
      return "\(diff/30)달 전"
    } else {
      return "\(diff)일 전"
    }
  }
}
