//
//  CustomHighlightingControl.swift
//  AveCommonViews
//
//  Created by Andreas Verhoeven on 05/06/2021.
//

import UIKit

/// A UIControl subclass that does highlighting like UIButton does it
open class CustomHighlightingControl: UIControl {

	public enum HighlightingStyle {
		/// doesn't highlight on initial touch down
		case normal

		/// always animates, even on touch down
		case alwaysAnimate
	}

	/// how we should highlight
	open var highlightingStyle: HighlightingStyle = .alwaysAnimate

	public typealias HighlightingCallback = (Bool, CustomHighlightingControl) -> Void

	/// called by updateHighlighting by default
	open var highlightingCallback: HighlightingCallback?

	/// Default fades out the view
	open func updateHighlighting(_ shouldHighlight: Bool) {
		highlightingCallback?(shouldHighlight, self)
	}

	open func setIsHighlighted(_ highlighted: Bool, animated: Bool) {
		guard isHighlighted != highlighted else { return }
		isHighlighted = highlighted

		let updates = {
			self.updateHighlighting(self.isHighlighted)
		}
		if animated == true {
			UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: updates)
		} else {
			updates()
		}
	}

	// MARK: - Input
	@objc private func customButtonTouchesChanged(_ sender: Any, event: UIEvent?) {
		let shouldBeHighlighted = isTracking && isTouchInside
		let touchPhase = event?.allTouches?.first?.phase ?? .began

		if touchPhase == .began && highlightingStyle == .normal {
			updateHighlighting(shouldBeHighlighted)
		} else {
			var options: UIView.AnimationOptions = .allowUserInteraction
			if touchPhase  != .ended {
				options.insert(.beginFromCurrentState)
			}

			UIView.animate(withDuration: 0.25, delay: 0, options: options) {
				self.updateHighlighting(shouldBeHighlighted)
			}
		}
	}

	// MARK: - Private
	private func setup() {
		addTouchesHandlerIfNeeded()
	}

	private func addTouchesHandlerIfNeeded() {
		guard (actions(forTarget: self, forControlEvent: .touchDown)?.contains(NSStringFromSelector(#selector(customButtonTouchesChanged(_:event:)))) ?? false) == false else { return }
		addTarget(self, action: #selector(customButtonTouchesChanged(_:event:)), for: .allTouchEvents)
	}

	// MARK: - UIControl
	open override func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
		super.removeTarget(target, action: action, for: controlEvents)
		addTouchesHandlerIfNeeded()
	}

	// MARK: - UIView
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
}
