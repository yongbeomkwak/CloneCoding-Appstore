import Combine
import UIKit

protocol RecentSearchesDelegate: AnyObject {
  func recentSearchDidTap(_ text: String)
}

final class RecentSearchesViewController: UIViewController {
  typealias Section = Int
  typealias Item = String

  // MARK: Property
  private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = makeDataSource()
  weak var delegate: RecentSearchesDelegate?
  
  private let tableView: UITableView =  {
    let tableView = UITableView()
    tableView.sectionHeaderTopPadding = .zero
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private var cancellables = Set<AnyCancellable>()

  // MARK: Init
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addView()
    setLayout()
    configureUI()
    bindState()
    setupKeyboardNotifications()
  }

  private func addView() {
    view.addSubview(tableView)
  }

  private func setLayout() {
    tableView.fillSuperview()
  }

  private func configureUI() {
    tableView.registerForm(RecentTextCell.self)
    tableView.delegate = self
  }

  private func bindState() {
    PreferenceManager.shared.$recentSearches
      .withUnretained(self)
      .sink { owner, texts in
        if let texts = texts, !texts.isEmpty {
          owner.tableView.restore()
          owner.dataSource.apply(owner.makeSnapShot(), animatingDifferences: true)
        } else {
          owner.tableView.setEmptyMessage("최근 검색어가 없습니다.")
        }
      }
      .store(in: &cancellables)
  }

}

extension RecentSearchesViewController {
  private func setupKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }

    let insets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: keyboardFrame.height,
      right: 0
    )

    tableView.contentInset = insets
    tableView.scrollIndicatorInsets = insets
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    tableView.contentInset = .zero
    tableView.scrollIndicatorInsets = .zero
  }
}

extension RecentSearchesViewController {
  private func makeDataSource() -> UITableViewDiffableDataSource<Section, Item> {
    return UITableViewDiffableDataSource(tableView: tableView) {tableView, indexPath, itemIdentifier in
      guard let datas = PreferenceManager.shared.recentSearches,
            let data = datas[safe: indexPath.row]
      else { return .init() }
      let cell = tableView.dequeueReusableCell(RecentTextCell.self, for: indexPath)
      cell.bind(data)
      cell.selectionStyle = .none
      return cell
    }
  }

  private func makeSnapShot() -> NSDiffableDataSourceSnapshot<Section, Item> {
    var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapShot.appendSections([0])
    snapShot.appendItems(PreferenceManager.shared.recentSearches ?? [])
    return snapShot
  }
}

extension RecentSearchesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let data = dataSource.itemIdentifier(for: indexPath) else { return }
    delegate?.recentSearchDidTap(data)
  }
}

extension RecentSearchesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {

  }
}
