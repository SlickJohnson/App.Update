import Foundation
import UIKit

extension UIImageView {
  convenience init(postScreenshotURL: URL) {
    self.init()

    getPostScreenshot(with: postScreenshotURL)
  }
  
  func getPostScreenshot(with url: URL) {
    contentMode = .scaleAspectFill

    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: url) else { return }

      DispatchQueue.main.async {
        self.image = UIImage(data: data)
      }
    }
  }
}
