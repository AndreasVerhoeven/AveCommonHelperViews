//
//  CircleView.swift
//  Demo
//
//  Created by Andreas Verhoeven on 17/05/2021.
//

import UIKit

/// a view that is always a circle
public class CircleView: UIView {
	/// Set this to a non nil value to force a width and height
	public var fixedSize: CGFloat? = 0 {
		didSet {
			guard fixedSize != oldValue else { return }
			updateFixedSize()

			superview?.setNeedsLayout()
			if UIView.inheritedAnimationDuration > 0 {
				superview?.layoutIfNeeded()
			}
		}
	}

	/// Creates a circle view with a fixed size
	///
	/// - Parameters:
	///		- size: the size of the circle (both dimensions)
	///		- backgroundColor: **optional** the background color to set, defaults to nil
	///		- clipsToBounds: **optional** clips to bounds, defaults to false
	public convenience init(size: CGFloat, backgroundColor: UIColor? = nil, clipsToBounds: Bool = false) {
		self.init()
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds
		fixedSize = size
		updateFixedSize()
	}

	// MARK: - Private
	private func setup() {
		let constraint = heightAnchor.constraint(equalTo: widthAnchor)
		constraint.priority = .required
		constraint.isActive = true
	}

	private func updateFixedSize() {
		fixedWidthAnchor.constant = fixedSize ?? 0
		fixedWidthAnchor.isActive = (fixedSize != nil)
	}

	private lazy var fixedWidthAnchor: NSLayoutConstraint = {
		let constraint = widthAnchor.constraint(equalToConstant: fixedSize ?? 0)
		constraint.priority = .required
		return constraint
	}()
	
	// MARK: - UIView
	public override func layoutSubviews() {

		super.layoutSubviews()
		layer.cornerRadius = bounds.height * 0.5
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
}
