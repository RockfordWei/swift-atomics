//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt8
{
  @_versioned internal let p = UnsafeMutablePointer<Atomic8>.allocate(capacity: 1)

  public init(_ value: Int8 = 0)
  {
    Atomic8Init(value, p)
  }

  public var value: Int8 {
    @inline(__always)
    get { return Atomic8Load(p, .relaxed) }
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
    return Atomic8Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    Atomic8Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return Atomic8StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return Atomic8WeakCAS(current, future, p, orderSwap, orderLoad)
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
