//
//  ContentTextView.swift
//  CommonViews
//
//  Created by Andreas Verhoeven on 13/05/2021.
//

import UIKit

/// A text view that can be used for content:
///  - doesn't allow scrolling by default
///	 - text selection is disabled by default
///	 - still allows link interaction
public class ContentTextView: UITextView {

	/// If yes, allows text selection, otherwise only links can be interacted with
	public var isAllowingTextSelection = false

	/// the actual text color that was set programmatically
	private var actualTextColor: UIColor?

	override public init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)

		isScrollEnabled = false
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - UITextView

	// WORKAROUND (iOS 13, *) UITextView gets its textColor from the inputControllers
	// typingAttributes, which, if the last text is a link, is blue and not the color we
	// did set.
	override public var textColor: UIColor? {
		set {
			actualTextColor = newValue
			super.textColor = newValue
		}
		get {
			return actualTextColor
		}
	}

	override public var typingAttributes: [NSAttributedString.Key : Any] {
		get {
			var attributes = super.typingAttributes
			actualTextColor.map { attributes[.foregroundColor] = $0  }
			return attributes
		}
		set {
			super.typingAttributes = newValue
		}
	}

	// MARK: - UIView
	override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard isAllowingTextSelection == false, isScrollEnabled == false else { return super.hitTest(point, with: event) }

		let fixedPoint = CGPoint(x: point.x - textContainerInset.left, y: point.y - textContainerInset.top)
		let characterIndex = layoutManager.characterIndex(for: fixedPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
		guard characterIndex >= 0, characterIndex < textStorage.length else {return nil}

		guard textStorage.attributes(at: characterIndex, effectiveRange: nil)[.link] != nil else {return nil}
		return super.hitTest(point, with: event)
	}

	// MARK: - UIResponder
	override public var canBecomeFirstResponder: Bool {
		return isAllowingTextSelection && super.canBecomeFirstResponder
	}

	override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return isAllowingTextSelection && super.canPerformAction(action, withSender: sender)
	}
}
