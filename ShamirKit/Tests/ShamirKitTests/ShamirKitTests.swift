import XCTest
@testable import ShamirKit

final class ShamirKitTests: XCTestCase {
  func testShamir() {
    var rng = LCRNG(seed: 6)
    let shares = shamir(secret: 500, using: &rng)
    
    
    XCTAssertEqual(500, unshamir(shares: shares))
  }
  
  //afaik this is just for linux, we can reenable it if need be
  //  static var allTests = [
  //    ("testShamir", testShamir),
  //  ]
}
