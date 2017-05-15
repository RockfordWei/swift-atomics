//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt
{
  @_versioned internal var p = UnsafeMutablePointer<AtomicWord>.allocate(capacity: 1)

  public init(_ value: UInt = 0)
  {
    AtomicWordInit(Int(bitPattern: value), p)
  }

  public var value: UInt {
    @inline(__always)
    get { return UInt(bitPattern: AtomicWordLoad(p, memory_order_relaxed)) }
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
    return UInt(bitPattern: AtomicWordLoad(p, order.order))
  }

  @inline(__always)
  public func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    AtomicWordStore(Int(bitPattern: value), p, order.order)
  }

  @inline(__always)
  public func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordSwap(Int(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func add(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordAdd(Int(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordAdd(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func subtract(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordSub(Int(bitPattern: value), p, order.order))
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordSub(1, p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordOr(Int(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordXor(Int(bitPattern: bits), p, order.order))
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordAnd(Int(bitPattern: bits), p, order.order))
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
        return AtomicWordStrongCAS(current, Int(bitPattern: future), p, orderSwap.order, orderLoad.order)
      case .weak:
        return AtomicWordWeakCAS(current, Int(bitPattern: future), p, orderSwap.order, orderLoad.order)
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
