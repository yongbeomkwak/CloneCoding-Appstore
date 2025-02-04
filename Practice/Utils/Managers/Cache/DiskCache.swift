import Foundation
import CryptoKit

fileprivate struct Entry {
  let url: URL
  let meta: URLResourceValues

  init?(url: URL?, meta: URLResourceValues?) {
    guard let url = url else { return nil }
    guard let meta = meta else { return nil }
    self.url = url
    self.meta = meta
  }
}

final class DiskCache {
  var countLimit: Int
  var sizeLimit: Int
  var folderURL: URL

  init(countLimit: Int = 30, sizeLimit: Int = 1000_000_000) {
    self.countLimit = countLimit
    self.sizeLimit = sizeLimit
    self.folderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appending(path: "cache")

    createRootDirectory()
  }

  subscript(_ key: String) -> Data? {
    set {
      guard let keyData = key.data(using: .utf8),
            let newData = newValue
      else { return }
      let key = makeKey(data: keyData)
      let writeURL = folderURL.appendingPathComponent(key)
      do {
        try newData.write(to: writeURL)
      } catch {
        
      }
      update()
    }

    get {
      guard let keyData = key.data(using: .utf8) else { return nil }
      let key = makeKey(data: keyData)
      let readURL = folderURL.appendingPathComponent(key)
      return FileManager.default.contents(atPath:readURL.path)
    }
  }

}

extension DiskCache {
  private func createRootDirectory() {
    if !FileManager.default.fileExists(atPath: folderURL.path()) {
      // withIntermediateDirectories: 생성 디렉토리의 부모 디렉토리가 존재하지 않았을 때 생성 여부
      try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true,attributes: nil)
    }
  }

  private func makeKey(data: Data) -> String {
    let sha256 = SHA256.hash(data: data)
    return sha256.compactMap{ String(format:"%02hhx",$0)}.joined()
  }

  // 최신화
  private func update() {
    /// .contentAccessDateKey는 파일에 마지막으로 액세스한 날짜를 식별하는 키
    /// .totalFileAllocatedSizeKey는 파일이 차지하는 전체 할당된 크기를 식별하는 키
    /// .contentModificationDateKey는 파일의 마지막 수정 날짜를 식별하는 키
    let keys: [URLResourceKey] = [.contentAccessDateKey, .totalFileAllocatedSizeKey, .contentModificationDateKey]

    guard let urls = try? FileManager.default.contentsOfDirectory(
      at: folderURL,
      includingPropertiesForKeys: keys,
      options: .skipsHiddenFiles
    ) else { return }

    if urls.isEmpty { return }

    let past = Date.distantPast

    var entrys = urls.compactMap { (url) -> Entry? in
      return Entry(url: url, meta: try? url.resourceValues(forKeys: Set(keys)))

    }.sorted(by: {

      let firstModifyDate = $0.meta.contentModificationDate ?? past
      let firstAccessDate = $0.meta.contentAccessDate ?? past

      let lastModifyDate = $1.meta.contentModificationDate ?? past
      let lastAccessDate = $1.meta.contentAccessDate ?? past

      let firstDate = firstModifyDate > firstAccessDate ? firstModifyDate : firstAccessDate
      let lastDate = lastModifyDate  > lastAccessDate ? lastModifyDate : lastAccessDate
      // 더 최신께 앞으로 , 가장 오래 전에 수정된 것이 뒤로
      // LRU
      return firstDate > lastDate
    })

    var count = entrys.count
    var totalSize = entrys.reduce(0, { $0 + ($1.meta.totalFileAllocatedSize ?? 0) })

    // 한도 초과 확인 (갯수, 사이즈)
    guard count > self.countLimit || totalSize > self.sizeLimit else { return }

    // 초과한 분량제거
    while ( count > self.countLimit || totalSize > self.sizeLimit ), let entry = entrys.popLast() {
      // 가장 오래전에 수정된 것을 하나씩 꺼내옴
      count -= 1
      totalSize -= (entry.meta.totalFileAllocatedSize ?? 0)
      try? FileManager.default.removeItem(at: entry.url)
    }
  }
}
