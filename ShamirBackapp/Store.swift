import Foundation
import Combine
import UIKit
import ShamirKit
import SwiftUI

// I eventually want to move this to pointfreeco's ComposableArchitecture when its released
// I have some prototypes of the same architecture but no point investing into that now
// So Im going for a simple redux that can be easily refactored later
final class Store: ObservableObject {
  @Published var isMaskEnabled: Bool = false
  @Published var secretText: String = ""
  @Published var pasteboardString: String?
  @Published var threshold: Int = 2
  @Published var generatedShares: Shares? = (shares: [Share(x: 1, y: 421337341289)], mersennePrimePower: 127)
  
  var displayedSecretText: String {
    get {
      isMaskEnabled ? String(repeating: "*", count: secretText.count) : secretText
    } set {
      secretText = newValue
    }
  }
  var isPasteDisabled: Bool {
    pasteboardString?.isEmpty ?? true
  }
  var sliderThreshold: Double {
    get { Double(threshold) }
    set { threshold = max(2, Int(round(newValue))) }
  }
  
  enum State {
    case generating
    case generated
  }
  var state: State {
    generatedShares == nil ? .generating : .generated
  }
  var isInputSectionDisabled: Bool {
    generatedShares != nil
  }
  var isGenerateDisabled: Bool {
    state == .generating && secretText.isEmpty
  }
  var generateButtonText: String {
    switch state {
    case .generating:
      return "Generate Shares"
    case .generated:
      return "Modify Input"
    }
  }
  // Color is a View, does using it here break any best practices?
  // Arguably these computed properties are just UI helpers anyway.
  // I try to practice https://twitter.com/rtfeldman/status/1025454724206743553?s=20
  var generateButtonColor: Color {
    guard !isGenerateDisabled else { return .gray }
    switch state {
    case .generating:
      return .green
    case .generated:
      return .red
    }
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
    secretText = string
  }
  
  func generateButtonTapped() {
    switch state {
    case .generating:
        let secretInt = secretText.utf8BigUIntRepresentation
        var gen = SystemRandomNumberGenerator()
        generatedShares = try! ShamirKit.generateShares(secret: secretInt, threshold: threshold, using: &gen)
    case .generated:
      generatedShares = nil
    }
    
  }
}
