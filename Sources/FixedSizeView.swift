//
//  FixedSizeView.swift
//  Demo
//
//  Created by Andreas Verhoeven on 17/05/2021.
//

import UIKit

/// a view that optionally has an easily changeable fixed size
open class FixedSizeView: UIView {

	public enum LayoutUpdateType {
		case never
		case always
		case whenInAnimationBlock
	}

	/// if set, we'll automatically perform layout in the super view if needed size changes
	open var automaticallyLayoutSuperviewOnChange = LayoutUpdateType.never

	/// value to use if one of the dimensions should not be fixed
	public static let notFixed = CGFloat(-1)

	/// the size to fix this view to, if nil, nothing will be fixed. If width or height
	/// are `Self.notFixed`, those axis won't have a constraint.
	public var fixedSize: CGSize? {
		didSet {
			guard fixedSize != oldValue else { return }
			updateFixedSize()

			switch automaticallyLayoutSuperviewOnChange {
				case .never:
					break

				case .always:
					superview?.setNeedsLayout()
					superview?.layoutIfNeeded()

				case .whenInAnimationBlock:
					superview?.setNeedsLayout()
					if UIView.inheritedAnimationDuration > 0 {
						superview?.layoutIfNeeded()
					}

			}
		}
	}


	/// Convenience helper for fixedSize.height
	open var fixedHeight: CGFloat? {
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
	open var fixedWidth: CGFloat? {
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
	///		- automaticallyLayoutSuperviewOnChange: **optional** if set, we'll automatically layoutIfNeeded() the superview when fixedSize changes
	///		- backgroundColor: **optional** the background color to set, defaults to nil
	///		- clipsToBounds: **optional** clips to bounds, defaults to false
	public convenience init(size: CGSize,
							automaticallyLayoutSuperviewOnChange: LayoutUpdateType = .never,
							backgroundColor: UIColor? = nil,
							clipsToBounds: Bool = false) {
		self.init()
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds
		self.automaticallyLayoutSuperviewOnChange = automaticallyLayoutSuperviewOnChange
		fixedSize = size
		updateFixedSize()
	}

	/// Creates a view with a fixed width
	///
	/// - Parameters:
	///		- width: the width of the view
	///		- automaticallyLayoutSuperviewOnChange: **optional** if set, we'll automatically layoutIfNeeded() the superview when fixedSize changes
	///		- backgroundColor: **optional** the background color to set, defaults to nil
	///		- clipsToBounds: **optional** clips to bounds, defaults to false
	public convenience init(width: CGFloat,
							automaticallyLayoutSuperviewOnChange: LayoutUpdateType = .never,
							backgroundColor: UIColor? = nil,
							clipsToBounds: Bool = false) {
		self.init()
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds
		self.automaticallyLayoutSuperviewOnChange = automaticallyLayoutSuperviewOnChange
		fixedWidth = width
		updateFixedSize()
	}

	/// Creates a view with a fixed height
	///
	/// - Parameters:
	///		- height: the height of the view
	///		- automaticallyLayoutSuperviewOnChange: **optional** if set, we'll automatically layoutIfNeeded() the superview when fixedSize changes
	///		- backgroundColor: **optional** the background color to set, defaults to nil
	///		- clipsToBounds: **optional** clips to bounds, defaults to false
	public convenience init(height: CGFloat,
							automaticallyLayoutSuperviewOnChange: LayoutUpdateType = .never,
							backgroundColor: UIColor? = nil,
							clipsToBounds: Bool = false) {
		self.init()
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds
		self.automaticallyLayoutSuperviewOnChange = automaticallyLayoutSuperviewOnChange
		fixedHeight = height
		updateFixedSize()
	}

	// MARK: - Private
	private func updateFixedSize() {
		fixedWidthAnchor.constant = fixedSize?.width ?? 0
		fixedWidthAnchor.isActive = (fixedSize != nil && fixedSize?.width != Self.notFixed)

		fixedHeightAnchor.constant = fixedSize?.height ?? 0
		fixedHeightAnchor.isActive = (fixedSize != nil && fixedSize?.height != Self.notFixed)
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
