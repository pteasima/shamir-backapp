import Foundation

func shamirWithNumbers<G: RandomNumberGenerator>(_ input: UInt64, using rng: inout G) -> [UInt64] {
  let grad = UInt64.random(in: UInt64.min...10000, using: &rng)
  return [input + grad, input + 2 * grad]
}

func shamir(_ input: String, rngSeed: Int = 0, numberOfShares: Int = 2) ->  [String] {
  fatalError()
}
