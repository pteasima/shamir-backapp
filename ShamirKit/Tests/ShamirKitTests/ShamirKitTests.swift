import XCTest
@testable import ShamirKit

final class ShamirKitTests: XCTestCase {
  func testShamir() {
    var rng = LCRNG(seed: 6)
    let shares = shamirWithNumbers(500, using: &rng)
    
    func secretFromShamirShares(shares: [UInt64]) -> UInt64 {
      print(shares[0])
      print(shares[1])
      return UInt64(-(Int(shares[1]) - (2 * Int(shares[0]))))
    }
    
    XCTAssertEqual(500, secretFromShamirShares(shares: shares))
  }
  
  //afaik this is just for linux, we can reenable it if need be
  //  static var allTests = [
  //    ("testShamir", testShamir),
  //  ]
}
