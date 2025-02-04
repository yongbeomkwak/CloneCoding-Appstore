import UIKit

final class OverviewRatingCell: UICollectionViewCell {
  private enum Layout {
    static let offset: CGFloat = 5
  }
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "평가"
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

  private let starsView: StarsView =  {
    let starsView = StarsView(settings: StarSetting(size: 15, margin: 1))
    return starsView
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
    contentView.addSubviews(titleLabel,representLabel,starsView)
  }

  private func setLayout() {
    titleLabel.setTop(anchor: contentView.topAnchor, constant: Layout.offset)
    titleLabel.setHorizontal(view: contentView, constant: .zero)
    representLabel.setTop(anchor: titleLabel.bottomAnchor, constant: Layout.offset)
    representLabel.setHorizontal(view: contentView, constant: .zero)
    starsView.setTop(anchor: representLabel.bottomAnchor, constant: Layout.offset)
    starsView.setCenterX(view: contentView)
    starsView.setBottom(lessThanOrEqualTo: contentView.bottomAnchor, constant: Layout.offset)
  }

  func bind(_ model: String) {
    representLabel.text = model
    starsView.rating = Double(model) ?? .zero
  }
}
