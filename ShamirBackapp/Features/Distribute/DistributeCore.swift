import Foundation
import ComposableArchitecture
import ShamirKit

struct DistributeState: Equatable {
  var isMaskEnabled: Bool = false
  var secretText: String = ""
  var pasteboardString: String?
  var threshold: Int = 2
  var generatedShares: Shares? = Shares(shares: [Share(x: 1, y: 421337341289)], mersennePrimePower: 127)
  var started: Bool = false
  
  enum Status {
    case collectingInput
    case showingResults
  }
  var status: Status {
    generatedShares == nil ? .collectingInput : .showingResults
  }
}
enum DistributeAction {
  case `init`
  case isMaskEnabledChanged(Bool)
  case secretTextChanged(String)
  case pasteboardStringChanged(String?)
  case pasteFromClipboardTapped
  case thresholdChanged(Double)
  case generateButtonTapped
}

//eventually it will make sense to subscribe to pasteboard in AppReducer, since AssembleView will use that too.
typealias DistributeEnvironment = AppEnvironment

let distributeReducer: Reducer<DistributeState, DistributeAction, DistributeEnvironment> = .strict { state, action in
  switch action {
  case .`init`:
    guard !state.started else { return .none }
    state.started = true
    return { $0.pasteboard.string().map(DistributeAction.pasteboardStringChanged) }
  case .isMaskEnabledChanged(let isEnabled):
    state.isMaskEnabled = isEnabled
    return .none
  case .secretTextChanged(let s):
    state.secretText = s
    return .none
  case .pasteboardStringChanged(let s):
    state.pasteboardString = s
    return .none
  case .pasteFromClipboardTapped:
    state.secretText = state.pasteboardString ?? { assertionFailure(); return "" }()
    return .none
  case .thresholdChanged(let t):
    state.threshold = max(2, Int(round(t)))
    return .none
  case .generateButtonTapped:
    switch state.status {
    case .collectingInput:
      let secretInt = state.secretText.utf8BigUIntRepresentation
        var gen = SystemRandomNumberGenerator()
        state.generatedShares = try! ShamirKit.generateShares(secret: secretInt, threshold: state.threshold, using: &gen)
    case .showingResults:
        state.generatedShares = nil
    }
    return .none
  }
}
