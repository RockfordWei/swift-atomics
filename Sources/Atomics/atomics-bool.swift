//
//  atomics-bool.swift
//  Atomics
//
//  Created by Guillaume Lessard on 10/06/2016.
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

public struct AtomicBool
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsBoolean>.allocate(capacity: 1)

  public init(_ value: Bool = false)
  {
    CAtomicsBooleanInit(value, p)
  }

  public var value: Bool {
    @inline(__always)
    get { return CAtomicsBooleanLoad(p, .relaxed) }
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
    return CAtomicsBooleanLoad(p, order)
  }

  @inline(__always)
  public func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsBooleanStore(value, p, order)
  }

  @inline(__always) @discardableResult
  public func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanSwap(value, p, order)
  }

  @inline(__always) @discardableResult
  public func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanOr(value, p, order)
  }

  @inline(__always) @discardableResult
  public func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanXor(value, p, order)
  }

  @inline(__always) @discardableResult
  public func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanAnd(value, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<Bool>, future: Bool,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsBooleanCAS(current, future, p, type, orderSwap, orderLoad)
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
