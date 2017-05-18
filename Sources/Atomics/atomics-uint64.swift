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
  @_versioned internal let p = UnsafeMutablePointer<AtomicU64>.allocate(capacity: 1)

  public init(_ value: UInt64 = 0)
  {
    AtomicU64Init(value, p)
  }

  public var value: UInt64 {
    @inline(__always)
    get { return AtomicU64Load(p, .relaxed) }
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
    return AtomicU64Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU64Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU64StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicU64WeakCAS(current, future, p, orderSwap, orderLoad)
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
