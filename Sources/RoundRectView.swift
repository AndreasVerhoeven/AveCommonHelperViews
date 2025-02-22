//
//  RoundRectView.swift
//  CommonViews
//
//  Created by Andreas Verhoeven on 13/05/2021.
//

import UIKit

/// A view that is a rounded rectangle
open class RoundRectView: UIView {

	/// value used to signal that we always want circle corners
	public static let alwaysVerticalCircleCorners = CGFloat(-1)

	/// This is equivalent to `CACornerMask`, except that they follow the layout direction
	/// properly. You resolve to a `CACornerMask` using the `caCornerMask(for:)` method,
	/// where you give it a layout direction.
	public struct DirectionalCornerMask: RawRepresentable, OptionSet {
		public var rawValue: Int

		public init(rawValue: Int) {
			self.rawValue = rawValue
		}

		// dont show any corners
		public static let none = Self(rawValue: 1 << 0)

		/// the corners to show
		public static let topLeading = Self(rawValue: 1 << 1)
		public static let topTrailing = Self(rawValue: 1 << 2)
		public static let bottomLeading = Self(rawValue: 1 << 3)
		public static let bottomTrailing = Self(rawValue: 1 << 4)

		// helpers
		public static let all: Self = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing]
		public static let bottom: Self = [.bottomLeading, .bottomTrailing]
		public static let top: Self = [.topLeading, .topTrailing]
		public static let leading: Self = [.topLeading, .bottomLeading]
		public static let trailing: Self = [.topTrailing, .bottomTrailing]

		/// shows all corners except one
		public static func except(_ item: Self) -> Self {
			return Self.all.subtracting(item)
		}

		/// creates a DirectionalCornerMask from a `CACornerMask` and a `layoutDirection`
		public init(from caCornerMask: CACornerMask, layoutDirection: UIUserInterfaceLayoutDirection) {
			var mask: Self = []

			switch layoutDirection {
				case .rightToLeft:
					if caCornerMask.contains(.layerMaxXMinYCorner) == true { mask.insert(.topLeading) }
					if caCornerMask.contains(.layerMinXMinYCorner) == true { mask.insert(.topTrailing) }
					if caCornerMask.contains(.layerMaxXMaxYCorner) == true { mask.insert(.bottomLeading) }
					if caCornerMask.contains(.layerMinXMaxYCorner) == true { mask.insert(.bottomTrailing) }

				case .leftToRight:
					fallthrough
				@unknown default:
					if caCornerMask.contains(.layerMaxXMinYCorner) == true { mask.insert(.topTrailing) }
					if caCornerMask.contains(.layerMinXMinYCorner) == true { mask.insert(.topLeading) }
					if caCornerMask.contains(.layerMaxXMaxYCorner) == true { mask.insert(.bottomTrailing) }
					if caCornerMask.contains(.layerMinXMaxYCorner) == true { mask.insert(.bottomLeading) }
			}

			self = mask
		}

