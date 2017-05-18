//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt16
{
  @_versioned internal let p = UnsafeMutablePointer<Atomic16>.allocate(capacity: 1)

  public init(_ value: Int16 = 0)
  {
    Atomic16Init(value, p)
  }

  public var value: Int16 {
    @inline(__always)
    get { return Atomic16Load(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicInt16
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Load(p, order)
  }

  @inline(__always)
  public func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    Atomic16Store(value, p, order)
  }

  @inline(__always)
  public func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Swap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Add(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Add(1, p, order)
  }

  @inline(__always) @discardableResult
  public func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Sub(delta, p, order)
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Sub(1, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Or(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Xor(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16And(bits, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return Atomic16StrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return Atomic16WeakCAS(current, future, p, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: Int16, future: Int16,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
