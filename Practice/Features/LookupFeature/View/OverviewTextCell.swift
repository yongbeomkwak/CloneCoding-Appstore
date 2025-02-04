import UIKit

final class OverviewTextCell: UICollectionViewCell {
  private enum Layout {
    static let offset: CGFloat = 5
  }
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .systemGray
    label.font = .body
    return label
  }()

  private let representLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }()

  private let unitLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.textAlignment = .center
    label.font = .body
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)
    addView()
    setLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addView()
    setLayout()
  }

  private func addView() {
    contentView.addSubviews(titleLabel,representLabel,unitLabel)
  }

  private func setLayout() {
    titleLabel.setTop(anchor: contentView.topAnchor, constant: Layout.offset)
    titleLabel.setHorizontal(view: contentView, constant: .zero)
    representLabel.setTop(anchor: titleLabel.bottomAnchor, constant: Layout.offset)
    representLabel.setHorizontal(view: contentView, constant: .zero)
    unitLabel.setTop(anchor: representLabel.bottomAnchor, constant: Layout.offset)
    unitLabel.setHorizontal(view: contentView, constant: .zero)
    unitLabel.setBottom(lessThanOrEqualTo: contentView.bottomAnchor, constant: Layout.offset)
  }

  func bind(_ model: [String]) {
    titleLabel.text = model[safe: 0] ?? ""
    representLabel.text = model[safe: 1] ?? ""
    unitLabel.text = model[safe: 2] ?? ""
  }
}
