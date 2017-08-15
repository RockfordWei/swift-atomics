//
//  AtomicsTests.swift
//  AtomicsTests
//
//  Created by Guillaume Lessard on 2015-07-06.
//  Copyright © 2015 Guillaume Lessard. All rights reserved.
//

import XCTest

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import func Darwin.libkern.OSAtomic.OSAtomicCompareAndSwap32
import func Darwin.C.stdlib.arc4random
#else // assuming os(Linux)
import func Glibc.random
#endif

import Dispatch

import Atomics

#if swift(>=4.0)
extension FixedWidthInteger
{
  // returns a positive random integer greater than 0 and less-than-or-equal to Self.max/2
  // the least significant bit is always set.
  static func nzRandom() -> Self
  {
    var t = Self()
    for _ in 0...((t.bitWidth-1)/32)
    {
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      t = t<<32 &+ Self(truncatingIfNeeded: arc4random())
    #else // probably Linux
      t = t<<32 &+ Self(truncatingIfNeeded: random())
    #endif
    }
    return (t|1) & (Self.max>>1)
  }
}
#else
extension UInt
{
  // returns a positive random integer greater than 0 and less-than-or-equal to UInt32.max/2
  // the least significant bit is always set.
  static func nzRandom() -> UInt
  {
  #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    return UInt(arc4random() & 0x3fff_fffe + 1)
  #else
    return UInt(random() & 0x3fff_fffe + 1)
  #endif
  }
}
#endif


public class AtomicsTests: XCTestCase
{
  public static var allTests = [
    ("testInt", testInt),
    ("testUInt", testUInt),
    ("testInt8", testInt8),
    ("testUInt8", testUInt8),
    ("testInt16", testInt16),
    ("testUInt16", testUInt16),
    ("testInt32", testInt32),
    ("testUInt32", testUInt32),
    ("testInt64", testInt64),
    ("testUInt64", testUInt64),
    ("testUnsafeRawPointer", testUnsafeRawPointer),
    ("testUnsafeMutableRawPointer", testUnsafeMutableRawPointer),
    ("testUnsafePointer", testUnsafePointer),
    ("testUnsafeMutablePointer", testUnsafeMutablePointer),
    ("testOpaquePointer", testOpaquePointer),
    ("testBool", testBool),
    ("testFence", testFence),
    ("testUnmanaged", testUnmanaged),
  ]

