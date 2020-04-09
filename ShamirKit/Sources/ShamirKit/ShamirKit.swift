import Foundation

func shamir<G: RandomNumberGenerator>(secret: Int, using rng: inout G) -> [Int] {
  let maxGrad = 100_000
  precondition(secret < maxGrad)
  let grad = Int.random(in: Int.min...maxGrad, using: &rng)
  return [secret + grad, secret + 2 * grad]
}

func unshamir(shares: [Int]) -> Int {
  return -(shares[1] - (2 * shares[0]))
}
