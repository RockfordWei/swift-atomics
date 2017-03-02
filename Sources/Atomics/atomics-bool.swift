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
  @_versioned internal let p: UnsafeMutablePointer<Atomic32>
  public init(_ value: Bool = false)
  {
    let pointer = UnsafeMutablePointer<Atomic32>.allocate(capacity: 1)
    Init32(value ? 1 : 0, pointer)
    p = pointer
  }

  public var value: Bool {
    @inline(__always)
    get { return Read32(p, memory_order_relaxed) != 0 }
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
    return Read32(p, order.order) != 0
  }

  @inline(__always)
  public func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    Store32(value ? 1 : 0, p, order.order)
  }

  @inline(__always) @discardableResult
  public func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Swap32(value ? 1 : 0, p, order.order) != 0
  }

  @inline(__always) @discardableResult
  public func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Or32(value ? 1 : 0, p, order.order) != 0
  }

  @inline(__always) @discardableResult
  public func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Xor32(value ? 1 : 0, p, order.order) != 0
  }

  @inline(__always) @discardableResult
  public func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return And32(value ? 1 : 0, p, order.order) != 0
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: inout Bool, future: Bool,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .relaxed,
                      orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    var expect: Int32 = current ? 1 : 0
    let future: Int32 = future  ? 1 : 0
    let success: Bool
    switch type {
    case .strong:
      success = CAS32(&expect, future, p, orderSwap.order, orderLoad.order)
    case .weak:
      success = WeakCAS32(&expect, future, p, orderSwap.order, orderLoad.order)
    }
    current = expect != 0
    return success
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
