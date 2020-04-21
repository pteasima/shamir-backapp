import ModularArithmetic

extension BinaryInteger where Self: ModularOperations {
  @inlinable
  func dividing(_ other: Self, modulo: Self) -> Self {
    precondition(other != 0)
    return self * other.inverse(modulo: modulo)! //TODO: when is this nil?
  }
}
