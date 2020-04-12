import XCTest
@testable import ShamirKit

final class ShamirKitTests: XCTestCase {
  func testShamir() {
    var rng = LCRNG(seed: 2)
    
    let (secret,points) = generateShares(threshold: 100, using: &rng)
    print(secret)
    print(points)
    let recoveredSecret = recoverSecret(shares: points)
    print(recoveredSecret)
    
//    let shares = shamir(secret: 500, using: &rng)
    XCTAssertEqual(secret, recoveredSecret)
  }
  
  //afaik this is just for linux, we can reenable it if need be
  //  static var allTests = [
  //    ("testShamir", testShamir),
  //  ]
}
