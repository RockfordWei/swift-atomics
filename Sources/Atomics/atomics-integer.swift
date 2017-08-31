//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

public struct AtomicInt
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsInt>.allocate(capacity: 1)

  public init(_ value: Int = 0)
  {
    CAtomicsIntInit(value, p)
  }

  public var value: Int {
    @inline(__always)
    get { return CAtomicsIntLoad(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicInt
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsIntStore(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntAdd(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntSub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntOr(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntXor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntAnd(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntAdd(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return CAtomicsIntSub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsIntCAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: Int, future: Int,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsUInt>.allocate(capacity: 1)

  public init(_ value: UInt = 0)
  {
    CAtomicsUIntInit(value, p)
  }

  public var value: UInt {
    @inline(__always)
    get { return CAtomicsUIntLoad(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicUInt
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsUIntStore(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntAdd(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntSub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntOr(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntXor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntAnd(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntAdd(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return CAtomicsUIntSub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsUIntCAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: UInt, future: UInt,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicInt8
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsInt8>.allocate(capacity: 1)

  public init(_ value: Int8 = 0)
  {
    CAtomicsInt8Init(value, p)
  }

  public var value: Int8 {
    @inline(__always)
    get { return CAtomicsInt8Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicInt8
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsInt8Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return CAtomicsInt8Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsInt8CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: Int8, future: Int8,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt8
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsUInt8>.allocate(capacity: 1)

  public init(_ value: UInt8 = 0)
  {
    CAtomicsUInt8Init(value, p)
  }

  public var value: UInt8 {
    @inline(__always)
    get { return CAtomicsUInt8Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicUInt8
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsUInt8Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return CAtomicsUInt8Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsUInt8CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: UInt8, future: UInt8,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicInt16
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsInt16>.allocate(capacity: 1)

  public init(_ value: Int16 = 0)
  {
    CAtomicsInt16Init(value, p)
  }

  public var value: Int16 {
    @inline(__always)
    get { return CAtomicsInt16Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicInt16
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsInt16Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return CAtomicsInt16Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsInt16CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: Int16, future: Int16,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt16
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsUInt16>.allocate(capacity: 1)

  public init(_ value: UInt16 = 0)
  {
    CAtomicsUInt16Init(value, p)
  }

  public var value: UInt16 {
    @inline(__always)
    get { return CAtomicsUInt16Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicUInt16
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsUInt16Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return CAtomicsUInt16Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsUInt16CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: UInt16, future: UInt16,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicInt32
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsInt32>.allocate(capacity: 1)

  public init(_ value: Int32 = 0)
  {
    CAtomicsInt32Init(value, p)
  }

  public var value: Int32 {
    @inline(__always)
    get { return CAtomicsInt32Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicInt32
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsInt32Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return CAtomicsInt32Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsInt32CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: Int32, future: Int32,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt32
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsUInt32>.allocate(capacity: 1)

  public init(_ value: UInt32 = 0)
  {
    CAtomicsUInt32Init(value, p)
  }

  public var value: UInt32 {
    @inline(__always)
    get { return CAtomicsUInt32Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsUInt32Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return CAtomicsUInt32Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsUInt32CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: UInt32, future: UInt32,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicInt64
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsInt64>.allocate(capacity: 1)

  public init(_ value: Int64 = 0)
  {
    CAtomicsInt64Init(value, p)
  }

  public var value: Int64 {
    @inline(__always)
    get { return CAtomicsInt64Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicInt64
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsInt64Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return CAtomicsInt64Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsInt64CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: Int64, future: Int64,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt64
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsUInt64>.allocate(capacity: 1)

  public init(_ value: UInt64 = 0)
  {
    CAtomicsUInt64Init(value, p)
  }

  public var value: UInt64 {
    @inline(__always)
    get { return CAtomicsUInt64Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsUInt64Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return CAtomicsUInt64Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsUInt64CAS(current, future, p, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public func CAS(current: UInt64, future: UInt64,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
