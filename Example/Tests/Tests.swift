import UIKit
import XCTest
import Contrast

class Tests: XCTestCase {

  func testDeletions() {
    XCTAssert(
      ["a", "b"].deletions(["a", "b"])
      ==
      []
    )
  }
  
  func testDeletionsNone() {
    XCTAssert(
      ["a", "b"].deletions(["b"])
      ==
      [
        Indexed(element: "a", index: 0)
      ]
    )
  }
  
  func testUpdatesSome() {
    XCTAssert(
      [
        Updateable(value: "a", state: true),
        Updateable(value: "b", state: true)
      ]
      .updates([
        Updateable(value: "a", state: true),
        Updateable(value: "b", state: false)
      ])
      ==
      [
        Indexed(
          element: Updateable(
            value: "b",
            state: false
          ),
          index: 1
        )
      ]
    )
  }
  
  func testUpdatesNone() {
    XCTAssert(
      [
        Updateable(value: "a", state: true),
        Updateable(value: "b", state: true)
      ]
      .updates([
        Updateable(value: "a", state: true),
        Updateable(value: "b", state: true)
      ])
      ==
      []
    )
  }
  
  func testShiftSome() {
    XCTAssert(
      ["a", "b"].shifts(["b", "a"])
      ==
      [
        Shifted(element: "a", origin: 0, destination: 1),
        Shifted(element: "b", origin: 1, destination: 0)
      ]
    )
  }
  
  func testShiftAdditions() {
    XCTAssert(
      ["a", "b"].shifts(["b", "a", "c"])
      ==
      [
        Shifted(element: "a", origin: 0, destination: 1),
        Shifted(element: "b", origin: 1, destination: 0)
      ]
    )
  }
  
  func testAdditionsNone() {
    XCTAssert(
      ["a", "b"].additions(["a", "b"])
      ==
      []
    )
  }
  
  func testAdditionsAll() {
    XCTAssert(
      ["a", "b", "c"].additions(["d", "e", "f"])
      ==
      [
        Indexed(element: "d", index: 0),
        Indexed(element: "e", index: 1),
        Indexed(element: "f", index: 2)
      ]
    )
  }
  
  func testIntersectionalRowShift() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].shifts([["a", "d"], ["c", "b"]])
      ==
      [
        PathShifted(
          element: "b",
          origin: IndexPath(row: 1, section: 0),
          destination: IndexPath(row: 1, section: 1)
        ),
        PathShifted(
          element: "d",
          origin: IndexPath(row: 1, section: 1),
          destination: IndexPath(row: 1, section: 0)
        )
      ]
    )
  }
  
  func testMoveNotReturnedAsDeletion() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].deletions([["a", "d"], ["c", "b"]])
      ==
      [PathIndexed<String>]()
    )
  }
  
  func testDeletionsNested() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].deletions([["a", "d"], ["b"]])
      ==
      [
        PathIndexed(
          element: "c",
          index: IndexPath(
            row: 0,
            section: 1
          )
        )
      ]
    )
  }
  
  func testDeletionsNestedNone() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].deletions([["a", "d"], ["c", "b"]])
      ==
      [PathIndexed<String>]()
    )
  }
  
  func testAdditions() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].additions([["a", "d"], ["c", "b", "e"]])
      ==
      [
        PathIndexed(
          element: "e",
          index: IndexPath(
            row: 2,
            section: 1
          )
        )
      ]
    )
  }
  
  func testNestedAdditionsNone() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].additions([["a", "d"], ["c", "b"]])
      ==
      [PathIndexed<String>]()
    )
  }
  
  func testNestedUpdatesNone() {
    XCTAssert(
      [[Updateable(value: "a", state: true)]].updates([[Updateable(value: "a", state: true)]])
      ==
      []
    )
  }
  
  func testNestedUpdatesSome() {
    XCTAssert(
      [[Updateable(value: "a", state: true)]].updates([[Updateable(value: "a", state: false)]])
      ==
      [
        PathIndexed(
          element: Updateable(value: "a", state: false),
          index: IndexPath(
            row:0,
            section: 0
          )
        )
      ]
    )
  }
}

struct Updateable {
  let value: String
  let state: Bool
}

extension Updateable: Granularelatable {
  func equality(_ input: Updateable) -> GranulatedEquality {
    if value == input.value && state != input.state { return
      .partial
    } else if value == input.value && state == input.state { return
      .complete
    } else { return
      .none
    }
  }
}

extension Updateable: Hashable {
  var hashValue: Int { return
    value.hash
  }
}

extension Updateable: Equatable {
  public static func ==(left: Updateable, right: Updateable) -> Bool { return
    left.value == right.value &&
    left.state == right.state
  }
}

extension String: Granularelatable {
  public func equality(_ input: String) -> GranulatedEquality { return
    self == input ? .complete : .none
  }
}
