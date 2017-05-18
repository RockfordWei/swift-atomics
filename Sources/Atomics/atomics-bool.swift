//
//  atomics-bool.swift
//  Atomics
//
//  Created by Guillaume Lessard on 10/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicBool
{
  @_versioned internal let p = UnsafeMutablePointer<AtomicBoolean>.allocate(capacity: 1)

  public init(_ value: Bool = false)
  {
    AtomicBooleanInit(value, p)
  }

  public var value: Bool {
    @inline(__always)
    get { return AtomicBooleanLoad(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicBool
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed) -> Bool
  {
    return AtomicBooleanLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    AtomicBooleanStore(value, p, order)
  }

  @inline(__always) @discardableResult
  public func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanOr(value, p, order)
  }

  @inline(__always) @discardableResult
  public func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanXor(value, p, order)
  }

  @inline(__always) @discardableResult
  public func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanAnd(value, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Bool>, future: Bool,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicBooleanStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicBooleanWeakCAS(current, future, p, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: Bool, future: Bool,
                  type: CASType = .weak,
                  order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
