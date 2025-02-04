import UIKit

final class LookupScreenShotView: UIView {
  private enum Layout {
    static let width = APP_WIDTH() / 1.5
    static let ratio = APP_HEIGHT() / APP_WIDTH()
    static let height = width * ratio
  }
  private lazy var dataSource: ScreenShotDiffableDataSource = makeDataSource()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "미리 보기"
    label.font = .systemFont(ofSize: 25, weight: .black)
    return label
  }()

  private lazy var collectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()

  private let borderView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    return view
  }()

  init() {
    super.init(frame: .zero)
    addView()
    setLayout()
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addView()
    setLayout()
    configureUI()
  }

  private func addView() {
    self.addSubviews(titleLabel, collectionView, borderView)
  }

  private func setLayout() {
    titleLabel.setTop(anchor: self.topAnchor, constant: 20)
    titleLabel.setHorizontal(view: self, constant: 20)
    collectionView.setTop(anchor: titleLabel.bottomAnchor, constant: 15)
    collectionView.setHorizontal(view: self, constant: .zero)
    collectionView.setHeight(Layout.height)
    borderView.setHeight(0.5)
    borderView.setTop(anchor: collectionView.bottomAnchor, constant: 30)
    borderView.setHorizontal(view: self, constant: 20)
    borderView.setBottom(anchor: self.bottomAnchor, constant: .zero)
  }

  private func configureUI() {
    collectionView.registerFromClass(ScreenShotCell.self)
    collectionView.dataSource = dataSource
  }

  func bind(_ model: [String]) {
    dataSource.apply(model)
  }
}

extension LookupScreenShotView {
  private func makeLayout() -> PagingCollectionViewLayout {
    let layout = PagingCollectionViewLayout()
    layout.itemSize = CGSize(width: Layout.width, height: Layout.height)
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = .init(top: .zero, left: 20, bottom: .zero, right: 20)
    layout.scrollDirection = .horizontal
    return layout
  }

  private func makeDataSource() -> ScreenShotDiffableDataSource {
    return ScreenShotDiffableDataSource(
      collectionView: collectionView,
      cellProvider: cellProvider
    )
  }

  private func cellProvider(
    _ collectionView: UICollectionView,
    _ indexPath: IndexPath,
    _ item: String
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ScreenShotCell.self, for: indexPath)
    cell.bind(item)
    return cell
  }
}
