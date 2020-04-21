import XCTest
@testable import ShamirKit
import BigInt

final class ShamirKitTests: XCTestCase {
  
  func testRandomBigUInt() {
    var rng = LCRNG(seed: 0) //TODO: fuzz test this or something
    let random = BigUInt.random(in: BigUInt("100000000000000000000000000000")..<BigUInt("200000000000000000000000000000"), using: &rng)
    print(random)
    XCTAssert(random >= "100000000000000000000000000000")
    XCTAssert(random < "200000000000000000000000000000")
  }
  
  func testShamir() throws {
    var rng = LCRNG(seed: 2)
    let secret = "🤷‍♂️"
    let secretInt = secret.utf8BigUIntRepresentation
    print(secretInt)
    let (points, pPower) = try generateShares(secret: secretInt, threshold: 100, using: &rng)
    print(pPower)
    let recoveredSecretInt = recoverSecret(shares: points, mersennePrimePower: pPower)
    print(recoveredSecretInt)
    let recoveredSecret = String(utf8BigUIntRepresentation: recoveredSecretInt)
    print(recoveredSecret)
    
    
//    let shares = shamir(secret: 500, using: &rng)
    XCTAssertEqual(secret, recoveredSecret)
  }
  
  func testPlayground() {
//    XCTAssertEqual(p, BigUInt(2).power(127) - 1)
//    print(BigUInt(2).power(216_091) - 1)
    let secret = "🤷‍♂️fdsaljkfd"
    let secretInt = secret.utf8BigUIntRepresentation
    let bitWidth = secretInt.bitWidth - secretInt.leadingZeroBitCount
    let firstLargerMersennePrimePower = powers.first { $0 > bitWidth }!
    print(BigUInt(2).power(firstLargerMersennePrimePower) - 1)
    
  }
  
  //afaik this is just for linux, we can reenable it if need be
  //  static var allTests = [
  //    ("testShamir", testShamir),
  //  ]
}
