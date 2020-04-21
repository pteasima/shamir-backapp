import Foundation
import BigInt

//taken from https://forums.swift.org/t/modulo-operation-in-swift/7018/2
infix operator %%: MultiplicationPrecedence

func %%<T: BinaryInteger>(lhs: T, rhs: T) -> T {
    let rem = lhs % rhs // -rhs <= rem <= rhs
    return rem >= 0 ? rem : rem + rhs
}

func %%(lhs: BigInt, rhs: BigInt) -> BigInt {
    let rem = lhs % rhs // -rhs <= rem <= rhs
    return rem >= 0 ? rem : rem + rhs
}
