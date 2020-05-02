import Foundation
import ComposableArchitecture

struct AppState: Equatable {
  var distribute: DistributeState = .init()
//  var assemble: () = ()
  var selectedTabIndex: Int = 0
}

enum AppAction {
  case distribute(DistributeAction)
  case assemble(())
  case setSelectedTabIndex(Int)
}
struct AppEnvironment {
  var pasteboard: Pasteboard = .init()
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
  .strict { state, action in
    switch action {
    case .setSelectedTabIndex(let newIndex):
      state.selectedTabIndex = newIndex
      return .none
    case .distribute, .assemble:
      return .none
    }
  }
//  ,
//  distributeReducer.pullback(state: \AppState.distribute, action: /AppAction.distribute, environment: { $0 })
)

