import UIKit

enum ScreenShotSection: Int {
  case main
}

final class ScreenShotDiffableDataSource: UICollectionViewDiffableDataSource<ScreenShotSection, String> {
  private typealias SnapShot = NSDiffableDataSourceSnapshot<ScreenShotSection, String>

  private var collectionView: UICollectionView?

  override init(
    collectionView: UICollectionView,
    cellProvider: @escaping UICollectionViewDiffableDataSource<ScreenShotSection, String>.CellProvider
  ) {
    super.init(collectionView: collectionView, cellProvider: cellProvider)
    self.collectionView = collectionView
  }
}

extension ScreenShotDiffableDataSource {
  private func makeSnapShot(_ urls: [String]) -> SnapShot {
    var snapShot = SnapShot()
    snapShot.appendSections([.main])
    snapShot.appendItems(urls)
    return snapShot
  }

  func apply(_ urls: [String]) {
    apply(makeSnapShot(urls), animatingDifferences: true)
  }
}
