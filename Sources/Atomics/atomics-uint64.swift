//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt64
{
  @_versioned internal var p = UnsafeMutablePointer<Atomic64>.allocate(capacity: 1)

  public init(_ value: UInt64 = 0)
  {
    Atomic64Init(Int64(bitPattern: value), p)
  }

  public var value: UInt64 {
    @inline(__always)
    get { return UInt64(bitPattern: Atomic64Load(p, memory_order_relaxed)) }
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
    return UInt64(bitPattern: Atomic64Load(p, order.order))
  }

  @inline(__always)
  public func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    Atomic64Store(Int64(bitPattern: value), p, order.order)
  }

  @inline(__always)
  public func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Swap(Int64(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func add(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Add(Int64(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Add(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func subtract(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Sub(Int64(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Sub(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Or(Int64(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Xor(Int64(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64And(Int64(bitPattern: bits), p, order.order))
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
        return Atomic64StrongCAS(current, Int64(bitPattern: future), p, orderSwap.order, orderLoad.order)
      case .weak:
        return Atomic64WeakCAS(current, Int64(bitPattern: future), p, orderSwap.order, orderLoad.order)
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
