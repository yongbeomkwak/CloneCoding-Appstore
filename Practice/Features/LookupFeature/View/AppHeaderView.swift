import UIKit

struct LookupHeaderModel {
  let appIcon, appName, developer, description: String
}

final class AppHeaderView: UIView {
  enum Layout {
    static let offset: CGFloat = 20.0
  }

  private let appIconImageView = {
    let imageView = GradientPlaceholderImageView()
    imageView.layer.cornerRadius = 20
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.layer.borderColor = UIColor.appIconBorderColor
    imageView.layer.borderWidth = GlobalConstants.appIconBorderWidth
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = .systemFont(ofSize: 18, weight: .regular)
    return label
  }()

  private let subTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = .systemFont(ofSize: 15, weight: .light)
    label.textColor = .systemGray
    return label
  }()

  private let installButton: UIButton = {
    let button = UIButton()
    var configuration = UIButton.Configuration.plain()
    configuration.attributedTitle = AttributedString("받기", attributes: AttributeContainer([
      .foregroundColor: UIColor.white, // 텍스트 색상 설정
      .font: UIFont.systemFont(ofSize: 16, weight: .bold) // 폰트 설정
    ]))
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 15
    button.clipsToBounds = true
    button.configuration = configuration
    return button
  }()

  private let shareBUtton: UIButton = {
    let button = UIButton()
    var configuration = UIButton.Configuration.plain()
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: boldConfig)
    configuration.image = image
    button.configuration = configuration
    return button
  }()

  init() {
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
    self.addSubviews(appIconImageView, titleLabel, subTitleLabel, installButton, shareBUtton)
  }

  private func setLayout() {
    appIconImageView.setDimensions(height: 100, width: 100)
    appIconImageView.setTop(anchor: self.topAnchor, constant: .zero)
    appIconImageView.setLeading(anchor: self.leadingAnchor, constant: Layout.offset)
    appIconImageView.setBottom(anchor: self.bottomAnchor, constant: .zero)

    titleLabel.setTop(anchor: appIconImageView.topAnchor, constant: .zero)
    titleLabel.setLeading(anchor: appIconImageView.trailingAnchor, constant: Layout.offset)
    titleLabel.setTrailing(anchor: self.trailingAnchor, constant: Layout.offset)

    subTitleLabel.setTop(anchor: titleLabel.bottomAnchor, constant: 2)
    subTitleLabel.setHorizontal(view: titleLabel, constant: .zero)
    subTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    subTitleLabel.setBottom(lessThanOrEqualTo: installButton.topAnchor, constant: 5)

    installButton.setDimensions(height: 30, width: 60)
    installButton.setLeading(anchor: titleLabel.leadingAnchor, constant: .zero)
    installButton.setBottom(anchor: appIconImageView.bottomAnchor, constant: .zero)

    shareBUtton.setDimensions(height: 30, width: 30)
    shareBUtton.setTrailing(anchor: titleLabel.trailingAnchor, constant: .zero)
    shareBUtton.setBottom(anchor: appIconImageView.bottomAnchor, constant: .zero)
  }

  func bind(_ model: LookupHeaderModel) {
    Task {
      let image = await ImageDownloader.shared.download(url: model.appIcon.url)
      await MainActor.run {
        appIconImageView.image = image
      }
    }
    titleLabel.text = model.appName
    subTitleLabel.text = model.developer
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
      self?.replaceText(model.description)
    }
  }
  private func replaceText(_ text: String) {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.subTitleLabel.alpha = 0
    }, completion: { [weak self] _ in
      self?.subTitleLabel.text = text
      UIView.animate(withDuration: 0.3) {
        self?.subTitleLabel.alpha = 1
      }
    })
  }
}
