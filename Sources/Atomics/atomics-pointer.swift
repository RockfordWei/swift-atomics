//
//  atomics-pointer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

public struct AtomicMutableRawPointer
{
  @_versioned let p = UnsafeMutablePointer<CAtomicsMutablePointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafeMutableRawPointer? = nil)
  {
    CAtomicsMutablePointerInit(UnsafeMutableRawPointer(pointer), p)
  }

  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    get {
      return UnsafeMutableRawPointer(CAtomicsMutablePointerLoad(p, .relaxed))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }

  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return UnsafeMutableRawPointer(CAtomicsMutablePointerLoad(p, order))
  }

  @inline(__always)
  public func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsMutablePointerStore(UnsafeMutableRawPointer(pointer), p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return UnsafeMutableRawPointer(CAtomicsMutablePointerSwap(UnsafeMutableRawPointer(pointer), p, order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                      future: UnsafeMutableRawPointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeMutableRawPointer>.self, capacity: 1) {
      CAtomicsMutablePointerCAS($0, UnsafeMutableRawPointer(future), p, type, orderSwap, orderLoad)
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
  @_versioned let p = UnsafeMutablePointer<CAtomicsPointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafeRawPointer? = nil)
  {
    CAtomicsPointerInit(UnsafeRawPointer(pointer), p)
  }

  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    get {
      return UnsafeRawPointer(CAtomicsPointerLoad(p, .relaxed))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }

  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(CAtomicsPointerLoad(p, order))
  }

  @inline(__always)
  public func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsPointerStore(UnsafeRawPointer(pointer), p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(CAtomicsPointerSwap(UnsafeRawPointer(pointer), p, order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                      future: UnsafeRawPointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      CAtomicsPointerCAS($0, UnsafeRawPointer(future), p, type, orderSwap, orderLoad)
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
  @_versioned let p = UnsafeMutablePointer<CAtomicsMutablePointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafeMutablePointer<Pointee>? = nil)
  {
    CAtomicsMutablePointerInit(UnsafeMutableRawPointer(pointer), p)
  }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    get {
      return UnsafeMutablePointer<Pointee>(CAtomicsMutablePointerLoad(p, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }

  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsMutablePointerLoad(p, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsMutablePointerStore(UnsafeMutableRawPointer(pointer), p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsMutablePointerSwap(UnsafeMutableRawPointer(pointer), p, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                      future: UnsafeMutablePointer<Pointee>?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeMutableRawPointer>.self, capacity: 1) {
      CAtomicsMutablePointerCAS($0, UnsafeMutableRawPointer(future), p, type, orderSwap, orderLoad)
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
  @_versioned let p = UnsafeMutablePointer<CAtomicsPointer>.allocate(capacity: 1)

  public init(_ pointer: UnsafePointer<Pointee>? = nil)
  {
    CAtomicsPointerInit(UnsafeRawPointer(pointer), p)
  }

  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    get {
      return UnsafePointer<Pointee>(CAtomicsPointerLoad(p, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }

  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsPointerLoad(p, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsPointerStore(UnsafeRawPointer(pointer), p, order)
  }

  @inline(__always)
  public func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsPointerSwap(UnsafeRawPointer(pointer), p, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                      future: UnsafePointer<Pointee>?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      CAtomicsPointerCAS($0, UnsafeRawPointer(future), p, type, orderSwap, orderLoad)
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
  @_versioned let p = UnsafeMutablePointer<CAtomicsPointer>.allocate(capacity: 1)

  public init(_ pointer: OpaquePointer? = nil)
  {
    CAtomicsPointerInit(UnsafeRawPointer(pointer), p)
  }

  public var pointer: OpaquePointer? {
    @inline(__always)
    get {
      return OpaquePointer(CAtomicsPointerLoad(p, .relaxed))
    }
  }

  public func destroy()
  {
    p.deallocate(capacity: 1)
  }

  @inline(__always)
  public func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(CAtomicsPointerLoad(p, order))
  }

  @inline(__always)
  public func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsPointerStore(UnsafeRawPointer(pointer), p, order)
  }

  @inline(__always)
  public func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(CAtomicsPointerSwap(UnsafeRawPointer(pointer), p, order))
  }

  @inline(__always) @discardableResult
  public func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                      future: OpaquePointer?,
                      type: CASType = .weak,
                      orderSwap: MemoryOrder = .sequential,
                      orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      CAtomicsPointerCAS($0, UnsafeRawPointer(future), p, type, orderSwap, orderLoad)
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
