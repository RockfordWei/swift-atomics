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
import func Glibc.usleep
#endif

import struct Foundation.Date
import Dispatch

import Atomics

func nzRandom() -> UInt
{
  // Return a nonzero, positive Int less than (or equal to) Int32.max/2.
  #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    return UInt(arc4random() & 0x3fff_fffe + 1)
  #else
    return UInt(random() & 0x3fff_fffe + 1)
  #endif
}

public class AtomicsTests: XCTestCase
{
  public static var allTests = [
    ("testInt", testInt),
    ("testUInt", testUInt),
    ("testInt32", testInt32),
    ("testUInt32", testUInt32),
    ("testInt64", testInt64),
    ("testUInt64", testUInt64),
    ("testBool", testBool),
    ("testFence", testFence),
    ("testRawPointer", testRawPointer),
    ("testMutableRawPointer", testMutableRawPointer),
    ("testUnsafePointer", testUnsafePointer),
    ("testUnsafeMutablePointer", testUnsafeMutablePointer),
    ("testOpaquePointer", testOpaquePointer),
    ("testUnmanaged", testUnmanaged),
    ("testExample", testExample),
  ]

  public func testInt()
  {
    let i = AtomicInt()
    XCTAssert(i.value == 0)

    let r1 = Int(nzRandom())
    let r2 = Int(nzRandom())
    let r3 = Int(nzRandom())

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

    let r1 = UInt(nzRandom())
    let r2 = UInt(nzRandom())
    let r3 = UInt(nzRandom())

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

    let r1 = Int32(nzRandom())
    let r2 = Int32(nzRandom())
    let r3 = Int32(nzRandom())

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

    let r1 = UInt32(nzRandom())
    let r2 = UInt32(nzRandom())
    let r3 = UInt32(nzRandom())

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

    let r1 = Int64(nzRandom())
    let r2 = Int64(nzRandom())
    let r3 = Int64(nzRandom())

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

    let r1 = UInt64(nzRandom())
    let r2 = UInt64(nzRandom())
    let r3 = UInt64(nzRandom())

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

  public func testRawPointer()
  {
    let i = AtomicRawPointer()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafeRawPointer(bitPattern: nzRandom())
    let r2 = UnsafeRawPointer(bitPattern: nzRandom())
    let r3 = UnsafeRawPointer(bitPattern: nzRandom())

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

  public func testMutableRawPointer()
  {
    let i = AtomicMutableRawPointer()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafeMutableRawPointer(bitPattern: nzRandom())
    let r2 = UnsafeMutableRawPointer(bitPattern: nzRandom())
    let r3 = UnsafeMutableRawPointer.allocate(bytes: 8, alignedTo: 8)
    let intp = r3.assumingMemoryBound(to: UInt.self)
    let rando = nzRandom()
    intp.pointee = rando

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

    let value = i.pointer?.assumingMemoryBound(to: UInt.self).pointee
    XCTAssert(rando == value)
    r3.deallocate(bytes: 8, alignedTo: 8)

    i.destroy()
  }

  public func testUnsafePointer()
  {
    let i = AtomicPointer<Int8>()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafePointer<Int8>(bitPattern: nzRandom())
    let r2 = UnsafePointer<Int8>(bitPattern: nzRandom())
    let r3 = UnsafePointer<Int8>(bitPattern: nzRandom())

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
    let i = AtomicMutablePointer<Int>()
    XCTAssert(i.pointer == nil)

    let r1 = UnsafeMutablePointer<Int>(bitPattern: nzRandom())
    let r2 = UnsafeMutablePointer<Int>(bitPattern: nzRandom())
    let r3 = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    let rando = Int(bitPattern: nzRandom())
    r3.pointee = rando

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

    let value = i.pointer?.pointee
    XCTAssert(rando == value)
    r3.deallocate(capacity: 1)

    i.destroy()
  }

  public func testOpaquePointer()
  {
    let i = AtomicOpaquePointer()
    XCTAssert(i.pointer == nil)

    let r1 = OpaquePointer(bitPattern: nzRandom())
    let r2 = OpaquePointer(bitPattern: nzRandom())
    let r3 = OpaquePointer(bitPattern: nzRandom())

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

  private class Thing
  {
    let id: UInt
    init(_ x: UInt = nzRandom()) { id = x }
    deinit { print("Released     \(id)") }
  }

  public func testUnmanaged()
  {
    var i = nzRandom()
    let a = AtomicReference(Thing(i))
    do {
      let r1 = a.swap(.none)
      print("Will release \(i)")
      XCTAssert(r1 != nil)
    }

    i = nzRandom()
    XCTAssert(a.swap(Thing(i)) == nil)
    print("Releasing    \(i)")
    XCTAssert(a.swap(nil) != nil)

    i = nzRandom()
    XCTAssert(a.swapIfNil(Thing(i)) == true)
    let j = nzRandom()
    print("Will drop    \(j)")
    XCTAssert(a.swapIfNil(Thing(j)) == false)

    print("Will release \(i)")
    XCTAssert(a.take() != nil)
    XCTAssert(a.take() == nil)

    a.destroy()
  }

  private struct TestStruct
  {
    var a = AtomicInt(0)
    var b = AtomicInt(1)
    var c = AtomicInt(2)
    var d = AtomicInt(3)

    func print()
    {
      Swift.print("\(a.value) \(b.value) \(c.value) \(d.value)")
    }
  }

  public func testExample()
  {
    let value = AtomicInt(0)

    print(value.swap(1))
    print(value.value)
    value.store(2)
    print(value.value)
    print("")
    value.destroy()

    let p = AtomicMutablePointer(UnsafeMutablePointer<Int>.allocate(capacity: 1))
    print(p.pointer!)

    let q = AtomicMutablePointer(p.load())
    let r = q.swap(UnsafeMutablePointer<Int>.allocate(capacity: 1))
    p.store(q.pointer)

    print(q.pointer!)
    print(r!)
    print(p.pointer!)
    print("")
    p.destroy()
    q.destroy()

    let pp = AtomicPointer<Int>(UnsafeMutablePointer<Int>.allocate(capacity: 1))

    print(pp.pointer!)

    let qq = AtomicPointer(pp.load())
    let rr = qq.swap(UnsafePointer(UnsafeMutablePointer<Int>.allocate(capacity: 1)))
    pp.store(qq.pointer)

    print(qq.pointer!)
    print(rr!)
    print(pp.pointer!)
    print("")
    pp.destroy()
    qq.destroy()

    let i = AtomicInt32(Int32(nzRandom()))
    print(i.value)

    let j = AtomicInt32(i.load())
    let k = j.swap(Int32(nzRandom()), order: .acqrel)
    i.store(j.value)

    print(j.value)
    print(k)
    print(i.value)
    print("")
    i.destroy()
    j.destroy()

    let ii = AtomicInt64(Int64(nzRandom()))
    print(ii.value)

    let jj = AtomicInt64(ii.load())
    let kk = jj.swap(numericCast(nzRandom()))
    ii.store(jj.value)

    print(jj.value)
    print(kk)
    print(ii.value)
    print("")
    ii.destroy()
    jj.destroy()

    var start = Date()
    var dt = Date().timeIntervalSince(start)
    let iterations = 1_000_000

    start = Date()
    for _ in 1...iterations
    {
      value.store(numericCast(nzRandom()))
    }
    dt = Date().timeIntervalSince(start)
    print(Int(1e9*dt/Double(iterations)))

    start = Date()
    for _ in 1...iterations
    {
      value.store(numericCast(nzRandom()))
    }
    dt = Date().timeIntervalSince(start)
    print(Int(1e9*dt/Double(iterations)))

    start = Date()
    for _ in 1...iterations
    {
      value.store(numericCast(nzRandom()))
    }
    dt = Date().timeIntervalSince(start)
    print(Int(1e9*dt/Double(iterations)))
    print("")

    let t = TestStruct()
    t.print()

    t.c.store(4)

    let g = DispatchGroup()
    DispatchQueue.global().async(group: g) {
      t.print()
      let v = t.a.swap(5)
      usleep(1000)
      t.b.store(v, order: .sequential)
    }

    usleep(500)
    t.print()
    g.wait()
    t.print()

    print("")
    let pt = UnsafeMutablePointer<TestStruct>.allocate(capacity: 1)
    pt.pointee = TestStruct()
    pt.pointee.print()

    pt.pointee.c.store(4)

    DispatchQueue.global().async(group: g) {
      pt.pointee.print()
      let v = pt.pointee.a.swap(5)
      usleep(1000)
      pt.pointee.b.store(v, order: .sequential)
    }

    usleep(500)
    pt.pointee.print()
    g.wait()
    pt.pointee.print()

    pt.deallocate(capacity: 1)
  }
}

public class AtomicsPerformanceTests: XCTestCase
{
  public static var allTests = [
    ("testPerformanceRead", testPerformanceRead),
    ("testPerformanceSynchronizedRead", testPerformanceSynchronizedRead),
    ("testPerformanceStore", testPerformanceStore),
    ("testPerformanceSynchronizedStore", testPerformanceSynchronizedStore),
    ("testPerformanceSwiftCASSuccess", testPerformanceSwiftCASSuccess),
    ("testPerformanceSwiftCASFailure", testPerformanceSwiftCASFailure),
    ("testPerformanceOSAtomicCASSuccess", testPerformanceOSAtomicCASSuccess),
    ("testPerformanceOSAtomicCASFailure", testPerformanceOSAtomicCASFailure),
  ]

  let testLoopCount = 1_000_000

  public func testPerformanceStore()
  {
    let c = testLoopCount
    let m = AtomicInt(0)
    measure {
      m.store(0)
      for i in 0..<c { m.store(i, order: .relaxed) }
    }
    m.destroy()
  }

  public func testPerformanceSynchronizedStore()
  {
    let c = testLoopCount
    let m = AtomicInt(0)
    measure {
      m.store(0)
      for i in 0..<c { m.store(i, order: .sequential) }
    }
    m.destroy()
  }

  public func testPerformanceRead()
  {
    let c = testLoopCount
    let m = AtomicInt(0)
    measure {
      m.store(0)
      for _ in 0..<c { _ = m.load(order: .relaxed) }
    }
    m.destroy()
  }

  public func testPerformanceSynchronizedRead()
  {
    let c = testLoopCount
    let m = AtomicInt(0)
    measure {
      m.store(0)
      for _ in 0..<c { _ = m.load(order: .sequential) }
    }
    m.destroy()
  }

  public func testPerformanceSwiftCASSuccess()
  {
    let c = Int32(testLoopCount)
    let m = AtomicInt32(0)
    measure {
      m.store(0)
      for i in (m.value)..<c { m.CAS(current: i, future: i&+1) }
    }
    m.destroy()
  }

  public func testPerformanceOSAtomicCASSuccess()
  {
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      let c = Int32(testLoopCount)
      var m = Int32(0)
      measure {
        m = 0
        for i in m..<c { OSAtomicCompareAndSwap32(i, i&+1, &m) }
      }
    #else
      print("test not supported on Linux")
    #endif
  }

  public func testPerformanceSwiftCASFailure()
  {
    let c = Int32(testLoopCount)
    let m = AtomicInt32(0)
    measure {
      m.store(0)
      for i in (m.value)..<c { m.CAS(current: i, future: 0) }
    }
    m.destroy()
  }

  public func testPerformanceOSAtomicCASFailure()
  {
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      let c = Int32(testLoopCount)
      var m = Int32(0)
      measure {
        m = 0
        for i in m..<c { OSAtomicCompareAndSwap32(i, 0, &m) }
      }
    #else
      print("test not supported on Linux")
    #endif
  }
}
