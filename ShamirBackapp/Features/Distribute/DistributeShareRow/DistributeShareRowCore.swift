import Foundation
import ComposableArchitecture
import ShamirKit

typealias DistributeShareRowState = FullShare
enum DistributeShareRowAction {
  case copy
  case share
}
typealias DistributeShareRowEnvironment = DistributeEnvironment
let distributeShareRowReducer: Reducer<DistributeShareRowState, DistributeShareRowAction, DistributeShareRowEnvironment> = .strict { state, action in
  switch action {
  case .copy:
    return .none
  case .share:
    return .none
  }
}

