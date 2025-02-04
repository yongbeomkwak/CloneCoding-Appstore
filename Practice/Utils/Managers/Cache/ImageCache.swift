import UIKit

enum ImageCacheError: Error {
  case noCachedData
}

protocol ImageCacheable {
  func load(url: URL) -> Result<UIImage, ImageCacheError>
  func save(url: URL, image: UIImage)
}


final class ImageCache: ImageCacheable {
  private let queue = DispatchQueue(label: "com.imageCache.queue", attributes: .concurrent)
  private let memoryCache = NSCache<NSString, UIImage>()
  private let diskCache: DiskCache = DiskCache()

  public init() {}


  func load(url: URL) -> Result<UIImage, ImageCacheError> {
    let key = url.absoluteString
    if let image = memoryCache.object(forKey: key as NSString) {
      return .success(image)
    } else if let data = diskCache[key], let image = UIImage(data: data) {
      memoryCache.setObject(image, forKey: key as NSString)
      return .success(image)
    }
    return .failure(.noCachedData)
  }

  func save(url: URL, image: UIImage) {
    let key = url.absoluteString
    queue.async { [weak self] in
      guard let self,
            let data = image.pngData()
      else { return }
      diskCache[key] = data
      memoryCache.setObject(image, forKey: key as NSString)
    }
  }
}