		/// Creates a (non directional) CACornerMask for a given `layoutDirection`
		public func caCornerMask(for layoutDirection: UIUserInterfaceLayoutDirection) -> CACornerMask {
			var newMaskedCorners: CACornerMask = []
			switch layoutDirection {
				case .rightToLeft:
					if contains(.topLeading) == true { newMaskedCorners.insert(.layerMaxXMinYCorner) }
					if contains(.topTrailing) == true { newMaskedCorners.insert(.layerMinXMinYCorner) }
					if contains(.bottomLeading) == true { newMaskedCorners.insert(.layerMaxXMaxYCorner) }
					if contains(.bottomTrailing) == true { newMaskedCorners.insert(.layerMinXMaxYCorner) }

				case .leftToRight:
					fallthrough
				@unknown default:
					if contains(.topLeading) == true { newMaskedCorners.insert(.layerMinXMinYCorner) }
					if contains(.topTrailing) == true { newMaskedCorners.insert(.layerMaxXMinYCorner) }
					if contains(.bottomLeading) == true { newMaskedCorners.insert(.layerMinXMaxYCorner) }
					if contains(.bottomTrailing) == true { newMaskedCorners.insert(.layerMaxXMaxYCorner) }
			}

			return newMaskedCorners
		}
	}

	/// the corner radius we want. Set to `RoundRectView.alwaysVerticalCircleCorners`
	/// to make the corners always form a vertical circle
	open var cornerRadius: CGFloat = 0 {
		didSet {
			updateCornerRadius()
		}
	}

	/// this is equivalent to `maskedCorners`, except that it follows the `effectiveUserInterfaceLayoutDirection`.
	/// Setting this will override the `maskedCorners` value.
	open var directionalMaskedCorners: DirectionalCornerMask = .all {
		didSet {
			isUsingDirectionalCornerMask = true
			updateMaskedCorners()
		}
	}

	/// the corners that will be shown - setting this will override
	/// any value that was set for `directionalCornerMask`/
	open var maskedCorners: CACornerMask {
		get {
			layer.maskedCorners
		}
		set {
			isUsingDirectionalCornerMask = false
			layer.maskedCorners = newValue
			updateMaskedCorners()
		}
	}

	/// the border width
	open var borderWidth: CGFloat {
		get {layer.borderWidth}
		set {layer.borderWidth = newValue}
	}

	/// true if we want smooth continuous corners
	open var cornerIsContinuous: Bool {
		get {layer.cornerCurve == .continuous}
		set {layer.cornerCurve = newValue ? .continuous : .circular}
	}

	// the border color
	open var borderColor: UIColor? {
		didSet {
			updateBorderColor()
		}
	}

	/// Creates a new RoundRectView
	///
	/// - Parameters:
	///		- cornerRadius: **optional** the corner radius to use, defaults to 0
	///		- cornerIsContinuous: **optional** true if we want smooth corners, defaults to false
	///		- borderWidth: **optional** the width of the border, defaults to 0
	///		- borderColor: **optional** the border color defaults to nil
	///		- backgroundColor: **optional** the background color, defaults to nil
	///		- maskedCorners: ** optional** the corners to mask, defaults to `.all`
	///		- clipsToBounds: **optional** if we should clip to the bounds, defaults to false
	public convenience init(cornerRadius: CGFloat = 0, cornerIsContinuous: Bool = false, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, backgroundColor: UIColor? = nil, maskedCorners: CACornerMask = .all, clipsToBounds: Bool = false) {
		self.init(frame:.zero)
		self.cornerRadius = cornerRadius
		self.cornerIsContinuous = cornerIsContinuous
		self.borderWidth = borderWidth
		self.borderColor = borderColor
		self.maskedCorners = maskedCorners
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds
		updateBorderColor()
		updateCornerRadius()
		updateMaskedCorners()
	}

	/// Creates a new RoundRectView
	///
	/// - Parameters:
	///		- cornerRadius: **optional** the corner radius to use, defaults to 0
	///		- cornerIsContinuous: **optional** true if we want smooth corners, defaults to false
	///		- borderWidth: **optional** the width of the border, defaults to 0
	///		- borderColor: **optional** the border color defaults to nil
	///		- backgroundColor: **optional** the background color, defaults to nil
	///		- directionalMaskedCorners: the directional corners to mask, follows the layout direction
	///		- clipsToBounds: **optional** if we should clip to the bounds, defaults to false
	public convenience init(cornerRadius: CGFloat = 0, cornerIsContinuous: Bool = false, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, backgroundColor: UIColor? = nil, directionalMaskedCorners: DirectionalCornerMask, clipsToBounds: Bool = false) {
		self.init(frame:.zero)
		self.cornerRadius = cornerRadius
		self.cornerIsContinuous = cornerIsContinuous
		self.borderWidth = borderWidth
		self.borderColor = borderColor
		self.directionalMaskedCorners = directionalMaskedCorners
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds

		isUsingDirectionalCornerMask = true
		updateBorderColor()
		updateCornerRadius()
		updateMaskedCorners()
	}

	// MARK: - Privates
	private var isUsingDirectionalCornerMask = false

	private func updateBorderColor() {
		layer.borderColor = borderColor?.resolvedColor(with: traitCollection).cgColor
	}

	private func updateMaskedCorners() {
		if isUsingDirectionalCornerMask == true {
			let maskedCorners = directionalMaskedCorners.caCornerMask(for: effectiveUserInterfaceLayoutDirection)
			if maskedCorners != layer.maskedCorners {
				layer.maskedCorners = maskedCorners
			}
		} else {
			directionalMaskedCorners = DirectionalCornerMask(from: layer.maskedCorners, layoutDirection: effectiveUserInterfaceLayoutDirection)
		}
	}

	private func updateCornerRadius() {
		if cornerRadius == Self.alwaysVerticalCircleCorners {
			layer.cornerRadius = bounds.height * 0.5

		} else {
			layer.cornerRadius = cornerRadius
		}
	}

	private func setup() {
		layer.cornerCurve = .continuous
	}

	// MARK: - UIView
	override open func layoutSubviews() {
		super.layoutSubviews()
		if cornerRadius == Self.alwaysVerticalCircleCorners {
			updateCornerRadius()
		}
	}

	override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateBorderColor()
		updateMaskedCorners()
	}

	// MARK: CALayerDelegate

	override open func action(for layer: CALayer, forKey key: String) -> CAAction? {
		if key == "borderColor" || key == "borderWidth" {
			if let animation = layer.action(forKey: "opacity") as? CABasicAnimation {
				animation.keyPath = key
				animation.fromValue = layer.value(forKey: key)
				animation.toValue = nil
				animation.byValue = nil
				return animation
			}
		}

		return super.action(for: layer, forKey: key)
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
}

public extension CACornerMask {
	static let all: CACornerMask = [.topLeft, .topRight, .bottomLeft, .bottomRight]
	static let none: CACornerMask = []
	static let top: CACornerMask = [.topLeft, .topRight]
	static let bottom: CACornerMask = [.bottomLeft, .bottomRight]
	static let left: CACornerMask = [.topLeft, .bottomLeft]
	static let right: CACornerMask = [.topRight, .bottomRight]
	
	static let topLeft = CACornerMask.layerMinXMinYCorner
	static let topRight = CACornerMask.layerMaxXMinYCorner
	static let bottomLeft = CACornerMask.layerMinXMaxYCorner
	static let bottomRight = CACornerMask.layerMaxXMaxYCorner
	
	static func except(_ item: CACornerMask) -> Self {
		return CACornerMask.all.subtracting(item)
	}
}
