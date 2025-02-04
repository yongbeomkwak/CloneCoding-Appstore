import UIKit

extension UILabel {
  var isTextTruncated: Bool {
      guard let text = self.text else { return false }
      let labelSize = self.bounds.size
      let textSize = (text as NSString).boundingRect(
          with: CGSize(width: labelSize.width, height: .greatestFiniteMagnitude),
          options: .usesLineFragmentOrigin,
          attributes: [.font: self.font as Any],
          context: nil
      ).size
   
      return textSize.height > labelSize.height
  }
}
