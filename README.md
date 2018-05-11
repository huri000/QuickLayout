# QuickLayout
[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/QuickLayout.svg?style=flat-square)](http://cocoapods.org/pods/QuickLayout)
![](https://travis-ci.org/huri000/QuickLayout.svg?branch=master)
[![codecov](https://codecov.io/gh/huri000/QuickLayout/branch/master/graph/badge.svg)](https://codecov.io/gh/huri000/QuickLayout)
[![License](https://img.shields.io/cocoapods/l/QuickLayout.svg?style=flat-square)](http://cocoapods.org/pods/QuickLayout)
[![Total Downloads](https://img.shields.io/cocoapods/dt/QuickLayout.svg?style=social)](https://cocoapods.org/pods/QuickLayout)

## Overview

QuickLayout offers an additional way, to easily assign and manage the layout constraints with code.
You can harness the power of QuickLayout to align your interface programmatically without even creating constraint explicitly.

### Benefits
- QuickLayout  drastically shortens the amount of code in case you ever need to write your view hierarchy programmatically.  
- The QuickLayout method declarations are very descriptive.
- Layout a UIView using the view itself, without even creating a single NSLayoutConstraint object.

### Features
- Extension to `UIView` that contains functionality that allows you to set constraints directly from the view itself.
- Extension to `Array of UIView` that contains functionality that allows you to set constraints directly from an array of views.

## Example Project
The example project (xib/storyboard free) demonstrates the benefits of using QuickLayout with several use cases:

Table View | Scroll View | Vertigo (Artistic Demonstration)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- Swift 4.0 or any higher version.

## Usage

### Layout to Superview

You can easily layout a view directly to its superview as long as it has one.

```Swift
// Create a view, add it to view hierarchy, and customize it
let simpleView = UIView()
simpleView.backgroundColor = .gray
parentView.addSubview(simpleView)
```

#### Constant edge

Easily set a constant edge to a view

```Swift
simpleView.set(.height, of: 50)
```

You can set multiple constant edges likewise:

```Swift
// edges is a variadic parameter 
simpleView.set(.width, .height, of: 100)
```

#### Top to superview

Easily layout the top of a view to the top of the parent

```Swift
simpleView.layoutToSuperview(.top)
```

#### Center x to superview

You can center a view horizontally in its superview

```Swift    
simpleView.layoutToSuperview(.centerX)
```

#### 80% out of superview width

You can layout a view to 80% its superview's width

```Swift    
simpleView.layoutToSuperview(.width, ratio: 0.8)
```

All QuickLayout methods return the applied constraints, but the returned values are discardable so you can simply ignore them if you don't need them.

```Swift    
let topConstraint = simpleView.layoutToSuperview(.top, offset: 10)

// Change the offset value by subtracting 10pts from it
topConstraint.constant -= 10
```

#### Center in superview

```Swift    
let center = simpleView.centerInSuperview()
```

You can optionally retreive the returned `QLCenterConstraints` instance.

```Swift
center?.y.constant = 20
```

#### Size to superview

Size to superview with optional ratio - It means that `simpleView` is 80% its superview size. 
```Swift    
let size = simpleView.sizeToSuperview(withRatio: 0.8)
```

You can optionally retreive the returned `QLSizeConstraints`  instance.

```Swift    
size?.width.constant = -20
```

#### Fill superview

```Swift    
let fillConstraints = simpleView.fillSuperview()
```

You can optionally retreive the returned `QLFillConstraints`  instance.

```Swift
fillConstraints?.center.y.constant = 5
```

#### Layout to axis:

You can layout view to a certain axis, for example:

Horizontally:

```Swift
simpleView.layoutToSuperview(axis: .horizontally)
```

Vertically:

```Swift
simpleView.layoutToSuperview(axis: .vertically)
```

You can reteive the `QLAxisConstraints` instance as well.

#### Customization

You can layout view to multiple superview edges, likewise:

```Swift
simpleView.layoutToSuperview(.leading, .trailing, .top, .bottom)
```

Or: 

```Swift
simpleView.layoutToSuperview(.centerX, .centerY)
```

### Layout to View

It is possible to layout one view to another inside the view hierarchy.

#### Layout edge-x to edge-y of another view

You can layout an edge of a view to another. For example: 

Layout `simpleView`'s `left` edge to the `right` edge of  `anotherView`, with `20pts right offset`.

```Swift
simpleView.layout(.left, to: .right, of: anotherView, offset: 20)
```

#### Sugar coat I: edge-x to edge-x of another view

Layout `simpleView`'s `top` edge to the `top` edge of  `anotherView`

```Swift
simpleView.layout(to: .top, of: anotherView)
```

####  Sugar coat II: multiple edges

Layout `simpleView`'s left, right and centerY to `anotherView`'s left, right and centerY, respectively.

```Swift
simpleView.layout(.left, .right, .centerY, to: anotherView)
```

### Array of UIView

You can generate an array of views and apply constraints on them all in one shot.

```Swift
// Create array of views and customize it
var viewsArray: [UIView] = []
for _ in 0...4 {
    let simpleView = UIView()
    view.addSubview(simpleView)
    viewsArray.append(simpleView)
}
```

#### Set constant edge

Each element gets height of 50pts, using this single line of code.

```Swift
viewsArray.set(.height, of: 50)
```


#### Layout to axis:

Each element cling to left and right of its superview.

```Swift
viewsArray.layoutToSuperview(axis: .horizontally, offset: 30)
```

#### Layout multiple edges

Each element left, right, top, bottom edges is exactly fits another view.

```Swift
viewsArray.layout(.left, .right, .top, .bottom, to: parentView)
```

#### Spread views

You can spread the elements one below the other (vertically), the first stretches to the top of the superview and the last stretchs to the bottom of the superview. There is an offset of 1pt between each element. 

```Swift
viewsArray.spread(.vertically, stretchEdgesToSuperview: true, offset: 1)
```

### Others

All of QuickLayout methods are fully documented and very descriptive in naming.
Every layout method has several optional parameters - see below:

####  Priority

- The priority of the applied constraint. 
- Included by all the layout methods.
- Default value: `.required`.

Other than the default system priorities,  QuickLayout offers one more - it has 999 value and it's called  `.must`.

You can tweak the priorities as you like in order to deal with breakage and redundancies.

Example for setting the constraints priority:

```Swift
let width = simpleView.set(.width, of: 100, priority: .must)
```

#### Relation

- The relation of a view to another view. 
- Included by most of the layout methods.
- Default value: `.equal`

#### Ratio

- The ratio of a view to another view. 
- Included by most of the layout methods.
- Default value: 1.0

## Installation
    
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate QuickLayout into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SwiftEntryKit', '1.0.14'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage


#### Manually

Add the source files into your project.

## Contributing

Forks, patches and other feedback are welcome.

## Author

Daniel Huri (huri000@gmail.com)

## License

QuickLayout is available under the MIT license. See the LICENSE file for more info.
