import UIKit

final class RecentTextCell: UITableViewCell {
  var configuration: UIListContentConfiguration = .cell()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(_ text: String) {
    configuration = UIListContentConfiguration.cell()
    configuration.text = text
    configuration.image = UIImage(systemName: "magnifyingglass")?.withTintColor(
      .systemGray,
      renderingMode: .alwaysOriginal
    )
    self.contentConfiguration = configuration
  }
}
