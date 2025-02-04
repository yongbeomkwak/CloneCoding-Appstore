import UIKit

extension UICollectionView {
  public func registerFromClass<T: UICollectionViewCell>(_ cellClass: T.Type)
  {
    let reuseID = String(describing: cellClass)
    self.register(cellClass, forCellWithReuseIdentifier: reuseID)
  }
  
  public func dequeueReusableCell<T: UICollectionViewCell>(
    _ cellClass: T.Type, for indexPath: IndexPath
  ) -> T {
    let reuseID = String(describing: cellClass)
    let cell = self.dequeueReusableCell(
      withReuseIdentifier: reuseID, for: indexPath)
    guard let cell = cell as? T else { preconditionFailure() }
    return cell
  }
}
