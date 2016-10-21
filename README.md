# Contrast

[![CI Status](http://img.shields.io/travis/Brian Semiglia/Contrast.svg?style=flat)](https://travis-ci.org/Brian Semiglia/Contrast)
[![Version](https://img.shields.io/cocoapods/v/Contrast.svg?style=flat)](http://cocoapods.org/pods/Contrast)
[![License](https://img.shields.io/cocoapods/l/Contrast.svg?style=flat)](http://cocoapods.org/pods/Contrast)
[![Platform](https://img.shields.io/cocoapods/p/Contrast.svg?style=flat)](http://cocoapods.org/pods/Contrast)

## Examples

Index Shifts
```
["a", "b", "c"].shifts(["b", "a", "d"]) ==
[
  Shift(element: "a", origin: 0, destination: 1),
  Shift(element: "b", origin: 1, destination: 0)
]
```

Index Deletions
```
["a", "b", "c"].deletions(["b", "a", "d"]) == 
[
  Indexed(element: "c", index: 2)
]
```

Index Additions
```
["a", "b", "c"].additions(["b", "a", "d"]) ==
[
  Indexed(element: "c", index: 2)
]
```

Index Path Shifts
```
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
