import Combine
import UIKit

protocol ResultViewDelegate: AnyObject {
  func didSelect(_ id: Int)
}

final class ResultViewController: UIViewController {
  typealias Section = Int
  typealias Item = SearchDetailModel
  
  private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = makeDataSource()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.registerForm(ResultCell.self)
    tableView.sectionHeaderTopPadding = .zero
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.tableFooterView = indicator
    return tableView
  }()
  
  private let indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.hidesWhenStopped = true
    indicator.color = .systemGray
    return indicator
  }()
  
  private let viewModel: ResultViewModel
  private var cancellables = Set<AnyCancellable>()
  
  weak var delegate: ResultViewDelegate?
  
  init(viewModel: ResultViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.viewModel = ResultViewModel(text: "", service: iTunesServiceImpl(client: NetworkClient()))
    super.init(coder: coder)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addView()
    setLayout()
    bindState()
  }
  
  private func addView() {
    view.addSubviews(tableView)
  }
  
  private func setLayout() {
    tableView.fillSuperview()
  }
  
  func bindState() {
    viewModel.state
      .dataSource
      .receive(on: DispatchQueue.main)
      .withUnretained(self)
      .sink { owner, datasource in
        owner.tableView.restore()
        if datasource.isEmpty {
          owner.tableView.setEmptyMessage("검색 결과가 없습니다.")
        }
        let snapShot =  owner.makeSnapShot(dataSource: datasource)
        owner.dataSource.apply(snapShot, animatingDifferences: false)
      }
      .store(in: &cancellables)
    
    viewModel.state
      .isLoading
      .receive(on: DispatchQueue.main)
      .withUnretained(self)
      .sink { owner, isLoading in
        if isLoading {
          owner.indicator.startAnimating()
        } else {
          owner.indicator.stopAnimating()
        }
      }
      .store(in: &cancellables)
  }
  
  func textDidChange(_ text: String) {
    viewModel.text = text
  }
  
  func scrollToTop() {
    tableView.setContentOffset(.zero, animated: false)
  }
  
}

extension ResultViewController {
  private func makeDataSource() -> UITableViewDiffableDataSource<Section, Item> {
    let dataSource = viewModel.state.dataSource
    return UITableViewDiffableDataSource(tableView: tableView) {tableView, indexPath, itemIdentifier in
      guard let data = dataSource.value[safe: indexPath.row] else { return .init() }
      let cell = tableView.dequeueReusableCell(ResultCell.self, for: indexPath)
      cell.bind(data)
      cell.selectionStyle = .none
      return cell
    }
  }
  
  private func makeSnapShot(dataSource: [Item]) -> NSDiffableDataSourceSnapshot<Section, Item> {
    var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapShot.appendSections([0])
    snapShot.appendItems(dataSource)
    return snapShot
  }
}

extension ResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.state.dataSource.value.count - 1 {
      viewModel.action.scrollDidToEnd.send()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let model = dataSource.itemIdentifier(for: indexPath) {
      delegate?.didSelect(model.trackID)
    }
  }
}