  public func testInt()
  {
    let i = AtomicInt()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = Int.nzRandom()
    let r2 = Int.nzRandom()
    let r3 = Int.nzRandom()
  #else
    let r1 = Int(UInt.nzRandom())
    let r2 = Int(UInt.nzRandom())
    let r3 = Int(UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUInt()
  {
    let i = AtomicUInt()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = UInt.nzRandom()
    let r2 = UInt.nzRandom()
    let r3 = UInt.nzRandom()
  #else
    let r1 = UInt(UInt.nzRandom())
    let r2 = UInt(UInt.nzRandom())
    let r3 = UInt(UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testInt8()
  {
    let i = AtomicInt8()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = Int8.nzRandom()
    let r2 = Int8.nzRandom()
    let r3 = Int8.nzRandom()
  #else
    let r1 = Int8(truncatingBitPattern: UInt.nzRandom())
    let r2 = Int8(truncatingBitPattern: UInt.nzRandom())
    let r3 = Int8(truncatingBitPattern: UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUInt8()
  {
    let i = AtomicUInt8()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = UInt8.nzRandom()
    let r2 = UInt8.nzRandom()
    let r3 = UInt8.nzRandom()
  #else
    let r1 = UInt8(truncatingBitPattern: UInt.nzRandom())
    let r2 = UInt8(truncatingBitPattern: UInt.nzRandom())
    let r3 = UInt8(truncatingBitPattern: UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testInt16()
  {
    let i = AtomicInt16()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = Int16.nzRandom()
    let r2 = Int16.nzRandom()
    let r3 = Int16.nzRandom()
  #else
    let r1 = Int16(truncatingBitPattern: UInt.nzRandom())
    let r2 = Int16(truncatingBitPattern: UInt.nzRandom())
    let r3 = Int16(truncatingBitPattern: UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUInt16()
  {
    let i = AtomicUInt16()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = UInt16.nzRandom()
    let r2 = UInt16.nzRandom()
    let r3 = UInt16.nzRandom()
  #else
    let r1 = UInt16(truncatingBitPattern: UInt.nzRandom())
    let r2 = UInt16(truncatingBitPattern: UInt.nzRandom())
    let r3 = UInt16(truncatingBitPattern: UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testInt32()
  {
    let i = AtomicInt32()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = Int32.nzRandom()
    let r2 = Int32.nzRandom()
    let r3 = Int32.nzRandom()
  #else
    let r1 = Int32(truncatingBitPattern: UInt.nzRandom())
    let r2 = Int32(truncatingBitPattern: UInt.nzRandom())
    let r3 = Int32(truncatingBitPattern: UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUInt32()
  {
    let i = AtomicUInt32()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = UInt32.nzRandom()
    let r2 = UInt32.nzRandom()
    let r3 = UInt32.nzRandom()
  #else
    let r1 = UInt32(truncatingBitPattern: UInt.nzRandom())
    let r2 = UInt32(truncatingBitPattern: UInt.nzRandom())
    let r3 = UInt32(truncatingBitPattern: UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testInt64()
  {
    let i = AtomicInt64()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = Int64.nzRandom()
    let r2 = Int64.nzRandom()
    let r3 = Int64.nzRandom()
  #else
    let r1 = Int64(UInt.nzRandom())
    let r2 = Int64(UInt.nzRandom())
    let r3 = Int64(UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUInt64()
  {
    let i = AtomicUInt64()
    XCTAssert(i.value == 0)

  #if swift(>=4.0)
    let r1 = UInt64.nzRandom()
    let r2 = UInt64.nzRandom()
    let r3 = UInt64.nzRandom()
  #else
    let r1 = UInt64(UInt.nzRandom())
    let r2 = UInt64(UInt.nzRandom())
    let r3 = UInt64(UInt.nzRandom())
  #endif

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUnsafeRawPointer()
  {
    let i = AtomicRawPointer()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafeRawPointer(bitPattern: UInt.nzRandom())
    let r2 = UnsafeRawPointer(bitPattern: UInt.nzRandom())
    let r3 = UnsafeRawPointer(bitPattern: UInt.nzRandom())

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUnsafeMutableRawPointer()
  {
    let i = AtomicMutableRawPointer()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.nzRandom())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.nzRandom())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.nzRandom())

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUnsafePointer()
  {
    let i = AtomicPointer<Int64>()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafePointer<Int64>(bitPattern: UInt.nzRandom())
    let r2 = UnsafePointer<Int64>(bitPattern: UInt.nzRandom())
    let r3 = UnsafePointer<Int64>(bitPattern: UInt.nzRandom())

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testUnsafeMutablePointer()
  {
    let i = AtomicMutablePointer<Int64>()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafeMutablePointer<Int64>(bitPattern: UInt.nzRandom())
    let r2 = UnsafeMutablePointer<Int64>(bitPattern: UInt.nzRandom())
    let r3 = UnsafeMutablePointer<Int64>(bitPattern: UInt.nzRandom())

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }

  public func testOpaquePointer()
  {
    let i = AtomicOpaquePointer()
    XCTAssert(i.pointer == nil)

    let r1 = OpaquePointer(bitPattern: UInt.nzRandom())
    let r2 = OpaquePointer(bitPattern: UInt.nzRandom())
    let r3 = OpaquePointer(bitPattern: UInt.nzRandom())

    i.store(r1)
    XCTAssert(r1 == i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())

    i.destroy()
  }


  public func testBool()
  {
    let boolean = AtomicBool(false)
    _ = AtomicBool(true)
    XCTAssert(boolean.value == false)

    boolean.store(false)
    XCTAssert(boolean.value == false)

    boolean.store(true)
    XCTAssert(boolean.value == true)
    XCTAssert(boolean.value == boolean.load())

    boolean.store(true)
    boolean.or(true)
    XCTAssert(boolean.value == true)
    boolean.or(false)
    XCTAssert(boolean.value == true)
    boolean.store(false)
    boolean.or(false)
    XCTAssert(boolean.value == false)
    boolean.or(true)
    XCTAssert(boolean.value == true)

    boolean.and(false)
    XCTAssert(boolean.value == false)
    boolean.and(true)
    XCTAssert(boolean.value == false)

    boolean.xor(false)
    XCTAssert(boolean.value == false)
    boolean.xor(true)
    XCTAssert(boolean.value == true)

    let old = boolean.swap(false)
    XCTAssert(old == true)
    XCTAssert(boolean.swap(true) == false)

    boolean.CAS(current: true, future: false)
    if boolean.CAS(current: false, future: true, type: .strong)
    {
      boolean.CAS(current: true, future: false, type: .weak)
      boolean.CAS(current: false, future: true, type: .weak)
    }

    boolean.destroy()
  }

  public func testFence()
  {
    threadFence()
    threadFence(order: .sequential)
  }

  private class Thing
  {
    let id: UInt
    init(_ x: UInt = UInt.nzRandom()) { id = x }
    deinit { print("Released     \(id)") }
  }

  public func testUnmanaged()
  {
    var i = UInt.nzRandom()
    let a = AtomicReference(Thing(i))
    do {
      let r1 = a.swap(.none)
      print("Will release \(i)")
      XCTAssert(r1 != nil)
    }

    i = UInt.nzRandom()
    XCTAssert(a.swap(Thing(i)) == nil)
    print("Releasing    \(i)")
    XCTAssert(a.swap(nil) != nil)

    i = UInt.nzRandom()
    XCTAssert(a.swapIfNil(Thing(i)) == true)
    let j = UInt.nzRandom()
    print("Will drop    \(j)")
    XCTAssert(a.swapIfNil(Thing(j)) == false)

    print("Will release \(i)")
    XCTAssert(a.take() != nil)
    XCTAssert(a.take() == nil)

    i = UInt.nzRandom()
    print("will release \(i)")
    _ = a.swap(Thing(i))
    a.destroy()
  }
}
