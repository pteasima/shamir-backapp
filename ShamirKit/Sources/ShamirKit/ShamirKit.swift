import Foundation

func shamir<G: RandomNumberGenerator>(secret: UInt64, using rng: inout G) -> [UInt64] {
  let grad = UInt64.random(in: UInt64.min...10000, using: &rng)
  return [secret + grad, secret + 2 * grad]
}

func unshamir(shares: [UInt64]) -> UInt64 {
  print(shares[0])
  print(shares[1])
  return UInt64(-(Int(shares[1]) - (2 * Int(shares[0]))))
}
