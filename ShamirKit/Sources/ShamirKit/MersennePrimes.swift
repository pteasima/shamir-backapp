import Foundation
import BigInt

//https://en.wikipedia.org/wiki/Mersenne_prime


//powers that generate mersenne primes. Theres more of them known but this is more than can be reasonably computed.
let powers = [
  2,
  3,
  5,
  7,
  13,
  17,
  19,
  31,
  61,
  89,
  107,
  127,
  521,
  607,
  1_279,
  2_203,
  2_281,
  3_217,
  4_253,
  4_423,
  9_689,
  9_941,
  11_213,
  19_937,
  21_701,
  23_209,
  44_497,
  86_243,
  110_503,
  132_049,
  216_091,
  756_839,
  859_433,
]

extension Int {
  static func mersennePrimePower(greaterThan number: BigUInt) throws -> Int {
    let bitWidth = number.bitWidth
    //TODO: usually >= bitWidth is enough, unless self is the mersenne prime itself (which we can tell by checking that its all ones)
    return try powers.first { $0 > bitWidth } ?? { throw ShamirError.secretTooLarge }()
  }
}

extension BigUInt {
  static func mersenePrime(withPower power: Int) -> BigUInt {
    BigUInt(2).power(power) - 1 //TODO: this just means power ones with leading zeros (if power is 3, this will be 00000111), we can do that efficiently with a buffer
  }
}
