import Foundation
import SwiftUI

extension Font {
  // Buttons shouldn't use dynamicType. I mocked Microsoft for this so I can't afford doing it myself even for shitty projects 😅
  static var button: Font { .system(size: 22) }
  static var smallButton: Font { .system(size: 18) }
}
