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

	/// the corner radius we want. Set to `RoundRectView.alwaysVerticalCircleCorners`
	/// to make the corners always form a vertical circle
	open var cornerRadius: CGFloat = 0 {
		didSet {
			updateCornerRadius()
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

	/// the corners that will be shown
	open var maskedCorners: CACornerMask {
		get {layer.maskedCorners}
		set {layer.maskedCorners = newValue}
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
	}

	// MARK: - Privates
	private func updateBorderColor() {
		layer.borderColor = borderColor?.resolvedColor(with: traitCollection).cgColor
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
