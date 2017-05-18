//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt8
{
  @_versioned internal let p = UnsafeMutablePointer<AtomicU8>.allocate(capacity: 1)

  public init(_ value: UInt8 = 0)
  {
    AtomicU8Init(value, p)
  }

  public var value: UInt8 {
    @inline(__always)
    get { return AtomicU8Load(p, .relaxed) }
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
    return AtomicU8Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU8Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU8StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicU8WeakCAS(current, future, p, orderSwap, orderLoad)
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
