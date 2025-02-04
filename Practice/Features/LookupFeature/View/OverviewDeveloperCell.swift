import UIKit

final class OverviewDeveloperCell: UICollectionViewCell {
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

  private let imageView: UIImageView = {
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    let image = UIImage(
      systemName: "person.crop.square",
      withConfiguration: boldConfig
    )?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    let imageView = UIImageView(image:image)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let companyLabel: UILabel = {
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
    contentView.addSubviews(titleLabel,imageView,companyLabel)
  }

  private func setLayout() {
    titleLabel.setTop(anchor: contentView.topAnchor, constant: Layout.offset)
    titleLabel.setHorizontal(view: contentView, constant: .zero)
    imageView.setTop(anchor: titleLabel.bottomAnchor, constant: Layout.offset)
    imageView.setCenter(view: contentView, offset: .zero)
    imageView.setWidth(25)
    companyLabel.setTop(anchor: imageView.bottomAnchor, constant: Layout.offset)
    companyLabel.setHorizontal(view: contentView, constant: .zero)
    companyLabel.setBottom(lessThanOrEqualTo: contentView.bottomAnchor, constant: Layout.offset)
  }

  func bind(_ model: [String]) {
    titleLabel.text = model[safe: 0] ?? ""
    companyLabel.text = model[safe: 1] ?? ""
  }
}
