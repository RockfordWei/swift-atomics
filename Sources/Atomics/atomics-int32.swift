//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt32
{
  @_versioned internal let p = UnsafeMutablePointer<Atomic32>.allocate(capacity: 1)

  public init(_ value: Int32 = 0)
  {
    Atomic32Init(value, p)
  }

  public var value: Int32 {
    @inline(__always)
    get { return Atomic32Load(p, .relaxed) }
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
    return Atomic32Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    Atomic32Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return Atomic32StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return Atomic32WeakCAS(current, future, p, orderSwap, orderLoad)
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
