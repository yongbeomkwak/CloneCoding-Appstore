import UIKit

enum OverviewSection: Int {
  case main
}

final class OverviewDiffableDataSource: UICollectionViewDiffableDataSource<OverviewSection, String> {
  private typealias SnapShot = NSDiffableDataSourceSnapshot<OverviewSection, String>

  private var collectionView: UICollectionView?

  override init(
    collectionView: UICollectionView,
    cellProvider: @escaping UICollectionViewDiffableDataSource<ScreenShotSection, String>.CellProvider
  ) {
    super.init(collectionView: collectionView, cellProvider: cellProvider)
    self.collectionView = collectionView
  }
}

extension OverviewDiffableDataSource {
  private func makeSnapShot(_ model: OverviewModel) -> SnapShot {
    var snapShot = SnapShot()
    snapShot.appendSections([.main])
    snapShot.appendItems([model.rating, model.contentRating, model.developer, model.language.joined(separator: ",")], toSection: .main)
    return snapShot
  }

  func apply(_ model: OverviewModel) {
    apply(makeSnapShot(model), animatingDifferences: true)
  }

}
