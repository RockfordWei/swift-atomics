//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt32
{
  @_versioned internal let p = UnsafeMutablePointer<AtomicU32>.allocate(capacity: 1)

  public init(_ value: UInt32 = 0)
  {
    AtomicU32Init(value, p)
  }

  public var value: UInt32 {
    @inline(__always)
    get { return AtomicU32Load(p, .relaxed) }
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
    return AtomicU32Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU32Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return AtomicU32And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU32StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicU32WeakCAS(current, future, p, orderSwap, orderLoad)
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
