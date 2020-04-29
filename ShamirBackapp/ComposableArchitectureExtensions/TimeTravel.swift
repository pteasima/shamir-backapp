import Foundation
import ComposableArchitecture
import SwiftUI

struct TimeTravelState<AppState> {
  init(_ state: AppState) {
    self.stack = [state]
  }
  var stack: [AppState] //nonempty
  var isTimeTraveling: Bool = false
  var currentIndex: Int = 0
  var currentState: AppState {
    return stack[currentIndex]
  }
  mutating func append(_ state: AppState) {
    precondition(!isTimeTraveling)
    stack.append(state)
    currentIndex += 1
  }
}

enum TimeTravelAction<AppAction> {
  case app(AppAction)
  case toggleIsTimeTraveling
  case setIndex(Double) //Double because Slider uses floats
}

extension Reducer {
  static func timeTravel<AppState, AppAction, AppEnvironment>(
    appReducer: Reducer<AppState, AppAction, AppEnvironment>
  ) -> Reducer<TimeTravelState<AppState>, TimeTravelAction<AppAction>, AppEnvironment> {
    .init { state, action, environment in
      switch action {
      case .app(let appAction):
        guard !state.isTimeTraveling else { return .none }
        var newAppState = state.currentState
        let appEffect = appReducer(&newAppState, appAction, environment)
        state.append(newAppState)
        return appEffect.map(TimeTravelAction.app)
      case .toggleIsTimeTraveling:
        if state.isTimeTraveling { //commit changes
          state.stack = Array(state.stack[0...state.currentIndex])
        }
        state.isTimeTraveling.toggle()
        return .none
      case .setIndex(let index):
        state.currentIndex = min(state.stack.count - 1, max(0, Int(round(index))))
        return .none
      }
     }
  }
}

fileprivate struct TimeTravelDebuggerViewState: Equatable {
  var isTimeTraveling: Bool
  var currentIndex: Int
  var maxIndex: Double
}
struct TimeTravelDebugger<AppState: Equatable, AppAction, AppView: View>: View {
  let store: Store<TimeTravelState<AppState>, TimeTravelAction<AppAction>>
  let appView: (Store<AppState, AppAction>) -> AppView
  init<AppEnvironment>(
    initialAppState: AppState,
    appReducer: Reducer<AppState, AppAction, AppEnvironment>,
    environment: AppEnvironment,
    appView: @escaping (Store<AppState, AppAction>) -> AppView
  ) {
    self.store = .init(initialState: TimeTravelState(initialAppState), reducer: .timeTravel(appReducer: appReducer), environment: environment)
    self.appView = appView
  }
  
  var body: some View {
    func content(with viewStore: ViewStore<TimeTravelDebuggerViewState, TimeTravelAction<AppAction>>) -> some View {
      func debuggerView() -> some View {
        Slider(value: viewStore.binding(get: { Double($0.currentIndex) }, send: TimeTravelAction.setIndex), in: 0...viewStore.maxIndex)
      }
      return appView(store.scope(state: \.currentState, action: TimeTravelAction.app))
        .onTapGesture(count: 3) {
          viewStore.send(.toggleIsTimeTraveling)
      }
      .overlay(
        viewStore.isTimeTraveling ? AnyView(debuggerView().padding()) : AnyView(EmptyView()),
        alignment: .top
      )
    }
    return WithViewStore(store.scope(state: \TimeTravelState.view), content: content)
  }
}

extension TimeTravelState {
  fileprivate var view: TimeTravelDebuggerViewState {
    return .init(
      isTimeTraveling: isTimeTraveling,
      currentIndex: currentIndex,
      maxIndex: Double(stack.endIndex - 1))
  }
}

#if DEBUG
struct TimeTravelDebugger_Previews: PreviewProvider {
  static var previews: some View {
    TimeTravelDebugger(initialAppState: AppState(), appReducer: appReducer, environment: AppEnvironment(), appView: AppView.init(store:))
  }
}
#endif
