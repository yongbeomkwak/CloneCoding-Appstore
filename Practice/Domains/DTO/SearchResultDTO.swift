import Foundation

struct SearchResultDTO: Decodable {

    let resultCount: Int
    let results: [SearchDetailDTO]

  public func toDomain() -> SearchResultModel {
        .init(resultCount: resultCount,results: results.map{$0.toDomain()})
    }

}

struct SearchDetailDTO: Codable {
    let trackId, userRatingCount: Int?
    let averageUserRating: Double?
    let trackName ,artworkUrl100, description, sellerName, currentVersionReleaseDate: String?
    let screenshotUrls, genres: [String]?


    public func toDomain() -> SearchDetailModel {
        .init(
            trackID: trackId ?? 0,
            download: userRatingCount ?? 0,
            rating: averageUserRating ?? 0,
            appName: trackName ?? "",
            appIcon: artworkUrl100 ?? "",
            description: description ?? "",
            userName: sellerName ?? "",
            category: genres?.first ?? "",
            screenshotUrls: screenshotUrls ?? [])
    }

}
