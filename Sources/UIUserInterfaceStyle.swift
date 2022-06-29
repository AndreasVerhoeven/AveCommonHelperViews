//
//  UIUserInterfaceStyle.swift
//  Demo
//
//  Created by Andreas Verhoeven on 29/06/2022.
//

import UIKit

public extension UIUserInterfaceStyle {
	/// Returns an interface style that is reversed: (light, unspecified, unknown) becomes dark, dark becomes light
	func reversed() -> UIUserInterfaceStyle {
		switch self {
			case .unspecified: return .dark
			case .light: return .dark
			case .dark: return .light
			@unknown default: return .dark
		}
	}
	
	/// Returns true if this interface style is dark
	var isDark: Bool {
		switch self {
			case .dark:	return true
			case .light, .unspecified:
				fallthrough
			@unknown default:
				return false
		}
	}
	
	/// Returns true if this interface style is light or unspecified
	var isLight: Bool {
		switch self {
			case .dark:	return false
			case .light, .unspecified:
				fallthrough
			@unknown default:
				return true
		}
	}
}
