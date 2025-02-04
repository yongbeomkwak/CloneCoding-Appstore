import Combine
import Foundation

final class ResultViewModel: ViewModelType {
  private enum Constants: Int {
    case limitCount = 20
  }
  
  struct Action {
    let scrollDidToEnd = PassthroughSubject<Void, Never>()
  }
  
  struct State {
    let limit: CurrentValueSubject<Int, Never>
    let canLoadMore: CurrentValueSubject<Bool, Never>
    let isLoading: CurrentValueSubject<Bool, Never>
    let dataSource: CurrentValueSubject<[SearchDetailModel], Never>
  }
  
  var action: Action = Action()
  var state: State
  
  var text: String = "" {
    didSet {
      if !text.isEmpty {
        load(limit: Constants.limitCount.rawValue)
      }
    }
  }
  
  var task: Task<Void, Never>?
  
  private let service: any iTunesService
  private var cancellables = Set<AnyCancellable>()
  
  init(text: String, service: any iTunesService) {
    self.text = text
    self.service = service
    state = State(
      limit: .init(Constants.limitCount.rawValue),
      canLoadMore: .init(true),
      isLoading: .init(false),
      dataSource: .init([])
    )
    bindAction()
  }
  
  deinit {
    task?.cancel()
    task = nil
  }
  
  func bindAction() {
    action.scrollDidToEnd
      .withLatestFrom(state.isLoading)
      .map { $0.1 }
      .filter{ !$0 } // 로딩중이아니면
      .withLatestFrom(state.canLoadMore)
      .map { $0.1 }
      .filter { $0 }
      .map { _ in }
      .withUnretained(self)
      .withLatestFrom(state.limit)
      .map { ($0.0.0, $0.1) }
      .sink { owner, limit in
        owner.load(limit: limit)
      }
      .store(in: &cancellables)
  }
}

extension ResultViewModel {
  private func load(limit: Int) {
    // 이전 task 취소
    state.isLoading.send(true)
    task?.cancel()
    task = nil
    
    task = Task { [weak self] in
      guard let self else { return }
      do {
        print("Request Start")
        try Task.checkCancellation()
        let result = try await self.service.search(text: text, limit: limit)
        
        // Task가 취소되지 않았는지 한번 더 확인
        try Task.checkCancellation()
        self.state.dataSource.send(result.results)
        state.canLoadMore.send(limit <= result.resultCount)
        state.limit.send(limit + Constants.limitCount.rawValue)
        state.isLoading.send(false)
      } catch is CancellationError {
        print("Task was cancelled")
      } catch {
        print("Error \(error.localizedDescription)")
      }
    }
  }
}
