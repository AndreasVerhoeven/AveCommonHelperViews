//
//  UIView+Helper.swift
//  Demo
//
//  Created by Andreas Verhoeven on 28/06/2022.
//

import UIKit

public extension UIView {
	enum TraversalOrder {
		case breadthFirst /// breadth first so [self, subviews, subviews-of-first-subview, etc]
		case depthFirst /// depth first so [self, first subview, first subview-of-first-subview, second-subview-of-first-subview, second-subview, etc]
	}
	
	enum TraversalOperation {
		case `continue` /// continue traversing
		case stop /// stop traversing
	}
	
	/// Traverses views in the hierarchy and calls a callback until the callback returns `.stop`
	///
	/// - Parameters:
	/// 	- order: **optional** the order to traverse in, `.breadthFirst` or `.depthFirst`. Defaults. to .`breadFirst`.
	///		- callback: the callback to call for each view. Called must return `.stop` or `.continue`
	func traverseViewsInHierarchy(order: TraversalOrder = .breadthFirst, callback: (UIView) -> TraversalOperation) {
		var stack = [self]
		while stack.isEmpty == false {
			let view = stack.removeLast()
			guard callback(view) == .continue else { return }
			switch order {
				case .breadthFirst:
					stack.insert(contentsOf: view.subviews.reversed(), at: 0)
					
				case .depthFirst:
					stack.append(contentsOf: view.subviews.reversed())
			}
		}
	}
	
	/// Traverses all views in the hierarchy and calls a callback
	///
	/// - Parameters:
	/// 	- order: **optional** the order to traverse in, `.breadthFirst` or `.depthFirst`. Defaults. to .`breadFirst`.
	func traverseAllViewsInHierarchy(order: TraversalOrder = .breadthFirst, callback: (UIView) -> Void) {
		traverseViewsInHierarchy(order: order) { view -> TraversalOperation in
			callback(view)
			return .continue
		}
	}
	
	/// Traverses views in the hierarchy of a certain type and calls a callback until the callback returns `.stop`
	///
	/// - Parameters:
	/// 	- type: the type of view we want to traverse
	/// 	- order: **optional** the order to traverse in, `.breadthFirst` or `.depthFirst`. Defaults. to .`breadFirst`.
	///		- callback: the callback to call for each view. Called must return `.stop` or `.continue`
	func traverseViewsInHierarchy<T: UIView>(of type: T.Type, order: TraversalOrder = .breadthFirst, callback: (T) -> TraversalOperation) {
		traverseViewsInHierarchy(order: order) { view -> TraversalOperation in
			guard let view = view as? T else { return .continue }
			return callback(view)
		}
	}
	
	/// Traverses all views in the hierarchy of a certain type and calls a callback
	///
	/// - Parameters:
	/// 	- type: the type of view we want to traverse
	/// 	- order: **optional** the order to traverse in, `.breadthFirst` or `.depthFirst`. Defaults. to .`breadFirst`.
	func traverseAllViewsInHierarchy<T: UIView>(of type: T.Type, order: TraversalOrder = .breadthFirst, callback: (T) -> Void) {
		traverseViewsInHierarchy(of: type, order: order) { view -> TraversalOperation in
			callback(view)
			return .continue
		}
	}
	
	/// Finds the first view of a certain type in the view hierarchy.
	///
	/// - Parameters:
	/// 	- type: the type of view that is wanted
	/// 	- order: **optional** the order to traverse in, `.breadthFirst` or `.depthFirst`. Defaults. to .`breadFirst`.
	///
	/// - Returns:
	/// 		- the first view of the wanted type, if found, or `nil` otherwise
	func firstViewInHierarchy<T: UIView>(of type: T.Type, order: TraversalOrder = .breadthFirst) -> T? {
		var hit: T?
		traverseViewsInHierarchy(order: order) { view -> TraversalOperation in
			hit = view as? T
			return hit != nil ? .stop : .continue
		}
		return hit
	}
	
	/// Finds the first superview of a certain type in the super view hierarchy
	///
	/// - Parameters:
	/// 	- type: the type of view that is wanted
	///
	/// - Returns:
	/// 		- the first view of the wanted type, if found, or `nil` otherwise
	func firstSuperviewInHierarchy<T: UIView>(of type: T.Type) -> T? {
		var view = superview
		while view != nil {
			if let view = view as? T {
				return view
			}
			view = view?.superview
		}
		
		return nil
	}
}

extension UIView {
	/// Returns the nearest view controller up the responder chain
	public var nearestViewController: UIViewController? {
		var responder: UIResponder? = self
		while responder != nil {
			if let controller = responder as? UIViewController {
				return controller
			}
			responder = responder?.next
		}
		return nil
	}
}
public extension UIView {
	/// Only sets isHidden to the newValue if it is different. This works around a UIStackView issue
	/// where calling isHidden with the same value as it is causes the view to never show up during animations.
	var safeIsHidden: Bool {
		set {
			guard newValue != isHidden else { return }
			isHidden = newValue
		}
		get {
			return isHidden
		}
	}
}
