//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt
{
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsSWord>.allocate(capacity: 1)

  public init(_ value: Int = 0)
  {
    ClangAtomicsSWordInit(value, p)
  }

  public var value: Int {
    @inline(__always)
    get { return ClangAtomicsSWordLoad(p, .relaxed) }
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
    return ClangAtomicsSWordLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsSWordStore(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordAdd(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordSub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordOr(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordXor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordAnd(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordAdd(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordSub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsSWordStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsSWordWeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsUWord>.allocate(capacity: 1)

  public init(_ value: UInt = 0)
  {
    ClangAtomicsUWordInit(value, p)
  }

  public var value: UInt {
    @inline(__always)
    get { return ClangAtomicsUWordLoad(p, .relaxed) }
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
    return ClangAtomicsUWordLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUWordStore(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordAdd(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordSub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordOr(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordXor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordAnd(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordAdd(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordSub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUWordStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUWordWeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsS8>.allocate(capacity: 1)

  public init(_ value: Int8 = 0)
  {
    ClangAtomicsS8Init(value, p)
  }

  public var value: Int8 {
    @inline(__always)
    get { return ClangAtomicsS8Load(p, .relaxed) }
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
    return ClangAtomicsS8Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS8Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS8StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS8WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsU8>.allocate(capacity: 1)

  public init(_ value: UInt8 = 0)
  {
    ClangAtomicsU8Init(value, p)
  }

  public var value: UInt8 {
    @inline(__always)
    get { return ClangAtomicsU8Load(p, .relaxed) }
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
    return ClangAtomicsU8Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU8Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU8StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU8WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsS16>.allocate(capacity: 1)

  public init(_ value: Int16 = 0)
  {
    ClangAtomicsS16Init(value, p)
  }

  public var value: Int16 {
    @inline(__always)
    get { return ClangAtomicsS16Load(p, .relaxed) }
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
    return ClangAtomicsS16Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS16Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS16StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS16WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsU16>.allocate(capacity: 1)

  public init(_ value: UInt16 = 0)
  {
    ClangAtomicsU16Init(value, p)
  }

  public var value: UInt16 {
    @inline(__always)
    get { return ClangAtomicsU16Load(p, .relaxed) }
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
    return ClangAtomicsU16Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU16Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU16StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU16WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsS32>.allocate(capacity: 1)

  public init(_ value: Int32 = 0)
  {
    ClangAtomicsS32Init(value, p)
  }

  public var value: Int32 {
    @inline(__always)
    get { return ClangAtomicsS32Load(p, .relaxed) }
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
    return ClangAtomicsS32Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS32Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS32StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS32WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsU32>.allocate(capacity: 1)

  public init(_ value: UInt32 = 0)
  {
    ClangAtomicsU32Init(value, p)
  }

  public var value: UInt32 {
    @inline(__always)
    get { return ClangAtomicsU32Load(p, .relaxed) }
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
    return ClangAtomicsU32Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU32Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU32StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU32WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsS64>.allocate(capacity: 1)

  public init(_ value: Int64 = 0)
  {
    ClangAtomicsS64Init(value, p)
  }

  public var value: Int64 {
    @inline(__always)
    get { return ClangAtomicsS64Load(p, .relaxed) }
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
    return ClangAtomicsS64Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS64Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS64StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS64WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsU64>.allocate(capacity: 1)

  public init(_ value: UInt64 = 0)
  {
    ClangAtomicsU64Init(value, p)
  }

  public var value: UInt64 {
    @inline(__always)
    get { return ClangAtomicsU64Load(p, .relaxed) }
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
    return ClangAtomicsU64Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU64Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU64StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU64WeakCAS(current, future, p, orderSwap, orderLoad)
    }
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
