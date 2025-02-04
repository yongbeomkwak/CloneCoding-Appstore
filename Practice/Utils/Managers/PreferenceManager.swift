import Foundation
import Combine

final class PreferenceManager: @unchecked Sendable {
  enum Constants: String {
    case recentSearches
  }

  static let shared: PreferenceManager = PreferenceManager()
  private init() {}

  @UserDefaultWrapper(key: Constants.recentSearches.rawValue, defaultValue: nil)
  public var recentSearches: [String]?


}

extension PreferenceManager {
  func addRecentSearches(word: String) {
    let maxSize: Int = 10
    var currentRecentSearches = PreferenceManager.shared.recentSearches ?? []

    if currentRecentSearches.contains(word) {
      if let i = currentRecentSearches.firstIndex(where: { $0 == word }) {
        currentRecentSearches.remove(at: i)
        currentRecentSearches.insert(word, at: 0)
      }

    } else {
      if currentRecentSearches.count == maxSize {
        currentRecentSearches.removeLast()
      }
      currentRecentSearches.insert(word, at: 0)
    }

    PreferenceManager.shared.recentSearches = currentRecentSearches
  }
}


@propertyWrapper
final class UserDefaultWrapper<T: Codable & Sendable>: @unchecked Sendable {
  private let key: String
  private let defaultValue: T?
  private let subject: CurrentValueSubject<T?, Never>

  init(key: String, defaultValue: T?) {
    self.key = key
    self.defaultValue = defaultValue

    let initialValue: T?
    if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
      let decoder = JSONDecoder()
      if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
        initialValue = lodedObejct
      } else {
        initialValue = nil
      }

    } else if UserDefaults.standard.array(forKey: key) != nil {
      initialValue = UserDefaults.standard.array(forKey: key) as? T
    } else {
      initialValue = defaultValue
    }
    self.subject = .init(initialValue)
  }

  public var wrappedValue: T? {
    get {
      if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
        let decoder = JSONDecoder()
        if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
          return lodedObejct
        }

      } else if UserDefaults.standard.array(forKey: key) != nil {
        return UserDefaults.standard.array(forKey: key) as? T
      }
      return defaultValue
    }
    set {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(newValue) {
        UserDefaults.standard.setValue(encoded, forKey: key)
      }
      subject.send(newValue)
    }
  }

  public var projectedValue: AnyPublisher<T?, Never> {
    return subject.eraseToAnyPublisher()
  }
}
