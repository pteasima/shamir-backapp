import Foundation
import BigInt
import ModularArithmetic

extension BigUInt {
  private static func randomWords<T>(count: Int, using generator: inout T) -> [Word] where T: RandomNumberGenerator {
    (0..<count).map { _ in Word.random(in: Word.min...Word.max, using: &generator) }
  }
  
  static func random<T>(in range: Range<BigUInt>, using generator: inout T) -> BigUInt where T: RandomNumberGenerator {
    precondition(!range.isEmpty)
    let delta = range.upperBound - range.lowerBound
    guard delta > 0 else { return range.lowerBound } //if range only has one element, return it
    let max = BigUInt(words: [Word](repeating: .max, count: delta.words.count))
    let maxModded = max % delta
    var result: BigUInt
    repeat {
      result = BigUInt(words: randomWords(count: delta.words.count, using: &generator))
    } while result < maxModded
    return range.lowerBound + (result % delta)
  }
}

public extension String {
  var utf8BigUIntRepresentation: BigUInt {
    var mutableSelf = self //we dont actually mutate it so there shouldnt be a performance impact
    return mutableSelf.withUTF8 { bytes in
      BigUInt(UnsafeRawBufferPointer(bytes))
    }
  }
  init?(utf8BigUIntRepresentation: BigUInt) {
    self.init(decoding: utf8BigUIntRepresentation.serialize(), as: UTF8.self)
  }
}

// TODO: get rid of these and remove the whole dependency
extension BigUInt: ModularOperations {
  public func adding(_ other: BigUInt, modulo: BigUInt) -> BigUInt {
    (self + other) % modulo
  }
  
  public func subtracting(_ other: BigUInt, modulo: BigUInt) -> BigUInt {
    BigUInt((BigInt(self) - BigInt(other)) %% BigInt(modulo))
  }
  
  public func multiplying(_ other: BigUInt, modulo: BigUInt) -> BigUInt {
    (self * other) % modulo
  }
}

