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
  @_versioned internal let p = UnsafeMutablePointer<AtomicUWord>.allocate(capacity: 1)

  public init(_ value: UInt = 0)
  {
    AtomicUWordInit(value, p)
  }

  public var value: UInt {
    @inline(__always)
    get { return AtomicUWordLoad(p, .relaxed) }
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
    return AtomicUWordLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    AtomicUWordStore(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordAdd(value, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordAdd(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordSub(value, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordSub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordOr(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordXor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return AtomicUWordAnd(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicUWordStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicUWordWeakCAS(current, future, p, orderSwap, orderLoad)
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
