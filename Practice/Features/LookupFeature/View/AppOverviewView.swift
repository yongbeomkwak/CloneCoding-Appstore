import UIKit

struct OverviewModel: Hashable {
  let rating: String
  let language: [String]
  let contentRating, developer: String
}

fileprivate enum OverviewCategory: Int, CaseIterable {
  case rating
  case ageRestriction
  case developer
  case language

  var title: String {
    switch self {
    case .rating:
      return "평가"
    case .ageRestriction:
      return "연령"
    case .developer:
      return "개발자"
    case .language:
      return "언어"
    }
  }
}

final class AppOverviewView: UIView {
  private lazy var dataSource = makeDataSource()
  private let containerView = UIView()
  private lazy var  collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isScrollEnabled = false
    return collectionView
  }()

  private let topBorderView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    return view
  }()

  private let bottomBorderView: UIView = {
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
    self.addSubviews(containerView)
    containerView.addSubviews(topBorderView,bottomBorderView, collectionView)
  }

  private func setLayout() {
    containerView.setVertical(view: self, constant: .zero)
    containerView.setHorizontal(view: self, constant: .zero)
    containerView.setHeight(100)

    topBorderView.setHeight(0.5)
    topBorderView.setHorizontal(view: collectionView, constant: .zero)
    topBorderView.setTop(anchor: containerView.topAnchor, constant: 10)

    collectionView.setTop(anchor: topBorderView.bottomAnchor, constant: 5)
    collectionView.setBottom(anchor: bottomBorderView.topAnchor, constant: 5)
    collectionView.setLeading(anchor: containerView.leadingAnchor, constant: 20)
    collectionView.setTrailing(anchor: containerView.trailingAnchor, constant: .zero)

    bottomBorderView.setHeight(0.5)
    bottomBorderView.setHorizontal(view: collectionView, constant: .zero)
    bottomBorderView.setBottom(anchor: containerView.bottomAnchor, constant: .zero)
  }

  private func configureUI() {
    collectionView.dataSource = dataSource
  }

  func bind(_ model: OverviewModel) {
      dataSource.apply(model)
  }
}
// MARK: - CompositionalLayout & DataSource
extension AppOverviewView {
  private func makeDataSource() -> OverviewDiffableDataSource {
    // MARK: CellRegistration
    let ratingCellRegistraion = UICollectionView.CellRegistration<OverviewRatingCell, String> { cell,indexPath,rating in
      cell.bind(rating)
    }

    let textCellRegistraion = UICollectionView.CellRegistration<OverviewTextCell, [String]> { cell,indexPath, model in
      cell.bind(model)
    }

    let developerCellRegistraion  = UICollectionView.CellRegistration<OverviewDeveloperCell, [String]> { cell,indexPath, model in
      cell.bind(model)
    }

    return OverviewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
      let category = OverviewCategory.allCases[indexPath.row]
      switch category {
      case .rating:
        return collectionView.dequeueConfiguredReusableCell(
          using: ratingCellRegistraion,
          for: indexPath,
          item: item
        )

      case .ageRestriction:
        return collectionView.dequeueConfiguredReusableCell(
          using: textCellRegistraion,
          for: indexPath,
          item: [category.title, item, "세"]
        )

      case .developer:
        return collectionView.dequeueConfiguredReusableCell(
          using: developerCellRegistraion,
          for: indexPath,
          item: [category.title, item]
        )

      case .language:
        let languages = item.split(separator: ",").map{String($0)}
        let fristLanguage = languages[safe: 0] ?? ""
        return collectionView.dequeueConfiguredReusableCell(
          using: textCellRegistraion,
          for: indexPath,
          item: [category.title, fristLanguage, "+ \(languages.count)개 언어"]
        )
      }
    }
  }
  private func makeLayout() -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { sectionIndex, enviroment in
      return self.section()
    }
  }

  private func group() -> NSCollectionLayoutGroup {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(100),  // 각 아이템의 너비
      heightDimension: .fractionalHeight(1.0)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      repeatingSubitem: item,
      count: 1
    )
    return group
  }

  private func section() -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection(group: group())
    section.orthogonalScrollingBehavior = .continuous
    return section
  }
}
