import UIKit

final class ScreenShotCell: UICollectionViewCell {
  private var imageView: GradientPlaceholderImageView = {
    let imageView = GradientPlaceholderImageView()
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = 15
    imageView.clipsToBounds = true
    return imageView
  }()

  private var imageURL: URL?

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

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    ImageDownloader.shared.cancelDownload(for: imageURL)
  }

  private func addView() {
    contentView.addSubview(imageView)
  }

  private func setLayout() {
    imageView.fillSuperview()
  }

  func bind(_ urlString: String) {
    let imageURL = urlString.url
    Task {
      let image = await ImageDownloader.shared.download(url: imageURL)
      await MainActor.run {
        imageView.image = image
      }
    }
  }
}
