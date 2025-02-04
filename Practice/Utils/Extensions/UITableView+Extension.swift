import UIKit

extension UITableView {
  public func registerForm<T: UITableViewCell>(_ cellClass: T.Type) {
    let reuseID = String(describing: cellClass)
    self.register(cellClass, forCellReuseIdentifier: reuseID)
  }

  public func dequeueReusableCell<T: UITableViewCell>(
    _ cellClass: T.Type,
    for indexPath: IndexPath
  ) -> T {
    let reuseID = String(describing: cellClass)
    let cell = self.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
    guard let cell = cell as? T else { preconditionFailure()}
    return cell
  }

  public func setEmptyMessage(_ message: String) {
    let label: UILabel = UILabel()
    label.text = message
    label.textColor = .systemGray
    label.numberOfLines = 0;
    label.textAlignment = .center;
    label.font = .boldSystemFont(ofSize: 20)

    let view = UIView(frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: APP_HEIGHT()))
    view.addSubview(label)
    label.setTop(anchor: view.safeAreaLayoutGuide.topAnchor, constant: 200)
    label.setHorizontal(view: view, constant: .zero)

    self.backgroundView = view;
  }

  public func restore() {
    self.backgroundView = nil
  }
}
