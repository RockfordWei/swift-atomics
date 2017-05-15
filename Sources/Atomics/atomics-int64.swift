//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt64
{
  @_versioned internal var p = UnsafeMutablePointer<Atomic64>.allocate(capacity: 1)

  public init(_ value: Int64 = 0)
  {
    Atomic64Init(value, p)
  }

  public var value: Int64 {
    @inline(__always)
    get { return Atomic64Load(p, memory_order_relaxed) }
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
    return Atomic64Load(p, order.order)
  }

  @inline(__always)
  public func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    Atomic64Store(value, p, order.order)
  }

  @inline(__always)
  public func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Swap(value, p, order.order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Add(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Add(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Sub(delta, p, order.order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Sub(1, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Or(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Xor(bits, p, order.order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64And(bits, p, order.order)
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
      return Atomic64StrongCAS(current, future, p, orderSwap.order, orderLoad.order)
    case .weak:
      return Atomic64WeakCAS(current, future, p, orderSwap.order, orderLoad.order)
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
