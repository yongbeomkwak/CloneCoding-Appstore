import UIKit

struct SummaryDetailModel {
  let rating: Double
  let downloadCount: Int
  let company, category: String
}

final class SummaryDetailView: UIView {
  private let starsView: StarsView = {
    let starsView = StarsView(settings: StarSetting(size: 11, margin: 1))
    return starsView
  }()

  private let downLoadCountLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .body2
    return label
  }()

  private let userImageView: UIImageView = {
    let image = UIImage(systemName: "person.crop.square")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    let imageView = UIImageView(image:image)
    return imageView
  }()

  private let userLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .body2
    return label
  }()

  private let categoryImageView: UIImageView = {
    let image = UIImage(systemName: "folder.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    let imageView = UIImageView(image:image)
    return imageView
  }()

  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .body2
    return label
  }()

  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    stackView.alignment = .center
    stackView.spacing = 8
    return stackView
  }()

  init() {
    super.init(frame: .zero)
    addView()
    setLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func addView() {
    self.addSubviews(stackView)

    // 각 컨테이너를 동일한 크기의 컨테이너로 감싸기
    let containers = [
      makeContainerView(starsView, downLoadCountLabel),
      makeContainerView(userImageView, userLabel),
      makeContainerView(categoryImageView, categoryLabel)
    ]

    containers.forEach { stackView.addArrangedSubview($0) }
  }

  private func makeContainerView(_ imageView: UIView, _ label: UILabel) -> UIView {
    let containerView = UIView()
    containerView.addSubview(imageView)
    containerView.addSubview(label)

    // SummaryContainerView의 제약조건 설정
    imageView.setLeading(anchor: containerView.leadingAnchor, constant: .zero)
    imageView.setCenterY(view: containerView)

    label.setLeading(anchor: imageView.trailingAnchor, constant: 5)
    label.setTrailing(anchor: containerView.trailingAnchor, constant: .zero)
    label.setCenterY(view: imageView)

    return containerView
  }

  private func setLayout() {
    stackView.setHorizontal(view: self, constant: 20)
    stackView.setCenterY(view: self)

    starsView.setContentCompressionResistancePriority(.required, for: .horizontal)
    starsView.setContentHuggingPriority(.required, for: .horizontal)
    downLoadCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    downLoadCountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    userImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    userImageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    userLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    userLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    categoryImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    categoryImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    categoryLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    categoryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    // 모든 라벨에 말줄임표 적용
    [downLoadCountLabel, userLabel, categoryLabel].forEach { label in
      label.lineBreakMode = .byTruncatingTail
    }

    // 이미지뷰 크기 설정
    [userImageView, categoryImageView].forEach { imageView in
      imageView.setDimensions(width: 16, height: 16)
    }
  }

  func bind(_ model: SummaryDetailModel) {
    starsView.rating = model.rating
    downLoadCountLabel.text = parse(model.downloadCount)
    userLabel.text = model.company
    categoryLabel.text = model.category
  }

  func prepareForReuse() {
    starsView.rating = 0
    downLoadCountLabel.text = ""
    userLabel.text = ""
    categoryLabel.text = ""
  }

}

extension SummaryDetailView {
  private func parse(_ count: Int) -> String {
    if count >= 100000 {
      return "\(count/10000)만"
    } else if count >= 10000 {
      return "\(count/10000).\((count%10000)/1000)만"
    } else if count >= 1000 {
      return "\(count/1000).\((count%1000)/100)천"
    } else {
      return "\(count)"
    }
  }
}
