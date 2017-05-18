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
  @_versioned internal let p = UnsafeMutablePointer<Atomic32>.allocate(capacity: 1)

  public init(_ value: UInt32 = 0)
  {
    Atomic32Init(Int32(bitPattern: value), p)
  }

  public var value: UInt32 {
    @inline(__always)
    get { return UInt32(bitPattern: Atomic32Load(p, .relaxed)) }
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
    return UInt32(bitPattern: Atomic32Load(p, order))
  }

  @inline(__always)
  public func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    Atomic32Store(Int32(bitPattern: value), p, order)
  }

  @inline(__always)
  public func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Swap(Int32(bitPattern: value), p, order))
  }

  @inline(__always) @discardableResult
  public func add(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Add(Int32(bitPattern: value), p, order))
  }

  @inline(__always) @discardableResult
  public func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Add(1, p, order))
  }

  @inline(__always) @discardableResult
  public func subtract(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Sub(Int32(bitPattern: value), p, order))
  }

  @inline(__always) @discardableResult
  public func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Sub(1, p, order))
  }

  @inline(__always) @discardableResult
  public func bitwiseOr(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Or(Int32(bitPattern: bits), p, order))
  }

  @inline(__always) @discardableResult
  public func bitwiseXor(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Xor(Int32(bitPattern: bits), p, order))
  }

  @inline(__always) @discardableResult
  public func bitwiseAnd(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32And(Int32(bitPattern: bits), p, order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return current.withMemoryRebound(to: Int32.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return Atomic32StrongCAS(current, Int32(bitPattern: future), p, orderSwap, orderLoad)
      case .weak:
        return Atomic32WeakCAS(current, Int32(bitPattern: future), p, orderSwap, orderLoad)
      }
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
