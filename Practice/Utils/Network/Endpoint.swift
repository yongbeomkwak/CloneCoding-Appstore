import Foundation

public protocol Endpoint {
  var scheme: String? { get }
  var baseURL: String { get }
  var domain: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var header: [String: String]? { get }
  var body: [String: Any]? { get }
  var query: [String: Any]? { get }
  var validationCode: ClosedRange<Int> { get }
  var timeout: TimeInterval { get }
}

public extension Endpoint {
  var scheme: String? { "https" }
  var host: String? { return nil }
  var validationCode: ClosedRange<Int> { 200 ... 300 }
  var timeout: TimeInterval { 20 }
}
