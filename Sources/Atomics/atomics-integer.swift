//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

// MARK: Int and UInt Atomics

public struct AtomicInt
{
  @_versioned internal let p: UnsafeMutablePointer<AtomicWord>
  public init(_ value: Int = 0)
  {
    let pointer = UnsafeMutablePointer<AtomicWord>.allocate(capacity: 1)
    InitWord(value, pointer)
    p = pointer
  }

  public var value: Int {
    @inline(__always)
    get { return ReadWord(p, memory_order_relaxed) }
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
    return ReadWord(p, order.order)
  }

  @inline(__always)
  public func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(value, p, order.order)
  }

  @inline(__always)
  public func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SwapWord(value, p, order.order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:Int, order: MemoryOrder = .relaxed) -> Int
  {
    return OrWord(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:Int, order: MemoryOrder = .relaxed) -> Int
  {
    return XorWord(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AndWord(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return CASWord(current, future, p, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCASWord(current, future, p, orderSwap.order, orderLoad.order)
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
  @_versioned internal let p: UnsafeMutablePointer<AtomicWord>
  public init(_ value: UInt = 0)
  {
    let pointer = UnsafeMutablePointer<AtomicWord>.allocate(capacity: 1)
    InitWord(Int(bitPattern: value), pointer)
    p = pointer
  }

  public var value: UInt {
    @inline(__always)
    get { return UInt(bitPattern: ReadWord(p, memory_order_relaxed)) }
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
    return UInt(bitPattern: ReadWord(p, order.order))
  }

  @inline(__always)
  public func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(Int(bitPattern: value), p, order.order)
  }

  @inline(__always)
  public func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SwapWord(Int(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AddWord(Int(bitPattern: delta), p, order.order))
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AddWord(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SubWord(Int(bitPattern: delta), p, order.order))
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SubWord(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: OrWord(Int(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: XorWord(Int(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AndWord(Int(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Int.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CASWord(current, Int(bitPattern: future), p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCASWord(current, Int(bitPattern: future), p, orderSwap.order, orderLoad.order)
      }
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

// MARK: Int32 and UInt32 Atomics

public struct AtomicInt32
{
  @_versioned internal let p: UnsafeMutablePointer<Atomic32>
  public init(_ value: Int32 = 0)
  {
    let pointer = UnsafeMutablePointer<Atomic32>.allocate(capacity: 1)
    Init32(value, pointer)
    p = pointer
  }

  public var value: Int32 {
    @inline(__always)
    get { return Read32(p, memory_order_relaxed) }
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
    return Read32(p, order.order)
  }

  @inline(__always)
  public func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    Store32(value, p, order.order)
  }

  @inline(__always)
  public func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Swap32(value, p, order.order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Add32(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return Add32(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Sub32(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return Sub32(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Or32(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Xor32(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return And32(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return CAS32(current, future, p, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCAS32(current, future, p, orderSwap.order, orderLoad.order)
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
  @_versioned internal let p: UnsafeMutablePointer<Atomic32>
  public init(_ value: UInt32 = 0)
  {
    let pointer = UnsafeMutablePointer<Atomic32>.allocate(capacity: 1)
    Init32(Int32(bitPattern: value), pointer)
    p = pointer
  }

  public var value: UInt32 {
    @inline(__always)
    get { return UInt32(bitPattern: Read32(p, memory_order_relaxed)) }
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
    return UInt32(bitPattern: Read32(p, order.order))
  }

  @inline(__always)
  public func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    Store32(Int32(bitPattern: value), p, order.order)
  }

  @inline(__always)
  public func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Swap32(Int32(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Add32(Int32(bitPattern: delta), p, order.order))
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Add32(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Sub32(Int32(bitPattern: delta), p, order.order))
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Sub32(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Or32(Int32(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Xor32(Int32(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: And32(Int32(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Int32.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAS32(current, Int32(bitPattern: future), p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCAS32(current, Int32(bitPattern: future), p, orderSwap.order, orderLoad.order)
      }
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

// MARK: Int64 and UInt64 Atomics

public struct AtomicInt64
{
  @_versioned internal let p: UnsafeMutablePointer<Atomic64>
  public init(_ value: Int64 = 0)
  {
    let pointer = UnsafeMutablePointer<Atomic64>.allocate(capacity: 1)
    Init64(value, pointer)
    p = pointer
  }

  public var value: Int64 {
    @inline(__always)
    get { return Read64(p, memory_order_relaxed) }
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
    return Read64(p, order.order)
  }

  @inline(__always)
  public func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    Store64(value, p, order.order)
  }

  @inline(__always)
  public func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Swap64(value, p, order.order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Add64(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return Add64(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Sub64(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return Sub64(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Or64(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Xor64(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return And64(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return CAS64(current, future, p, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCAS64(current, future, p, orderSwap.order, orderLoad.order)
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
  @_versioned internal let p: UnsafeMutablePointer<Atomic64>
  public init(_ value: UInt64 = 0)
  {
    let pointer = UnsafeMutablePointer<Atomic64>.allocate(capacity: 1)
    Init64(Int64(bitPattern: value), pointer)
    p = pointer
  }

  public var value: UInt64 {
    @inline(__always)
    get { return UInt64(bitPattern: Read64(p, memory_order_relaxed)) }
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
    return UInt64(bitPattern: Read64(p, order.order))
  }

  @inline(__always)
  public func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    Store64(Int64(bitPattern: value), p, order.order)
  }

  @inline(__always)
  public func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Swap64(Int64(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Add64(Int64(bitPattern: delta), p, order.order))
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Add64(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Sub64(Int64(bitPattern: delta), p, order.order))
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Sub64(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Or64(Int64(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Xor64(Int64(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: And64(Int64(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Int64.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAS64(current, Int64(bitPattern: future), p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCAS64(current, Int64(bitPattern: future), p, orderSwap.order, orderLoad.order)
      }
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
