//
//  Contrast.swift
//  Contrast
//
//  Created by Brian Semiglia on 10/15/16.
//  Copyright © 2016 Brian Semiglia. All rights reserved.
//

import Foundation

public enum GranulatedEquality {
  case none
  case partial
  case complete
}

public protocol Granularelatable {
  func equality(_ input: Self) -> GranulatedEquality
}

public struct Shifted<T: Equatable> {
  public let element: T
  public let origin: Int
  public let destination: Int
  public init(element: T, origin: Int, destination: Int) {
    self.element = element
    self.origin = origin
    self.destination = destination
  }
}

extension Shifted: Equatable {
  public static func ==(left: Shifted, right: Shifted) -> Bool { return
    left.origin == right.origin &&
    left.destination == right.destination &&
    left.element == right.element
  }
}

public struct PathShifted<T> {
  public let element: T
  public let origin: IndexPath
  public let destination: IndexPath
  public init(element: T, origin: IndexPath, destination: IndexPath) {
    self.element = element
    self.origin = origin
    self.destination = destination
  }
}

extension PathShifted: Equatable {
  public static func ==(left: PathShifted, right: PathShifted) -> Bool { return
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

public extension Collection where Iterator.Element: Hashable, Iterator.Element: Granularelatable {

  public func shifts(_ input: Self) -> [Shifted<Iterator.Element>] { return
    enumerated()
    .flatMap { item in
      input.enumerated()
      .filter {
        $0.element.equality(item.element) != .none &&
        $0.offset != item.offset
      }
      .map { match in
        Shifted(
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
    .filter { x in
      !self.contains(
        where: {
          x.element.equality($0) == .complete ||
          x.element.equality($0) == .partial
        }
      )
    }
    .map {
      Indexed(
        element: $0.element,
        index: $0.offset
      )
    }
  }
  
  public func deletions(_ input: Self) -> [Indexed<Iterator.Element>] { return
    enumerated()
    .filter { x in
      !input.contains(
        where: {
          x.element.equality($0) == .complete ||
          x.element.equality($0) == .partial
        }
      )
    }
    .map {
      Indexed(
        element: $0.element,
        index: $0.offset
      )
    }
  }
  
  public func updates(_ input: Self) -> [Indexed<Iterator.Element>] { return
    input
    .enumerated()
    .filter { x in
      self.contains(
        where: {
          x.element.equality($0) == .partial
        }
      )
    }
    .map {
      Indexed(
        element: $0.element,
        index: $0.offset
      )
    }
  }
  
  internal func filtered(_ first: Self, second: Self, filter: GranulatedEquality) -> [Indexed<Iterator.Element>] { return
    first
    .enumerated()
    .filter { x in second.reduce(false, { sum, y in sum == true || y.equality(x.element) == filter }) }
    .map { Indexed(element: $0.element, index: $0.offset) }
  }
}

public extension Array where Element: Collection, Element.Iterator.Element: Hashable, Element.Iterator.Element: Granularelatable {
  
  public func shifts(_ input: [Element]) -> [PathShifted<Element.Iterator.Element>] { return
    indexedFlattened()
    .flatMap { item in
      input
      .indexedFlattened()
      .filter { $0.element.equality(item.element) != .none && $0.index != item.index }
      .map { match in
        PathShifted(
          element: item.element,
          origin: item.index,
          destination: match.index
        )
      }
    }
  }
  
  public func additions(_ input: [Element]) -> [PathIndexed<Element.Iterator.Element>] { return
    input
    .indexedFlattened()
    .flatMap { item in
      if
      !indexedFlattened()
      .contains(where: { $0.element.equality(item.element) == .complete }) { return
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
      if
      !input
      .indexedFlattened()
      .contains(where: { $0.element.equality(item.element) == .complete }) { return
        PathIndexed(
          element: item.element,
          index: item.index
        )
      } else { return
        nil
      }
    }
  }
  
  public func updates(_ input: [Element]) -> [PathIndexed<Element.Iterator.Element>] { return
    input
    .indexedFlattened()
    .flatMap { item in
      if
      indexedFlattened()
      .contains(where: { $0.element.equality(item.element) == .partial }) { return
        PathIndexed(
          element: item.element,
          index: item.index
        )
      } else { return
        nil
      }
    }
  }
  
  private func indexedFlattened() -> [PathIndexed<Element.Iterator.Element>] { return
    enumerated()
    .flatMap { section in
      section
      .element
      .enumerated().map { item in
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
