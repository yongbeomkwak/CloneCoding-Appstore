import Foundation

enum iTunesEndpoint {
  case search(_ text: String, limit: Int)
  case lookup(_ id: Int)
}

extension iTunesEndpoint: Endpoint {
  var baseURL: String {
    "https://itunes.apple.com"
  }

  var domain: String {
    switch self {
    case .search:
      return "/search"
    case .lookup:
      return "/lookup"
    }
  }

  var path: String {
    return ""
  }

  var method: HTTPMethod {
    return .get
  }

  var header: [String : String]? {
    return nil
  }

  var body: [String : Any]? {
    return nil
  }

  var query: [String : Any]? {
    switch self {
    case let .search(text, limit):
      return ["term": text, "limit": limit, "country":"KR", "media": "software"]

    case let .lookup(id):
      return ["id": id, "country":"KR"]
    }
  }

}
