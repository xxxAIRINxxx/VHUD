# VHUD

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 8.0+](https://img.shields.io/badge/Xcode-8.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Simple HUD.

![Capture](Images/capture.jpg)

VHUD is inspired by [PKHUD](https://github.com/pkluz/PKHUD).

## Example

### Show

```swift

import VHUD

func example() {
  var content = VHUDContent(.loop(3.0))
  content.loadingText = "Loading.."
  content.completionText = "Finish!"

  VHUD.show(content)
}

```

### Dismiss

```swift

// duration, deley(Option), text(Option), completion(Option)
VHUD.dismiss(1.0, 1.0)

```

## Mode

- Loop
- Duration
- PercentComplete

## Customization

### Shape

- circle

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
VHUD.show(content)

```

![Capture](Images/circle.jpg)

- round

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .round
VHUD.show(content)

```

![Capture](Images/round.jpg)

And Custom (using closure)

### Style

- light

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
content.style = .light
VHUD.show(content)

```

![Capture](Images/light.jpg)

- dark

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
content.style = .dark
VHUD.show(content)

```

![Capture](Images/dark.jpg)

- blur

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
content.style = .blur(.light)
VHUD.show(content)

```

![Capture](Images/blur.jpg)

### Background

- none

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
content.style = .blur(.light)
content.background = .none
VHUD.show(content)

```

![Capture](Images/bg_none.jpg)

- color

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
content.style = .dark
content.background = .color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0.7))
VHUD.show(content)

```

![Capture](Images/bg_color.jpg)

- blur

```swift

var content = VHUDContent(.loop(3.0))
content.shape = .circle
content.style = .light
content.background = .blur(.dark)
VHUD.show(content)

```

![Capture](Images/bg_blur.jpg)

## Requirements

* iOS 8.0+
* Swift 3.0
* Xcode 8.0+

## Installation

#### CocoaPods

You can use [CocoaPods](http://cocoapods.org/) to install `VHUD` by adding it to your `Podfile`:

```ruby

use_frameworks!
pod 'VHUD'

```

To get the full benefits import `VHUD` wherever you import UIKit

``` swift

import UIKit
import VHUD

```
#### Manually

1. Download and drop ```/Sources``` folder in your project.  
2. Congratulations!  

## License

MIT license. See the LICENSE file for more info.
