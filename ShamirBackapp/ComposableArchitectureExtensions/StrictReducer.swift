import ComposableArchitecture

extension Reducer {
  static func strict(
    _ reducer: @escaping (inout State, Action) -> ((Environment) -> Effect<Action, Never>)?
  ) -> Reducer {
    Self { state, action, environment in
      reducer(&state, action).map { $0(environment) } ?? .none
    }
  }
}
