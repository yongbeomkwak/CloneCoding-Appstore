import Foundation

extension URL {
  init(from endpoint: Endpoint) throws {
    guard let url = URL(string: endpoint.baseURL + endpoint.domain) else { throw NetworkError.invalidURL } 
    self = url
  }
}
