import Foundation

// a RandomNumberGenerator that can be seeded
// taken from https://github.com/pointfreeco/episode-code-samples/blob/0506da94f9db74ce19fa965f44e57258a2aa3c1c/0048-predictable-randomness-pt2/PredictableRandomness.playground/Contents.swift#L107
struct LCRNG: RandomNumberGenerator {
  var seed: UInt64

  init(seed: UInt64) {
    self.seed = seed
  }

  mutating func next() -> UInt64 {
    seed = 2862933555777941757 &* seed &+ 3037000493
    return seed
  }
}
