//
//  GradientView.swift
//  CommonViews
//
//  Created by Andreas Verhoeven on 13/05/2021.
//

import UIKit

/// A View that wraps CGradientLayer
open class GradientView: UIView {

	/// the colors for this gradient
	open var colors = [UIColor]() {
		didSet {
			updateColors()
		}
	}

	/// the stops in the gradient
	open var locations = [CGFloat]() {
		didSet {
			gradientLayer.locations = locations.isEmpty ? nil : locations.map { $0 as NSNumber }
		}
	}

	/// the type of gradient
	open var type: CAGradientLayerType {
		get { gradientLayer.type }
		set { gradientLayer.type = newValue }
	}

	/// the start point of the gradient
	open var startPoint: CGPoint {
		get { gradientLayer.startPoint }
		set { gradientLayer.startPoint = newValue }
	}

	/// the end point of the gradient
	open var endPoint: CGPoint {
		get { gradientLayer.endPoint }
		set { gradientLayer.endPoint = newValue }
	}

	/// the gradient layer for this view
	open var gradientLayer: CAGradientLayer {
		return layer as! CAGradientLayer
	}


	/// Sets the properties to a vertical linear gradient
	///
	/// - Parameters:
	/// 	- from: the top color
	/// 	- to: the bottom color
	/// 	- start: **optional** the y axis start point of the gradient
	/// 	- end: **optional** the y axis end point of the gradient
	open func setVerticalLinearGradient(from: UIColor, to: UIColor, start: CGFloat = 0, end: CGFloat = 1) {
		self.colors = [from, to]
		self.startPoint = CGPoint(x: 0, y: start)
		self.endPoint = CGPoint(x: 0, y: end)
		self.type = .axial
	}

	/// Sets the properties to a vertical linear gradient
	///
	/// - Parameters:
	/// 	- from: the top color
	/// 	- to: the bottom color
	/// 	- start: **optional** the x axis start point of the gradient
	/// 	- end: **optional** the x axis start point of the gradient
	open func setHorizontalLinearGradient(from: UIColor, to: UIColor, start: CGFloat = 0, end: CGFloat = 1) {
		self.colors = [from, to]
		self.startPoint = CGPoint(x: start, y: 0)
		self.endPoint = CGPoint(x: end, y: 0)
		self.type = .axial
	}

	/// Sets the properties to be a vertical linear fade out
	///
	/// - Parameters:
	///		- from: the color to fade out from
	open func setVerticalLinearFadeOut(from: UIColor) {
		setVerticalLinearGradient(from: from, to: from.withAlphaComponent(0))
	}

	/// Sets the properties to be a horizontal linear fade out
	///
	/// - Parameters:
	///		- from: the color to fade out from
	open func setHorizontalLinearFadeOut(from: UIColor) {
		setHorizontalLinearGradient(from: from, to: from.withAlphaComponent(0))
	}

	/// Sets the properties to be a vertical linear fade in
	///
	/// - Parameters:
	///		- to: the color to fade in from
	open func setVerticalLinearFadeIn(to: UIColor) {
		setVerticalLinearGradient(from: to.withAlphaComponent(0), to: to)
	}

	/// Sets the properties to be a horizontal linear fade in
	///
	/// - Parameters:
	///		- to: the color to fade in from
	open func setHorizontalLinearFadeIn(to: UIColor) {
		setHorizontalLinearGradient(from: to.withAlphaComponent(0), to: to)
	}

	/// Sets multiple properties
	///
	/// - Parameters:
	/// 	- colors: the colors of the gradient
	/// 	- locations: the color stops
	/// 	- startPoint: the start point of the gradient
	/// 	- endPoint: the end point of the gradient
	///		- type: **optional** the type of gradient, defaults to `.axial`
	open func setColors(_ colors: [UIColor], locations: [CGFloat] = [], startPoint: CGPoint, endPoint: CGPoint, type: CAGradientLayerType = .axial) {
		self.colors = colors
		self.locations = locations
		self.startPoint = startPoint
		self.endPoint = endPoint
		self.type = type
	}

	/// Creates a vertical linear gradient
	///
	/// - Parameters:
	/// 	- from: the top color
	/// 	- to: the bottom color
	/// 	- start: **optional** the y axis start point of the gradient
	/// 	- end: **optional** the y axis end point of the gradient
	public convenience init(verticallyFrom from: UIColor, to: UIColor, start: CGFloat = 0, end: CGFloat = 1) {
		self.init()
		setVerticalLinearGradient(from: from, to: to, start: start, end: end)
		updateColors()
	}

	/// Creates a vertical gradient that fades out
	///
	/// - Parameters:
	///		- from: the color to fade out from
	public convenience init(verticallyFadingOutFrom from: UIColor) {
		self.init()
		setVerticalLinearFadeOut(from: from)
		updateColors()
	}

	/// Creates a vertical gradient that fades in
	///
	/// - Parameters:
	///		- to: the color to fade in to
	public convenience init(verticallyFadingInTo to: UIColor) {
		self.init()
		setVerticalLinearFadeIn(to: to)
		updateColors()
	}

	/// Creates a horizontal gradient
	///
	/// - Parameters:
	/// 	- from: the top color
	/// 	- to: the bottom color
	/// 	- start: **optional** the x axis start point of the gradient
	/// 	- end: **optional** the x axis end point of the gradient
	public convenience init(horizontallyFrom from: UIColor, to: UIColor, start: CGFloat = 0, end: CGFloat = 1) {
		self.init()
		setHorizontalLinearGradient(from: from, to: to, start: start, end: end)
		updateColors()
	}

	/// Creates a horizontal gradient that fades out
	///
	/// - Parameters:
	///		- from: the color to fade out from
	public convenience init(horizontallyFadingOutFrom from: UIColor) {
		self.init()
		setHorizontalLinearFadeOut(from: from)
		updateColors()
	}

	/// Creates a horizontal gradient that fades in
	///
	/// - Parameters:
	///		- from: the color to fade out from
	public convenience init(horizontallyFadingInTo to: UIColor) {
		self.init()
		setHorizontalLinearFadeIn(to: to)
		updateColors()
	}

	/// Creates a gradient
	///
	/// - Parameters:
	/// 	- colors: the colors of the gradient
	/// 	- locations: the color stops
	/// 	- startPoint: the start point of the gradient
	/// 	- endPoint: the end point of the gradient
	///		- type: **optional** the type of gradient, defaults to `.axial`
	public convenience init(colors: [UIColor], locations: [CGFloat] = [], startPoint: CGPoint, endPoint: CGPoint, type: CAGradientLayerType = .axial) {
		self.init()
		setColors(colors, locations: locations, startPoint: startPoint, endPoint: endPoint, type: type)
		updateColors()
	}

	// MARK: - private
	private func updateColors() {
		let traitCollection = self.traitCollection
		traitCollection.performAsCurrent {
			gradientLayer.colors = colors.map { $0.resolvedColor(with: traitCollection).cgColor }
		}
	}

	// MARK: - UIView
	override open class var layerClass: AnyClass {
		return CAGradientLayer.self
	}

	override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateColors()
	}

	// MARK: - CALayerDelegate

	override open func action(for layer: CALayer, forKey key: String) -> CAAction? {
		if key == "colors" || key == "locations" || key == "startPoint" || key == "endPoint" || key == "type" {
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
}
