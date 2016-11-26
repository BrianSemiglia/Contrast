# Contrast
A library for finding differences (insetions/deletions/moves/updates) in 2-dimensional sets. Not exactly performant and still a work in progress.

## Usage
Items in set must conform to ```Granularelatable```.

```swift
struct Example {
  let value: String
  let state: Bool
}

extension Example: Granularelatable {
  func equality(_ input: Example) -> GranulatedEquality {
    if value == input.value && state != input.state { return
      .partial
    } else if value == input.value && state == input.state { return
      .complete
    } else { return
      .none
    }
  }
}
```

## Examples

Indexed Shifts
```swift
["a", "b", "c"].shifts(["b", "a", "d"]) 
==
[
  Shifted(element: "a", origin: 0, destination: 1),
  Shifted(element: "b", origin: 1, destination: 0)
]
```

Indexed Deletions
```swift
["a", "b", "c"].deletions(["b", "a", "d"]) 
== 
[
  Indexed(element: "c", index: 2)
]
```

Indexed Additions
```swift
["a", "b", "c"].additions(["b", "a", "d"]) 
==
[
  Indexed(element: "c", index: 2)
]
```
Indexed Updates
```swift
[
  Example(value: "a", state: true), 
  Example(value: "b", state: true)
].updates([
  Example(value: "a", state: true),
  Example(value: "b", state: false)
])
==
[
  Indexed(
    element: Example(value: "b", state: false),
    index: 1
  )
]
```

Index-Pathed Shifts
```swift
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
