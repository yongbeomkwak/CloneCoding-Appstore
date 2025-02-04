import Combine
import UIKit
#warning("검색어 바꿀 때 tableview hidden 처리 고만")
final class RootViewController: UIViewController  {
  // MARK: Views
  private let recentSearchesViewController = {
    let vc = RecentSearchesViewController()
    return vc
  }()

  private let resultViewController = {
    let vc = ResultViewController(viewModel: ResultViewModel(text: "SOOP", service: iTunesServiceImpl(client: NetworkClient())))
    return vc
  }()

  private let resultView = UIView()

  private lazy var searchController = {
    let controller =  UISearchController(searchResultsController: recentSearchesViewController)
    controller.searchResultsUpdater = recentSearchesViewController
    controller.searchBar.placeholder = "검색 내용을 입력해주세요."
    controller.searchBar.delegate = self
    return controller
  }()

  private var cancellables = Set<AnyCancellable>()
  private let viewModel: RootViewModel

  // MARK: Init
  init(viewModel: RootViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    self.viewModel = RootViewModel()
    super.init(coder: coder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addView()
    setLayout()
    configureUI()
    bindState()
  }

  private func addView() {
    navigationItem.searchController = searchController
    view.addSubview(resultView)
    addChild(resultViewController) //
    resultView.addSubview(resultViewController.view)
    resultViewController.didMove(toParent: self) // register parentVC
  }

  private func setLayout() {
    resultView.setVertical(layoutGuide: view.safeAreaLayoutGuide, constant: .zero)
    resultView.setHorizontal(view: view, constant: .zero)
    resultViewController.view.fillSuperview()
  }

  private func configureUI() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Search"
    recentSearchesViewController.delegate = self
    resultViewController.delegate = self
    view.backgroundColor = .systemBackground
  }

  private func bindState() {
    viewModel.state
      .isShowResult
      .filter{ $0 }
      .map{ _ in }
      .withLatestFrom(viewModel.state.searchText)
      .sink(receiveValue: {[weak self] _, text in
        guard let self else { return }
        self.showResult(with: text)
      })
      .store(in: &cancellables)
  }
}

extension RootViewController {
  private func showResult(with text: String) {
    searchController.showsSearchResultsController = false
    PreferenceManager.shared.addRecentSearches(word: text)
    resultViewController.textDidChange(text)
    resultView.isHidden = false
  }
}

extension RootViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchController.showsSearchResultsController = true
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel.action.searchTextDidChange.send(text)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    resultViewController.scrollToTop()
    viewModel.action.searchCancelButtonDidTap.send(())
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    resultViewController.scrollToTop()
    viewModel.action.searchTextDidChange.send(text)
    viewModel.action.searchButtonDidTap.send()
  }
}

extension RootViewController: RecentSearchesDelegate {
  func recentSearchDidTap(_ text: String) {
    resultViewController.scrollToTop()
    searchController.searchBar.text = text
    viewModel.action.searchTextDidChange.send(text)
    viewModel.action.searchButtonDidTap.send()
    searchController.searchBar.endEditing(true)
  }
}

extension RootViewController: ResultViewDelegate {
  func didSelect(_ id: Int) {
    self.navigationController?.pushViewController(LookupViewController(viewModel: LookupViewModel(id: id, service: iTunesServiceImpl(client: NetworkClient()))), animated: true)
  }
}
