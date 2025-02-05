import UIKit

enum ImageDownloadError: Error {
  case invalidResponse
}

protocol ImageDownloadable {
  func download(url: URL?) async -> UIImage?
  func cancelDownload(for url: URL?)
}

final class ImageDownloader: ImageDownloadable {
  static let shared = ImageDownloader(cache: ImageCache())
  private let cache: any ImageCacheable
  private let session: URLSession
  // 동시 다운로드 작업을 추적하는 딕셔너리
  private var workingTasks: [URL: Task<UIImage?, Error>] = [:]
  private let concurrentQueue = DispatchQueue(
    label: "com.app.imagedownloader.queue",
    qos: .userInitiated,
    attributes: .concurrent
  )

  private init(cache: any ImageCacheable) {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad // 캐시 있으면 사용, 없으면 로드
    configuration.urlCache = URLCache(
      memoryCapacity: 50_000_000, // 약 50MB
      diskCapacity: 100_000_000 // 약 100MB
    )
    self.session = URLSession(configuration: configuration)
    self.cache = cache
  }

  func download(url: URL?) async -> UIImage? {
    guard let url = url else { return nil }
    let result =  cache.load(url: url)
    switch result {
    case let .success(image):
      return image
    case .failure(_):
      guard let image = await requestImage(url: url) else { return nil }
      cache.save(url: url, image: image)
      return image
    }
  }

  func cancelDownload(for url: URL?) {
    guard let url = url else { return }
    concurrentQueue.async(flags: .barrier) { [weak self] in
      self?.workingTasks[url]?.cancel()
      self?.workingTasks[url] = nil
    }
  }
}
extension ImageDownloader {
  // 쓰기 작업 - 직렬로 처리
  private func setTask(_ task: Task<UIImage?, Error>, for url: URL) {
    concurrentQueue.async(flags: .barrier) { [weak self] in
      self?.workingTasks[url] = task
    }
  }

  private func removeTask(for url: URL) {
    concurrentQueue.async(flags: .barrier) { [weak self] in
      self?.workingTasks[url] = nil
    }
  }

  private func requestImage(url: URL) async -> UIImage? {
    let task = Task<UIImage?, Error> {
      do {
        let (data, response) = try await session.data(from: url)
        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode,
              let image = UIImage(data: data)
        else {
          throw ImageDownloadError.invalidResponse
        }
        return image
      } catch {
        throw error
      }
    }

    setTask(task, for: url)

    do {
      let image = try await task.value
      removeTask(for: url)
      return image
    } catch {
      removeTask(for: url)
      return nil
    }
  }
}

