# Contrast
A library for finding differences in 2-dimensional sets.

## Examples

Index Shifts
```swift
["a", "b", "c"].shifts(["b", "a", "d"]) ==
[
  Shift(element: "a", origin: 0, destination: 1),
  Shift(element: "b", origin: 1, destination: 0)
]
```

Index Deletions
```swift
["a", "b", "c"].deletions(["b", "a", "d"]) == 
[
  Indexed(element: "c", index: 2)
]
```

Index Additions
```swift
["a", "b", "c"].additions(["b", "a", "d"]) ==
[
  Indexed(element: "c", index: 2)
]
```

Index Path Shifts
```swift
[["a", "b"], ["c", "d"]].shifts([["a", "d"], ["c", "b"]]) ==
[
  PathShift(
    element: "b",
    origin: IndexPath(row: 1, section: 0),
    destination: IndexPath(row: 1, section: 1)
  ),
  PathShift(
    element: "d",
    origin: IndexPath(row: 1, section: 1),
    destination: IndexPath(row: 1, section: 0)
  )
]
```

## Requirements

iOS 8.0+, 
Swift 3.0

## Installation

Contrast is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "Contrast"
```

## License

Contrast is available under the MIT license. See the LICENSE file for more info.
