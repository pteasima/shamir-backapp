import Foundation
import Combine
import UIKit

// I eventually want to move this to pointfreeco's ComposableArchitecture when its released
// I have some prototypes of the same architecture but no point investing into that now
// So Im going for a simple redux that can be easily refactored later
final class Store: ObservableObject {
  @Published var isMaskEnabled: Bool = false
  @Published var text: String = ""
  @Published var pasteboardString: String?
  @Published var threshold: Int = 2
  
  var displayedText: String {
    get {
      isMaskEnabled ? String(repeating: "*", count: text.count) : text
    } set {
      text = newValue
    }
  }
  var isPasteDisabled: Bool {
    pasteboardString?.isEmpty ?? true
  }
  var sliderThreshold: Double {
    get { Double(threshold) }
    set { threshold = max(2, Int(round(newValue))) }
  }
  var isGenerateSharesDisabled: Bool {
    text.isEmpty
  }
  
  private var cancellables: [AnyCancellable] = []
  private var started: Bool = false
  func onStart() {
    guard !started else { return }
    started = true
    
    cancellables += [
      environment.pasteboard.string().assign(to: \.pasteboardString, on: self)
    ]
  }
  
  func pasteFromClipboard() {
    guard let string = UIPasteboard.general.string else { return }
    text = string
  }
  
  func generateShares() {
    
  }
}
