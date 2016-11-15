import UIKit
import XCTest
import Contrast

class Tests: XCTestCase {

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
  
  func testShiftNoneReplaceAll() {
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
  
  func testDeletions() {
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
  
  func testDeletionsNone() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].deletions([["a", "d"], ["c", "b"]])
      ==
      [PathIndexed<String>]()
    )
  }
  
  func testFlattening() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].indexedFlattened()
      ==
      [
        PathIndexed(element: "a", index: IndexPath(row: 0, section: 0)),
        PathIndexed(element: "b", index: IndexPath(row: 1, section: 0)),
        PathIndexed(element: "c", index: IndexPath(row: 0, section: 1)),
        PathIndexed(element: "d", index: IndexPath(row: 1, section: 1))
      ]
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
  
  func testAdditionsNone() {
    XCTAssert(
      [["a", "b"], ["c", "d"]].additions([["a", "d"], ["c", "b"]])
      ==
      [PathIndexed<String>]()
    )
  }
    
}
