import Foundation

protocol iTunesService {
  func search(text: String, limit: Int) async throws -> SearchResultModel
  func lookup(id: Int) async throws -> LookUpResultModel
}

final class iTunesServiceImpl: iTunesService {
  private let client: NetworkClient<iTunesEndpoint>
  private let decoder: JSONDecoder = JSONDecoder()

  init(client: NetworkClient<iTunesEndpoint>) {
    self.client = client
  }

  func search(text: String, limit: Int) async throws -> SearchResultModel {
    let data = try await client.request(iTunesEndpoint.search(text, limit: limit))
    return try decoder.decode(SearchResultDTO.self, from: data).toDomain()
  }

  func lookup(id: Int) async throws -> LookUpResultModel {
    let data = try await client.request(iTunesEndpoint.lookup(id))
    return try decoder.decode(LookUpResultDTO.self, from: data).toDomain()
  }

}
