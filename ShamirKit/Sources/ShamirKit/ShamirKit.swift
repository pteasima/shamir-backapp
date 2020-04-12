import Foundation
import ModularArithmetic

extension BinaryInteger where Self: ModularOperations {
  @inlinable
  func dividing(_ other: Self, modulo: Self) -> Self {
    self * other.inverse(modulo: modulo)! //TODO: when is this nil?
  }
}

// 2-of-2

// eventually this will have to be found in shamir, returned and passed to unshamir.
// unless I can somehow keep using this hardcoded one (largest UInt64 prime) even when working with larger than UInt64 data.
// the python code hardcodes 12th Mersenne prime
// afaik it should depend on size of secret and then be returned and made public as stated above
//let p: UInt64 = 18446744073709551557
let p = 127 //4th Mersenne prime, TODO: make this larger


func generateShares<G: RandomNumberGenerator>(/*for secret: UInt64,*/ threshold k: Int, using rng: inout G) -> (secret: Int, shares: [(x: Int, y: Int)]) {
//  precondition(secret < p)
  let polynomial = (0..<k).map { _ in Int.random(in: 0..<p, using: &rng) }
  func evaluate(polynomial: [Int], at x: Int) -> Int {
    var accum = 0
    for coeff in polynomial.reversed() {
      accum *= x
      accum += coeff
      accum %= p
    }
    return accum
  }
  let points = (1...k).map { ($0, evaluate(polynomial: polynomial, at: $0)) }
  return (polynomial[0], points)
}

func recoverSecret(shares: [(x: Int, y: Int)]) -> Int {
  func lagrangeInterpolate() -> Int {
    func PI(_ vals: [Int]) -> Int { // product of inputs
      return vals.reduce(1, *)
    }
    let k = shares.count
    let xs = shares.map { $0.x }
    precondition(Set(xs).count == xs.count) //points are unique
    let ys = shares.map { $0.y }
    var nums: [Int] = []
    var dens: [Int] = []
    for i in 0..<k {
      var others = shares.map { $0.x }
      let cur = others.remove(at: i)
      nums.append(PI(others.map { -$0 })) //`x - o` but x is 0
      dens.append(PI(others.map { cur - $0}))
    }
    let den = PI(dens)
    let toSum = (0..<k).map { i in ((nums[i] * den * ys[i]) %% p).dividing(dens[i], modulo: p) }
    let num = toSum.reduce(0, +)
    return (num.dividing(den, modulo: p) + p) %% p
  }
  return lagrangeInterpolate()
}

