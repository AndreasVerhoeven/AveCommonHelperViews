//
//  UIResponder+Helper.swift
//  Demo
//
//  Created by Andreas Verhoeven on 28/06/2022.
//

import UIKit

extension UIResponder {
	/// Returns the current first responder
	public var first: UIResponder? {
		let responders = NSMutableArray()
		UIApplication.safeShared?.sendAction(#selector(aveapps_local_1203_updateFirstResponder(_:event:)), to: nil, from: responders, for: nil)
		return responders.firstObject as? UIResponder
	}
}

extension UIApplication {
	fileprivate static var safeShared: UIApplication? {
		guard UIApplication.responds(to: Selector(("sharedApplication"))) else { return nil }
		guard let unmanagedSharedApplication = UIApplication.perform(Selector(("sharedApplication"))) else { return nil }
		return unmanagedSharedApplication.takeRetainedValue() as? UIApplication
	}
}

extension UIResponder {
	@objc fileprivate func aveapps_local_1203_updateFirstResponder(_ array: NSMutableArray, event: UIEvent?) {
		guard array.isKind(of: NSMutableArray.self) == true else { return }
		
		// because every UIResponder implements this, we get the first responder only.
		array.add(self)
	}
}
