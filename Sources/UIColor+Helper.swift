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
	func withInterfaceStyleReversed() -> UIColor {
		withDynamicProvider { color, traitCollection -> UIColor in
			let interfaceStyle = traitCollection.userInterfaceStyle.reversed()
			let newTraits = UITraitCollection(traitsFrom: [traitCollection, UITraitCollection(userInterfaceStyle: interfaceStyle)])
			return color.resolvedColor(with: newTraits)
		}
	}
}
