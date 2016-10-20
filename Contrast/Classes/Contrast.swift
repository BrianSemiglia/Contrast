//
//  Contrast.swift
//  Contrast
//
//  Created by Brian Semiglia on 10/15/16.
//  Copyright © 2016 Brian Semiglia. All rights reserved.
//

import Foundation

public struct Shift<T: Equatable> {
  public let element: T
  public let origin: Int
  public let destination: Int
  
  public init(element: T, origin: Int, destination: Int) {
    self.element = element
    self.origin = origin
    self.destination = destination
  }
}

extension Shift: Equatable {
  public static func ==(left: Shift, right: Shift) -> Bool { return
    left.origin == right.origin &&
    left.destination == right.destination &&
    left.element == right.element
  }
}

public struct PathShift<T> {
  public let element: T
  public let origin: IndexPath
  public let destination: IndexPath
  
  public init(element: T, origin: IndexPath, destination: IndexPath) {
    self.element = element
    self.origin = origin
    self.destination = destination
  }
}

extension PathShift: Equatable {
  public static func ==(left: PathShift, right: PathShift) -> Bool { return
    left.origin == right.origin &&
    left.destination == right.destination
  }
}

public struct Indexed<T: Equatable> {
  public let element: T
  public let index: Int
  public init(element: T, index: Int) {
    self.element = element
    self.index = index
  }
}

extension Indexed: Equatable {
  public static func ==(left: Indexed, right: Indexed) -> Bool { return
    left.element == right.element &&
    left.index == right.index
  }
}

public struct PathIndexed<T: Equatable> {
  public let element: T
  public let index: IndexPath
  public init(element: T, index: IndexPath) {
    self.element = element
    self.index = index
  }
}

extension PathIndexed: Equatable {
  public static func ==(left: PathIndexed, right: PathIndexed) -> Bool { return
    left.index == right.index &&
    left.element == right.element
  }
}

public extension Collection where Iterator.Element: Hashable {

  public func shifts(_ input: Self) -> [Shift<Iterator.Element>] { return
    enumerated().flatMap { item in return
      input.enumerated()
      .filter { $0.element == item.element && $0.offset != item.offset }
      .map { match in
        Shift(
          element: item.element,
          origin: item.offset,
          destination: match.offset
        )
      }
    }
  }
  
  public func additions(_ input: Self) -> [Indexed<Iterator.Element>] { return
    input
    .enumerated()
    .filter { !contains($0.element) }
    .map { Indexed(element: $0.element, index: $0.offset) }
  }
  
  public func deletions(_ input: Self) -> [Indexed<Iterator.Element>] { return
    enumerated()
    .filter { !input.contains($0.element) }
    .map { Indexed(element: $0.element, index: $0.offset) }
  }
  
}

public extension Array where Element: Collection, Element.Iterator.Element: Hashable {
  
  public func shifts(_ input: [Element]) -> [PathShift<Element.Iterator.Element>] { return
    indexedFlattened().flatMap { item in return
      input.indexedFlattened()
      .filter { $0.element == item.element && $0.index != item.index }
      .map { match in
        PathShift(
          element: item.element,
          origin: item.index,
          destination: match.index
        )
      }
    }
  }
  
  public func additions(_ input: [Element]) -> [PathIndexed<Element.Iterator.Element>] { return
    input.indexedFlattened().flatMap { item in
      if !indexedFlattened().contains(where: { $0.element == item.element }) { return
        PathIndexed(
          element: item.element,
          index: item.index
        )
      } else { return
        nil
      }
    }
  }
  
  public func deletions(_ input: [Element]) -> [PathIndexed<Element.Iterator.Element>] { return
    indexedFlattened().flatMap { item in
      if !input.indexedFlattened().contains(where: { $0.element == item.element }) { return
        PathIndexed(
          element: item.element,
          index: item.index
        )
      } else { return
        nil
      }
    }
  }
  
  public func indexedFlattened() -> [PathIndexed<Element.Iterator.Element>] { return
    enumerated().flatMap { section in
      section.element.enumerated().map { item in
        PathIndexed(
          element: item.element,
          index: IndexPath(
            row: item.offset,
            section: section.offset
          )
        )
      }
    }
  }

}
