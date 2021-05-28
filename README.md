# AveCommonHelperViews
Commonly used helpers views for UIKit (ShapeView, GradientView, ContentTextView, RoundRectView, CircleView, FixedSizeView)

## What?

This is a small collection of commonly used UIView subclasses. For example, `GradientView` wraps `CAGradientLayer` and works with dynamic `UIColor`s as well as **UIView-based-animations**.


## ContentTextView

A small `UITextView` subclass that disallows selecting text and scrolling, but does allow interacting with links. This is useful if you want to show complex text with embedded links, but do not want text selection.


## GradientView

A view that wraps `CAGradientLayer`, supports dynamic `UIColor`s and **UIView-based-animations**.

Common helpers are:

- `setVerticalLinearGradient()`
- `setHorizontalLinearGradient()`
- `setVerticalLinearFadeOut()`
- `setHorizontalLinearFadeOut()`
- `setVerticalLinearFadeIn()`
- `setHorizontalLinearFadeIn()`
- `setColors(_:, locations: startPoint: endPoint: type:)`
	
Each of those also have equivalent `init` methods:

- `init(verticallyFrom:to:)`
- `init(horizontallyFrom:to:)`
- `init(verticallyFadingOutFrom:)`
- `init(verticallyFadingInTo:)`
- `init(horizontallyFadingOutFrom:)`
- `init(horizontallyFadingInTo:)`
- `init(colors: locations:startPoint:endPoint:type)`
	
Example:
```
let fadeOutView = GradientView(verticallyFadingOutFrom: .white)
addSuview(fadeOutView)
```


## RoundRectView

A view that provides easy access to `cornerRadius`, `borderWidth` and `borderColor`. Supports dynamic `UIColor` and **UIView-based-animations**.

Example:
```
let roundRectView = RoundRectView(cornerRadius: 12, borderWidth: 1, borderColor: .separator, clipsToBounds: true)
```

## ShapeView

A view that wraps `CAShapeLayer`. Supports dynamic `UIColor` and **UIView-based-animations**.

Example:
```
let shapeView = ShapeView()
shapeView.fillColor = .red
shapeView.path = UIBezierPath(ovalIn: CGRect(x:0, y: 0, width: 100, height: 100))
```

## CircleView

A view which has constraints to always be a circle and adjusts it's cornerRadius to be so. Size can be set thru `fixedSize`, which is animatable.

Example:
```
let circleView = CircleView(size: 44, backgroundColor: .red, clipsToBounds: true)

let otherCircle = CircleView(size: 20, backgroundColor: .red)
```

## FixedSizeView

A view that has constraints set up so it's always a fixedSize, fixedWidth or fixedHeight. The size can easily be changed using a parameter and size changes can force layout of the superview.

This view is useful when you have a fixed and possibly dynamically changing fixed size: you don't need to keep track of the constraints.

Example:
```
let view = FixedSizedView(width: 100, automaticallyLayoutSuperviewOnChange: .whenInAnimationBlock)
view.fixedWidth = 200

let otherView = FixedSizedView(size: CGSize(width: 100, height: 200))
otherView.fixedHeight = 30
```
