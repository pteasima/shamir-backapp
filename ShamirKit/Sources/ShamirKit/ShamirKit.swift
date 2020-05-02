import Foundation
import ModularArithmetic
import BigInt

public struct Share: Hashable {
  public init(x: Int, y: BigUInt) { self.x = x; self.y = y }
  public let x: Int
  public let y: BigUInt
}
public struct SharesContainer: Hashable {
  public init(id: UInt16, shares: [Share], threshold: Int, bitWidth: Int) {
    self.id = id
    self.shares = shares
    self.threshold = threshold
    self.bitWidth = bitWidth
  }
  
  public var id: UInt16 //randomly generated ID to tell which shares go together, Trezor uses 15 bits, we have one more 😀
  public var shares: [Share]
  public var threshold: Int //this was input to the algorithm and returned unchanged, so that we can tell home many shares are needed
  public var bitWidth: Int //bitWidth ones must be a mersenne prime (i.e. bitWidth must be a mersenne prime power)
}

public struct FullShare: Hashable, Codable {
  public let uuid: UInt16
  public let bitWidth: Int
  public let threshold: Int
  public let x: Int
  public let y: BigUInt
}

public extension SharesContainer {
  var fullShares: [FullShare] {
    return shares.map {
      FullShare(uuid: id, bitWidth: bitWidth, threshold: threshold, x: $0.x, y: $0.y)
    }
  }
}

public func generateShares<G: RandomNumberGenerator>(secret: BigUInt, threshold k: Int, using rng: inout G) throws -> SharesContainer {
  let id = UInt16.random(in: UInt16.min...UInt16.max, using: &rng)
  let mersennePrimePower = try Int.mersennePrimePower(greaterThan: max(secret, BigUInt(k)))
  let p = BigUInt.mersenePrime(withPower: mersennePrimePower)
  print("p", p)
  let polynomial = [secret] + (1..<k).map { _ in BigUInt.random(in: 0..<p, using: &rng) }
  func evaluate(polynomial: [BigUInt], at x: Int) -> BigUInt {
    var accum: BigUInt = 0
    for coeff in polynomial.reversed() {
      accum = accum.multiplying(BigUInt(x), modulo: p)
      accum = accum.adding(coeff, modulo: p)
    }
    return accum
  }
  let points = (1...k).map { Share(x: $0, y: evaluate(polynomial: polynomial, at: $0)) }
  return .init(id: id, shares: points, threshold: k, bitWidth: mersennePrimePower)
}

public func recoverSecret(shares: [Share], mersennePrimePower: Int) -> BigUInt {
  let p = BigUInt.mersenePrime(withPower: mersennePrimePower)
  print("p", p)
  func lagrangeInterpolate() -> BigUInt {
    func PI(_ vals: [BigUInt]) -> BigUInt { // product of inputs
      return vals.reduce(1) { $0.multiplying($1, modulo: p) }
    }
    let k = shares.count
    let xs = shares.map { $0.x }
    precondition(Set(xs).count == xs.count) //points are unique
    let ys = shares.map { $0.y }
    var nums: [BigUInt] = []
    var dens: [BigUInt] = []
    for i in 0..<k {
      var others = shares.map { BigUInt($0.x) }
      let cur = others.remove(at: i)
      nums.append(PI(others.map { BigUInt(0).subtracting($0, modulo: p) })) //`x - o` but x is 0
      dens.append(PI(others.map { cur.subtracting($0, modulo: p) }))
    }
    let den = PI(dens)
    let toSum = (0..<k).map { i in nums[i].multiplying(den, modulo: p).multiplying(ys[i], modulo: p).dividing(dens[i], modulo: p) }
    let num = toSum.reduce(BigUInt(0)) { $0.adding($1, modulo: p) }
    return (num.dividing(den, modulo: p) + p) %% p
  }
  return lagrangeInterpolate()
}

