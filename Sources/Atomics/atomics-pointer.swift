//
//  atomics-pointer.swift
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015, 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

// MARK: Pointer Atomics

public struct AtomicMutableRawPointer
{
  @_versioned internal let p: UnsafeMutablePointer<RawPointer>
  public init(_ pointer: UnsafeMutableRawPointer? = nil)
  {
    let ptr = UnsafeMutablePointer<RawPointer>.allocate(capacity: 1)
    InitRawPtr(pointer, ptr)
    p = ptr
  }

  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    get {
      return ReadRawPtr(p, memory_order_relaxed)
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicMutableRawPointer
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return ReadRawPtr(p, order.order)
  }

  @inline(__always)
  public func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, p, order.order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return SwapRawPtr(pointer, p, order.order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                      future: UnsafeMutableRawPointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
      }
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                  type: CASType = .weak,
                  order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicRawPointer
{
  @_versioned internal let p: UnsafeMutablePointer<RawPointer>
  public init(_ pointer: UnsafeRawPointer? = nil)
  {
    let ptr = UnsafeMutablePointer<RawPointer>.allocate(capacity: 1)
    InitRawPtr(pointer, ptr)
    p = ptr
  }

  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    get {
      return UnsafeRawPointer(ReadRawPtr(p, memory_order_relaxed))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicRawPointer
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(ReadRawPtr(p, order.order))
  }

  @inline(__always)
  public func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, p, order.order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(SwapRawPtr(pointer, p, order.order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                      future: UnsafeRawPointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return CASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                  type: CASType = .weak,
                  order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicMutablePointer<Pointee>
{
  @_versioned internal let p: UnsafeMutablePointer<RawPointer>
  public init(_ pointer: UnsafeMutablePointer<Pointee>? = nil)
  {
    let ptr = UnsafeMutablePointer<RawPointer>.allocate(capacity: 1)
    InitRawPtr(pointer, ptr)
    p = ptr
  }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    get {
      return ReadRawPtr(p, memory_order_relaxed)?.assumingMemoryBound(to: Pointee.self)
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicMutablePointer
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return ReadRawPtr(p, order.order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, p, order.order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return SwapRawPtr(pointer, p, order.order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                      future: UnsafeMutablePointer<Pointee>?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
      }
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                  type: CASType = .weak,
                  order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicPointer<Pointee>
{
  @_versioned internal let p: UnsafeMutablePointer<RawPointer>
  public init(_ pointer: UnsafePointer<Pointee>? = nil)
  {
    let ptr = UnsafeMutablePointer<RawPointer>.allocate(capacity: 1)
    InitRawPtr(pointer, ptr)
    p = ptr
  }

  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    get {
      return UnsafePointer(ReadRawPtr(p, memory_order_relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicPointer
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(ReadRawPtr(p, order.order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, p, order.order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(SwapRawPtr(pointer, p, order.order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                      future: UnsafePointer<Pointee>?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCASRawPtr(current, future, p, orderSwap.order, orderLoad.order)
      }
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                  type: CASType = .weak,
                  order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicOpaquePointer
{
  @_versioned internal let p: UnsafeMutablePointer<RawPointer>
  public init(_ pointer: OpaquePointer? = nil)
  {
    let ptr = UnsafeMutablePointer<RawPointer>.allocate(capacity: 1)
    InitRawPtr(UnsafeRawPointer(pointer), ptr)
    p = ptr
  }

  public var pointer: OpaquePointer? {
    @inline(__always)
    get {
      return OpaquePointer(ReadRawPtr(p, memory_order_relaxed))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }
}

extension AtomicOpaquePointer
{
  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(ReadRawPtr(p, order.order))
  }

  @inline(__always)
  public func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(UnsafePointer(pointer), p, order.order)
  }

  @inline(__always)
  public func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(SwapRawPtr(UnsafePointer(pointer), p, order.order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                      future: OpaquePointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CASRawPtr(current, UnsafePointer(future), p, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCASRawPtr(current, UnsafePointer(future), p, orderSwap.order, orderLoad.order)
      }
    }
  }

  @inline(__always) @discardableResult
  public func CAS(current: OpaquePointer?, future: OpaquePointer?,
                  type: CASType = .weak,
                  order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
