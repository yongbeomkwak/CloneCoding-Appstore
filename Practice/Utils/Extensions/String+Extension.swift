import Foundation

extension String {
  var urlQueryAllowed: String? {
    addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
  }
  var url: URL? {
    return URL(string: self)
  }
}
