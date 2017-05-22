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
  @_versioned let p = UnsafeMutablePointer<ClangAtomicsBoolean>.allocate(capacity: 1)

  public init(_ value: Bool = false)
  {
    ClangAtomicsBooleanInit(value, p)
  }

  public var value: Bool {
    @inline(__always)
    get { return ClangAtomicsBooleanLoad(p, .relaxed) }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicBool
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .relaxed)-> Bool
  {
    return ClangAtomicsBooleanLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsBooleanStore(value, p, order)
  }

  @inline(__always) @discardableResult
  public func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return ClangAtomicsBooleanSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return ClangAtomicsBooleanOr(value, p, order)
  }

  @inline(__always) @discardableResult
  public func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return ClangAtomicsBooleanXor(value, p, order)
  }

  @inline(__always) @discardableResult
  public func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return ClangAtomicsBooleanAnd(value, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Bool>, future: Bool,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsBooleanStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsBooleanWeakCAS(current, future, p, orderSwap, orderLoad)
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
