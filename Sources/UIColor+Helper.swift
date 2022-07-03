//
//  UIColor+Helper.swift
//  Demo
//
//  Created by Andreas Verhoeven on 29/06/2022.
//

import UIKit

public extension UIColor {
	/// Returns this color with a dynamic provider that gets the original color and the trait collection
	func withDynamicProvider(_ provider: @escaping (UIColor, UITraitCollection) -> UIColor) -> UIColor {
		return UIColor(dynamicProvider: { provider(self, $0)  })
	}
	
	/// Returns this color with a given interface style forced
	func withInterfaceStyle(_ interfaceStyle: UIUserInterfaceStyle) -> UIColor {
		withDynamicProvider { color, traitCollection -> UIColor in
			let newTraits = UITraitCollection(traitsFrom: [traitCollection, UITraitCollection(userInterfaceStyle: interfaceStyle)])
			return color.resolvedColor(with: newTraits)
		}
	}
	
	/// Returns this color, but with the interface style reversed: dark becomes the light color and vice versa
	var interfaceStyleInverted: UIColor {
		withDynamicProvider { color, traitCollection -> UIColor in
			let interfaceStyle = traitCollection.userInterfaceStyle.inverted
			let newTraits = UITraitCollection(traitsFrom: [traitCollection, UITraitCollection(userInterfaceStyle: interfaceStyle)])
			return color.resolvedColor(with: newTraits)
		}
	}
	
	/// Returns the dark variant of this color
	var alwaysDark: UIColor { withInterfaceStyle(.dark) }
	
	/// Returns the light variant of this color
	var alwaysLight: UIColor { withInterfaceStyle(.light) }
	
	/// Blends this color with another color in a simple way. Works with trait collections.
	func blended(with other: UIColor) -> UIColor {
		func blended(first: UIColor, second: UIColor) -> UIColor {
			var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
			first.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
			
			var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
			second.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
			
			let outA = a1 + a2 * (1 - a1)
			guard outA > 0 else { return UIColor(white: 0, alpha: 0) }
			
			let outR = (r1 * a1 + r2 * a2 * (1 - a1)) / outA
			let outG = (g1 * a1 + g2 * a2 * (1 - a1)) / outA
			let outB = (b1 * a1 + b2 * a2 * (1 - a1)) / outA
			return UIColor(red: outR, green: outG, blue: outB, alpha: outA)
		}
		
		if #available(iOS 13, *) {
			return withDynamicProvider { color, traitCollection in
				blended(first: color.resolvedColor(with: traitCollection), second: other.resolvedColor(with: traitCollection))
			}
		} else {
			return blended(first: self, second: other)
		}
	}
}
