import UIKit

final class ResultCell: UITableViewCell {
  private enum Layout {
    static let aspectRatio: CGFloat = APP_HEIGHT() / APP_WIDTH()
    static let horizontalPadding: CGFloat = 10
    static let itemSpacing: CGFloat = 10
    static let numberOfItems: CGFloat = 3
  }

  private let headerView = ResultCellHeaderView()
  private let summaryDetailView = SummaryDetailView()
  private lazy var dataSource: ScreenShotDiffableDataSource = .init(
    collectionView: collectionView,
    cellProvider: cellProvider
  )

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    collectionView.isScrollEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isUserInteractionEnabled = false // event를 tableViewCell에게 넘김
    return collectionView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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

  override func prepareForReuse() {
    super.prepareForReuse()
    headerView.prepareForReuse()
    summaryDetailView.prepareForReuse()
  }

  private func addView() {
    self.contentView.addSubviews(headerView, summaryDetailView, collectionView)
  }

  private func setLayout() {
    headerView.setTop(anchor: contentView.topAnchor, constant: 15)
    headerView.setHorizontal(view: contentView, constant: .zero)
    summaryDetailView.setTop(anchor: headerView.bottomAnchor, constant: .zero)
    summaryDetailView.setHorizontal(view: contentView, constant: .zero)
    summaryDetailView.setHeight(30)
    collectionView.setTop(anchor: summaryDetailView.bottomAnchor, constant: 10)
    collectionView.setHeight(calcHeight())
    collectionView.setHorizontal(view: contentView, constant: ResultCell.Layout.horizontalPadding)
    collectionView.setBottom(anchor: contentView.bottomAnchor, constant: .zero)
  }

  private func configureUI() {
    collectionView.registerFromClass(ScreenShotCell.self)
    collectionView.dataSource = dataSource
  }

  func bind(_ model: SearchDetailModel) {
    headerView.bind(
      ResultCellHeaderModel(
        title: model.appName,
        subTitle: model.category,
        appIcon: model.appIcon)
    )
    summaryDetailView.bind(
      SummaryDetailModel(
        rating: model.rating,
        downloadCount: model.download,
        company: model.userName,
        category: model.category
      )
    )

    dataSource.apply(
      model.screenshotUrls.count > 3 ? Array(model.screenshotUrls[0..<3]) : Array(model.screenshotUrls)
    )
  }
}

extension ResultCell {
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
// MARK: - CompositionalLayout
extension ResultCell {
  private func makeLayout() -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { sectionIndex, enviroment in
      return self.section()
    }
  }

  private func group() -> NSCollectionLayoutGroup {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/3),
      heightDimension: .fractionalWidth(1/3 * ResultCell.Layout.aspectRatio)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(itemSize.heightDimension.dimension)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      repeatingSubitem: item,
      count: Int(ResultCell.Layout.numberOfItems)
    )

    group.interItemSpacing = .fixed(ResultCell.Layout.itemSpacing)
    return group
  }

  private func section() -> NSCollectionLayoutSection {
    return NSCollectionLayoutSection(group: group())
  }

  private func calcHeight() -> CGFloat {
    let availableWidth = APP_WIDTH() - (Layout.horizontalPadding * 2)
    let cellWidth = (availableWidth - (Layout.itemSpacing * (Layout.numberOfItems - 1))) / Layout.numberOfItems
    let cellHeight = cellWidth * Layout.aspectRatio
    return cellHeight
  }
}
