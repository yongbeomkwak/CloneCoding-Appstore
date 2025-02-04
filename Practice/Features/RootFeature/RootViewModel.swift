import Combine
import Foundation

final class RootViewModel: ViewModelType {
  struct Action {
    let searchTextDidChange = PassthroughSubject<String, Never>()
    let searchButtonDidTap = PassthroughSubject<Void, Never>()
    let searchCancelButtonDidTap = PassthroughSubject<Void, Never>()
  }

  struct State {
    let isShowResult: CurrentValueSubject<Bool, Never>
    let searchText: CurrentValueSubject<String, Never>
  }

  private var cancellables = Set<AnyCancellable>()
  var action: Action = Action()
  var state: State

  init() {
    state = State(
      isShowResult: .init(false),
      searchText: .init("")
    )
    bindAction()
  }

  func bindAction() {
    action.searchButtonDidTap
      .withUnretained(self)
      .sink { owner, _ in
        owner.state.isShowResult.send(true)
      }
      .store(in: &cancellables)

    action.searchCancelButtonDidTap
      .withUnretained(self)
      .sink { owner, _ in
        owner.state.isShowResult.send(false)
      }
      .store(in: &cancellables)

    action.searchTextDidChange
      .withUnretained(self)
      .sink { owner, text in
        owner.state.searchText.send(text)
      }
      .store(in: &cancellables)
  }
}


