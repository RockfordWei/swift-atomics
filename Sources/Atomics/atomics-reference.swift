//
//  atomics-reference.swift
//  Atomics
//
//  Created by Guillaume Lessard on 1/16/17.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

public struct AtomicReference<T: AnyObject>
{
  @_versioned internal var ptr = CAtomicsPointer()

  public init(_ ref: T? = nil)
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    CAtomicsPointerInit(u, &ptr)
  }
}

extension AtomicReference
{
  @inline(__always)
  public mutating func swap(_ ref: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    if let pointer = CAtomicsPointerSwap(u, &ptr, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }

  @inline(__always)
  public mutating func swapIfNil(_ ref: T, order: MemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(ref)
    var null: UnsafeRawPointer? = nil
    if CAtomicsPointerCAS(&null, u.toOpaque(), &ptr, .strong, order, .relaxed)
    {
      _ = u.retain()
      return true
    }
    return false
  }

  @inline(__always)
  public mutating func take(order: MemoryOrder = .sequential) -> T?
  {
    if let pointer = CAtomicsPointerSwap(nil, &ptr, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }
}

extension Unmanaged
{
  @_versioned static func tryRetain(_ optional: Instance?) -> Unmanaged<Instance>?
  {
    guard let reference = optional else { return nil }
    return Unmanaged.passRetained(reference)
  }
}
