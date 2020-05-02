import Foundation
import Combine
import UIKit
import ComposableArchitecture

struct Pasteboard {
  var string: () -> Effect<String?, Never> = {
    NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)
      .map { _ in }
      .prepend(())
      .map { UIPasteboard.general.string }
      .eraseToEffect()
  }
}
