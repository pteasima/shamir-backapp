import ModularArithmetic

extension BinaryInteger where Self: ModularOperations {
  @inlinable
  func dividing(_ other: Self, modulo: Self) -> Self {
    self * other.inverse(modulo: modulo)! //TODO: when is this nil?
  }
}
