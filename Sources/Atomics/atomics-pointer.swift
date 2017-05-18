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
  @_versioned internal let p = UnsafeMutablePointer<AtomicVoidPointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafeMutableRawPointer? = nil)
  {
    AtomicPointerInit(pointer, p)
  }

  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    get {
      return AtomicPointerLoad(p, .relaxed)
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
    return AtomicPointerLoad(p, order)
  }

  @inline(__always)
  public func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return AtomicPointerSwap(pointer, p, order)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                      future: UnsafeMutableRawPointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, future, p, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, future, p, orderSwap, orderLoad)
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
  @_versioned internal let p = UnsafeMutablePointer<AtomicVoidPointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafeRawPointer? = nil)
  {
    AtomicPointerInit(pointer, p)
  }

  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    get {
      return UnsafeRawPointer(AtomicPointerLoad(p, .relaxed))
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
    return UnsafeRawPointer(AtomicPointerLoad(p, order))
  }

  @inline(__always)
  public func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(AtomicPointerSwap(pointer, p, order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                      future: UnsafeRawPointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    switch type {
    case .strong:
      return AtomicPointerStrongCAS(current, future, p, orderSwap, orderLoad)
    case .weak:
      return AtomicPointerWeakCAS(current, future, p, orderSwap, orderLoad)
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
  @_versioned internal let p = UnsafeMutablePointer<AtomicVoidPointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafeMutablePointer<Pointee>? = nil)
  {
    AtomicPointerInit(pointer, p)
  }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    get {
      return AtomicPointerLoad(p, .relaxed)?.assumingMemoryBound(to: Pointee.self)
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
    return AtomicPointerLoad(p, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return AtomicPointerSwap(pointer, p, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                      future: UnsafeMutablePointer<Pointee>?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, future, p, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, future, p, orderSwap, orderLoad)
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
  @_versioned internal let p = UnsafeMutablePointer<AtomicVoidPointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafePointer<Pointee>? = nil)
  {
    AtomicPointerInit(pointer, p)
  }

  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    get {
      return UnsafePointer(AtomicPointerLoad(p, .relaxed)?.assumingMemoryBound(to: Pointee.self))
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
    return UnsafePointer(AtomicPointerLoad(p, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(AtomicPointerSwap(pointer, p, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                      future: UnsafePointer<Pointee>?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, future, p, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, future, p, orderSwap, orderLoad)
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
  @_versioned internal let p = UnsafeMutablePointer<AtomicVoidPointer>.allocate(capacity: 1)

  public init(_ pointer: OpaquePointer? = nil)
  {
    AtomicPointerInit(UnsafeRawPointer(pointer), p)
  }

  public var pointer: OpaquePointer? {
    @inline(__always)
    get {
      return OpaquePointer(AtomicPointerLoad(p, .relaxed))
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
    return OpaquePointer(AtomicPointerLoad(p, order))
  }

  @inline(__always)
  public func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(UnsafePointer(pointer), p, order)
  }

  @inline(__always)
  public func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(AtomicPointerSwap(UnsafePointer(pointer), p, order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                      future: OpaquePointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, UnsafePointer(future), p, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, UnsafePointer(future), p, orderSwap, orderLoad)
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
