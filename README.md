# QuickLayout

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

QuickLayout contains a simple extension of UIView (UIView+QuickLayout), that abstracts and simplifies the usage of Auto Layout.

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Swift4.0 and iOS 9.0 (At least).

## Contributing
Forks, patches and other feedback are welcome.

## Installation

## Usage

Simple example:

    // Inside your ViewController Create UIView and add it to view hierarchy
    let simpleView = UIView()
    simpleView.backgroundColor = .gray
    view.addSubview(simpleView)
    
    // Set constant height for simpleView
    simpleView.setConstant(edge: .height, value: 50)
    
    // Make simpleView cling to its superview's top
    simpleView.layoutToSuperview(.top)
    
    // Make simpleView cling to its superview's centerX
    simpleView.layoutToSuperview(.centerX)
    
    // Make simpleView cling to its superview's width
    simpleView.layoutToSuperview(.width, multiplier: 0.8)

Example for retrieving back constraint after setting it (Method's result is discardable, but you can access the constraint value after using invoking it)

    let constraint = simpleView.layoutToSuperview(.centerX)

Center view in superview:

    simpleView.centerInSuperview()

Size to superview: 

    simpleView.sizeToSuperview()
    
Totally fill superview:

    simpleView.fillSuperview()
    
You can layout view in relation to another view, and optionally set constant distance between them:

    simpleView.layout(.left, to: .right, of: anotherView, constant: 20)

#### CocoaPods
```
pod 'QuickLayout', :git => 'https://github.com/huri000/QuickLayout'
```

#### Manually
Add the `UIView+QuickLayout.swift` file to your project.

## Author
Daniel Huri (huri000@gmail.com)

## License

QuickLayout is available under the MIT license. See the LICENSE file for more info.
