import Combine
import Foundation

protocol ViewModelType {
  associatedtype Action
  associatedtype State
  var action: Action { get }
  var state: State { get }
  func bindAction()
}
