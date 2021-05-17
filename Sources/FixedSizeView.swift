//
//  FixedSizeView.swift
//  Demo
//
//  Created by Andreas Verhoeven on 17/05/2021.
//

import UIKit

/// a view that optionally has an easily changeable fixed size
open class FixedSizeView: UIView {

	/// value to use if one of the dimensions should not be fixed
	public static let notFixed = CGFloat(-1)

	/// the size to fix this view to, if nil, nothing will be fixed. If width or height
	/// are `Self.notFixed`, those axis won't have a constraint.
	public var fixedSize: CGSize? {
		didSet {
			guard fixedSize != oldValue else { return }
			updateFixedSize()

			superview?.setNeedsLayout()
			if UIView.inheritedAnimationDuration > 0 {
				superview?.layoutIfNeeded()
			}
		}
	}


	/// Convenience helper for fixedSize.height
	public var fixedHeight: CGFloat? {
		get { fixedSize?.height }
		set {
			let newSize = CGSize(width: fixedWidth ?? Self.notFixed, height: newValue ?? Self.notFixed)
			if newSize.width == Self.notFixed && newSize.height == Self.notFixed {
				fixedSize = nil
			} else {
				fixedSize = newSize
			}
		}
	}

	/// Convenience helper for fixedSize.width
	public var fixedWidth: CGFloat? {
		get { fixedSize?.width }
		set {
			let newSize = CGSize(width: newValue ?? Self.notFixed, height: fixedHeight ?? Self.notFixed)
			if newSize.width == Self.notFixed && newSize.height == Self.notFixed {
				fixedSize = nil
			} else {
				fixedSize = newSize
			}
		}
	}

	/// Creates a view with a fixed size
	///
	/// - Parameters:
	///		- size: the size of the view
	///		- backgroundColor: **optional** the background color to set, defaults to nil
	///		- clipsToBounds: **optional** clips to bounds, defaults to false
	public convenience init(size: CGSize, backgroundColor: UIColor? = nil, clipsToBounds: Bool = false) {
		self.init()
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds
		fixedSize = size
		updateFixedSize()
	}

	// MARK: - Private
	private func updateFixedSize() {
		fixedWidthAnchor.constant = fixedSize?.width ?? 0
		fixedWidthAnchor.isActive = (fixedSize != nil && fixedSize?.width != Self.notFixed)

		fixedHeightAnchor.constant = fixedSize?.height ?? 0
		fixedHeightAnchor.isActive = (fixedSize != nil && fixedSize?.width != Self.notFixed)
	}

	private lazy var fixedWidthAnchor: NSLayoutConstraint = {
		let constraint = widthAnchor.constraint(equalToConstant: fixedSize?.width ?? 0)
		constraint.priority = .required
		return constraint
	}()

	private lazy var fixedHeightAnchor: NSLayoutConstraint = {
		let constraint = heightAnchor.constraint(equalToConstant: fixedSize?.height ?? 0)
		constraint.priority = .required
		return constraint
	}()
}
