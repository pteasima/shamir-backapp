import Foundation
import Combine
import UIKit

struct Pasteboard {
  var string: () -> AnyPublisher<String?, Never> = {
    NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)
      .map { _ in }
      .prepend(())
      .map { UIPasteboard.general.string }
      .eraseToAnyPublisher()
  }
}
