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
  @_versioned internal let p = UnsafeMutablePointer<AtomicWord>.allocate(capacity: 1)

  public init(_ value: Int = 0)
  {
    AtomicWordInit(value, p)
  }

  public var value: Int {
    @inline(__always)
    get { return AtomicWordLoad(p, .relaxed) }
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
    return AtomicWordLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    AtomicWordStore(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordAdd(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordAdd(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordSub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordSub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordOr(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordXor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordAnd(bits, p, order)
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
      return AtomicWordStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicWordWeakCAS(current, future, p, orderSwap, orderLoad)
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
