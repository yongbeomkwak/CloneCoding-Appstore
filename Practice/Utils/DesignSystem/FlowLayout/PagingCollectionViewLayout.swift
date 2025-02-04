import UIKit

final class PagingCollectionViewLayout: UICollectionViewFlowLayout {
  private let limitVelocity:CGFloat
  private let numberOfItemsPerPage: CGFloat

  init(limitVelocity: CGFloat = 2, numberOfItems: CGFloat = 1) {
    self.limitVelocity = limitVelocity
    self.numberOfItemsPerPage = numberOfItems
    super.init()
  }

  required init?(coder: NSCoder) {
    self.limitVelocity = 2
    self.numberOfItemsPerPage = 1
    super.init(coder: coder)
  }


  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity velocity: CGPoint
  ) -> CGPoint {
    guard let collectionView = collectionView else { return proposedContentOffset }

    let pageLength: CGFloat  // 페이지 길이 = (아이템크기(width or height) + 아이템사이간격) * 아이템 총 개수
    let approxPage: CGFloat  // 대략 예측 페이지 = 현재 좌표 (x or y) / 페이지 길이
    let currentPage: CGFloat // 현재 페이지
    let speed: CGFloat // 속도

    if scrollDirection == .horizontal {
      pageLength = (itemSize.width + minimumLineSpacing) * numberOfItemsPerPage
      approxPage = collectionView.contentOffset.x / pageLength
      speed = velocity.x
    } else {
      pageLength = (itemSize.height + minimumLineSpacing) * numberOfItemsPerPage
      approxPage = collectionView.contentOffset.y / pageLength
      speed = velocity.y
    }

    if speed < 0 { // 스크롤 방향이 (왼쪽 or 위)
      currentPage = ceil(approxPage)
    } else if speed > 0 { // 스크롤 방향이 (오른쪽 or 아래)
      currentPage = floor(approxPage)
    } else {
      currentPage = round(approxPage)
    }

    if speed == 0 {
      return scrollDirection == .horizontal ?
      CGPoint(x: currentPage * pageLength, y: .zero) :
      CGPoint(x: .zero, y: currentPage * pageLength)
    }

    var nextPage: CGFloat = currentPage + (speed > 0 ? 1 : -1)
    let correctSpeed = speed / limitVelocity

    nextPage += (speed < 0 ) ? ceil(correctSpeed) : floor(correctSpeed)

    return scrollDirection == .horizontal ?
    CGPoint(x: nextPage * pageLength, y: .zero) :
    CGPoint(x: .zero, y: nextPage * pageLength)
  }
}
