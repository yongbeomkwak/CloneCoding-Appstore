import UIKit

struct ResultCellHeaderModel {
  let title, subTitle, appIcon: String
}

final class ResultCellHeaderView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .title
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: 14, weight: .light)
    return label
  }()

  private let appIconImageView: GradientPlaceholderImageView = {
    let imageView = GradientPlaceholderImageView()
    imageView.layer.cornerRadius = 20
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.layer.borderColor = UIColor.appIconBorderColor
    imageView.layer.borderWidth = GlobalConstants.appIconBorderWidth
    return imageView
  }()

  private let installButton: UIButton = {
    let button = UIButton()
    var configuration = UIButton.Configuration.plain()
    configuration.attributedTitle = AttributedString("받기", attributes: AttributeContainer([
      .foregroundColor: UIColor.systemBlue, // 텍스트 색상 설정
      .font: UIFont.systemFont(ofSize: 16, weight: .bold) // 폰트 설정
    ]))
    button.backgroundColor = .systemGray4
    button.layer.cornerRadius = 15
    button.clipsToBounds = true
    button.configuration = configuration
    return button
  }()

  private var imageURL: URL?

  init() {
    super.init(frame: .zero)
    addView()
    setLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func addView() {
    self.addSubviews(appIconImageView, installButton, titleLabel, subtitleLabel)
  }

  private func setLayout() {
    appIconImageView.setDimensions(width: 60, height: 60)
    appIconImageView.setTop(anchor: self.topAnchor, constant: 0)
    appIconImageView.setBottom(anchor: self.bottomAnchor, constant: 0)
    appIconImageView.setLeading(anchor: self.leadingAnchor, constant: 20)

    installButton.setDimensions(width: 60, height: 30)
    installButton.setTrailing(anchor: self.trailingAnchor, constant: 20)
    installButton.setCenterY(view: self, constant: .zero)

    titleLabel.setTop(anchor: appIconImageView.topAnchor, constant:  10)
    titleLabel.setLeading(anchor: appIconImageView.trailingAnchor, constant: 8)
    titleLabel.setTrailing(anchor: installButton.leadingAnchor, constant: 5)

    subtitleLabel.setBottom(anchor: appIconImageView.bottomAnchor, constant: 8)
    subtitleLabel.setHorizontal(view: titleLabel, constant: .zero)
  }

  func bind(_ model: ResultCellHeaderModel) {
    imageURL = model.appIcon.url
    titleLabel.text = model.title
    subtitleLabel.text = model.subTitle
    Task {
      let image = await ImageDownloader.shared.download(url: imageURL)
      await MainActor.run {
        appIconImageView.image = image
      }
    }
  }

  func prepareForReuse() {
    titleLabel.text = ""
    subtitleLabel.text = ""
    appIconImageView.image = nil
    ImageDownloader.shared.cancelDownload(for: imageURL)
  }
}

