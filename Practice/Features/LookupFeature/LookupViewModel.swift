import Combine
import Foundation

final class LookupViewModel: ViewModelType {
  struct Action {
    let viewDidLoad = PassthroughSubject<Void, Never>()
  }
  struct State {
    let dataSource = PassthroughSubject<LookUpDetailModel,Never>()
  }
  var action: Action = Action()
  var state: State

  private let id: Int
  private let service: any iTunesService
  private var cancellables = Set<AnyCancellable>()

  init(id: Int, service: any iTunesService) {
    self.id = id
    self.service = service
    self.state = State()
    bindAction()
  }

  func bindAction() {
    action.viewDidLoad
      .withUnretained(self)
      .sink { owner, _ in
        owner.load()
      }
      .store(in: &cancellables)
  }
}

extension LookupViewModel {
  private func load() {
    Task {
      do {
        let result = try await service.lookup(id: id)
        if result.resultCount != 0 {
          state.dataSource.send(result.results[0])
        }
      } catch {
        print("Error Lookup")
      }
    }
  }
}
