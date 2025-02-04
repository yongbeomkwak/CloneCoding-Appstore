import Combine
import UIKit

final class LookupViewController: UIViewController {
  private let scrollView: UIScrollView =  UIScrollView()
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  private let headerView = AppHeaderView()
  private let overviewView = AppOverviewView()
  private let releaseNotesView = ReleaseNotesView()
  private let screenShotView = LookupScreenShotView()
  
  private var cancellables = Set<AnyCancellable>()
  private let viewModel: LookupViewModel
  
  init(viewModel: LookupViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.viewModel = LookupViewModel(id: 0, service: iTunesServiceImpl(client: NetworkClient()))
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addView()
    setLayout()
    configureUI()
    bindState()
    viewModel.action.viewDidLoad.send()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func addView() {
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.setWidth(scrollView.widthAnchor)
    stackView.addArrangedSubview(headerView)
    stackView.addArrangedSubview(overviewView)
    stackView.addArrangedSubview(releaseNotesView)
    stackView.addArrangedSubview(screenShotView)
  }
  
  private func setLayout() {
    scrollView.fillSuperview()
    stackView.fillSuperview()
  }

  private func configureUI() {
    view.backgroundColor = .systemBackground
  }

  private func bindState() {
    viewModel.state.dataSource
      .receive(on: DispatchQueue.main)
      .withUnretained(self)
      .sink { owner, model in
        let headerModel = LookupHeaderModel(
          appIcon: model.appIcon,
          appName: model.appName,
          developer: model.userName,
          description: model.description)
        
        let overviewModel = OverviewModel(
          rating: model.rating,
          language: model.language,
          contentRating: model.contentRating,
          developer: model.userName
        )
        
        let releaseNoteModel = ReleaseNotesModel(
          version: model.version,
          date: model.updateDate,
          releaseNotes: model.releaseNotes
        )
        
        owner.headerView.bind(headerModel)
        owner.overviewView.bind(overviewModel)
        owner.releaseNotesView.bind(releaseNoteModel)
        owner.screenShotView.bind(model.screenshotUrls)
      }
      .store(in: &cancellables)
  }
}
