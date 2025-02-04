import Foundation

enum NetworkError: Error {
  case invalidURL
  case encodingFailed
  case invalidResponse
}
