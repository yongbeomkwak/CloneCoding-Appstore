import UIKit

struct ReleaseNotesModel {
  let version, date, releaseNotes: String
}

final class ReleaseNotesView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "새로운 소식"
    label.font = .systemFont(ofSize: 25, weight: .black)
    return label
  }()

  private let versionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .title
    return label
  }()

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .title
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    label.font = .title
    return label
  }()

  private let showMoreButton: UIButton = {
    let button = UIButton()
    var configuration = UIButton.Configuration.plain()
    configuration.attributedTitle = AttributedString("더 보기", attributes: AttributeContainer([
      .foregroundColor: UIColor.systemBlue,
      .font: UIFont.title,
    ]))
    configuration.contentInsets = .init(top: .zero, leading: 10, bottom: .zero, trailing: .zero) // ✅ leading 만 패딩
    button.configuration = configuration
    return button
  }()

  init() {
    super.init(frame: .zero)
    addView()
    setLayout()
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addView()
    setLayout()
    configureUI()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    showMoreButton.isHidden = !descriptionLabel.isTextTruncated
  
  }

  private func addView() {
    self.addSubviews(titleLabel, versionLabel, dateLabel, descriptionLabel,showMoreButton)
    showMoreButton.backgroundColor = .red
  }

  private func setLayout() {
    titleLabel.setTop(anchor: self.topAnchor, constant: 10)
    titleLabel.setLeading(anchor: self.leadingAnchor, constant: 20)
    versionLabel.setTop(anchor: titleLabel.bottomAnchor, constant: 10)
    versionLabel.setLeading(anchor: titleLabel.leadingAnchor, constant: .zero)
    dateLabel.setVertical(view: versionLabel, constant: .zero)
    dateLabel.setTrailing(anchor: self.trailingAnchor, constant: 20)
    descriptionLabel.setLeading(anchor: titleLabel.leadingAnchor, constant: .zero)
    descriptionLabel.setTrailing(anchor: dateLabel.trailingAnchor, constant: .zero)
    descriptionLabel.setTop(anchor: dateLabel.bottomAnchor, constant: 15)
    descriptionLabel.setBottom(anchor: self.bottomAnchor, constant: .zero)
    showMoreButton.setTrailing(anchor: dateLabel.trailingAnchor, constant: .zero)
    showMoreButton.setBottom(anchor: descriptionLabel.lastBaselineAnchor, constant: -4)
  }

  private func configureUI() {
    showMoreButton.addTarget(self, action: #selector(showMore), for: .touchUpInside)
    showMoreButton.sizeToFit()
    showMoreButton.backgroundColor = UIColor.systemBackground
  }

  func bind(_ model: ReleaseNotesModel) {
    versionLabel.text = "버전" + model.version
    dateLabel.text = model.date
    descriptionLabel.text = model.releaseNotes
  }
}

extension ReleaseNotesView {
  @objc private func showMore() {
    UIView.transition(
      with: descriptionLabel,
      duration: 0.3,
      options:.transitionCrossDissolve
    ) {
        self.descriptionLabel.numberOfLines = 0
        self.showMoreButton.alpha = .zero
        self.showMoreButton.isHidden = true
      }
  }
}
