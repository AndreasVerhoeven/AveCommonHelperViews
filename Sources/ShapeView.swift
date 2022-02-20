//
//  ShapeView.swift
//  Demo
//
//  Created by Andreas Verhoeven on 17/05/2021.
//

import UIKit

/// A view that wraps CAShapeLayer
open class ShapeView: UIView {

	public var path: UIBezierPath? {
		didSet {
			shapeLayer.path = path?.cgPath
		}
	}

	public var fillColor: UIColor? {
		didSet {
			updateColors()
		}
	}

	public var fillRule: CAShapeLayerFillRule {
		get {return shapeLayer.fillRule}
		set {shapeLayer.fillRule = newValue}
	}

	public var strokeColor: UIColor? {
		didSet {
			updateColors()
		}
	}

	public var strokeStart: CGFloat {
		get {return shapeLayer.strokeStart}
		set {shapeLayer.strokeStart = newValue}
	}

	public var strokeEnd: CGFloat {
		get {return shapeLayer.strokeEnd}
		set {shapeLayer.strokeEnd = newValue}
	}

	public var lineWidth: CGFloat {
		get {return shapeLayer.lineWidth}
		set {shapeLayer.lineWidth = newValue}
	}

	public var miterLimit: CGFloat {
		get {return shapeLayer.miterLimit}
		set {shapeLayer.miterLimit = newValue}
	}

	public var lineCap: CAShapeLayerLineCap {
		get {return shapeLayer.lineCap}
		set {shapeLayer.lineCap = newValue}
	}

	public var lineJoin: CAShapeLayerLineJoin {
		get {return shapeLayer.lineJoin}
		set {shapeLayer.lineJoin = newValue}
	}

	public var lineDashPhase: CGFloat {
		get {return shapeLayer.lineDashPhase}
		set {shapeLayer.lineDashPhase = newValue}
	}

	public var lineDashPattern: [CGFloat]? {
		get {return shapeLayer.lineDashPattern?.map{CGFloat($0.doubleValue)}}
		set {shapeLayer.lineDashPattern = newValue?.map{NSNumber(value: Double($0))}}
	}

	public var shapeLayer: CAShapeLayer {
		return layer as! CAShapeLayer
	}

	// MARK: - Private
	private func updateColors() {
		shapeLayer.fillColor = fillColor?.cgColor
		shapeLayer.strokeColor = strokeColor?.cgColor
	}

	// MARK: - UIView
	override public class var layerClass: AnyClass {
		return CAShapeLayer.self
	}

	override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateColors()
	}

	// MARK: - CALayerDelegate
	override public func action(for layer: CALayer, forKey key: String) -> CAAction? {
		if key == "path" || key == "strokeStart" || key == "strokeEnd" || key == "strokeColor" || key == "fillColor" {
			if let animation = layer.action(forKey: "opacity") as? CABasicAnimation {
				animation.keyPath = key
				animation.fromValue = (layer.presentation() ?? layer).value(forKey: key)
				animation.toValue = nil
				animation.byValue = nil
				return animation
			}
		}

		return super.action(for: layer, forKey: key)
	}
}

extension ShapeView {
	public convenience init(fillColor: UIColor?, strokeColor: UIColor?, lineWidth: CGFloat = 0) {
		self.init(frame: .zero)
		
		_ = {
			self.fillColor = fillColor
			self.strokeColor = strokeColor
			self.lineWidth = lineWidth
		}()
	}
	
	public convenience init(fillColor: UIColor, fillRule: CAShapeLayerFillRule = .nonZero) {
		self.init(frame: .zero)
		
		_ = {
			self.fillColor = fillColor
			self.fillRule = fillRule
		}()
	}
	
	public convenience init(strokeColor: UIColor, start: CGFloat = 0, end: CGFloat = 1, lineWidth: CGFloat) {
		self.init(frame: .zero)
		
		_ = {
			self.strokeColor = strokeColor
			self.fillColor = fillColor
			self.fillRule = fillRule
			self.lineWidth = lineWidth
		}()
	}
	
	public convenience init(cutOutCircleWithDiameter diameter: CGFloat, fillColor: UIColor) {
		self.init(frame: .zero)
		
		let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
		let path = UIBezierPath(rect: rect)
		path.append(UIBezierPath(roundedRect: rect, cornerRadius: diameter * 0.5))
		
		_ = {
			self.fillRule = .evenOdd
			self.fillColor = fillColor
			self.path = path
		}()
	}
}
