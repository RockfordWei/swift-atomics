//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt16
{
  @_versioned internal let p = UnsafeMutablePointer<AtomicU16>.allocate(capacity: 1)

  public init(_ value: UInt16 = 0)
  {
    AtomicU16Init(value, p)
  }

  public var value: UInt16 {
    @inline(__always)
    get { return AtomicU16Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicUInt16
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Load(p, order)
  }

  @inline(__always)
  public func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU16Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU16StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicU16WeakCAS(current, future, p, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: UInt16, future: UInt16,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
