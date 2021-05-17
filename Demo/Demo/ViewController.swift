//
//  ViewController.swift
//  Demo
//
//  Created by Andreas Verhoeven on 16/05/2021.
//

import UIKit

class ViewController: UIViewController {
	let roundRectView = RoundRectView(cornerRadius: 16, cornerIsContinuous: true, borderWidth: 1, borderColor: .red, backgroundColor: .lightGray, clipsToBounds: true)
	let gradientView = GradientView(verticallyFadingOutFrom: .white)
	let circleView = CircleView(size: 44, backgroundColor: .blue)

	let fixedSizeView = FixedSizeView(size: CGSize(width: 10, height: 4), backgroundColor: .green)

	@objc private func tapped(_ sender: Any) {
		UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
			if self.roundRectView.cornerRadius == 16 {
				self.roundRectView.cornerRadius = 48
				self.gradientView.setVerticalLinearFadeIn(to: .red)
				self.circleView.fixedSize = 20
				self.fixedSizeView.fixedSize = CGSize(width: 2, height: 8)
			} else {
				self.roundRectView.cornerRadius = 16
				self.gradientView.setVerticalLinearFadeOut(from: .white)
				self.circleView.fixedSize = 44
				self.fixedSizeView.fixedSize = CGSize(width: 10, height: 4)
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground

		roundRectView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(roundRectView)

		gradientView.translatesAutoresizingMaskIntoConstraints = false
		roundRectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
		roundRectView.addSubview(gradientView)

		circleView.translatesAutoresizingMaskIntoConstraints = false
		roundRectView.addSubview(circleView)

		fixedSizeView.translatesAutoresizingMaskIntoConstraints = false
		circleView.addSubview(fixedSizeView)

		NSLayoutConstraint.activate([
			roundRectView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			roundRectView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

			roundRectView.widthAnchor.constraint(equalToConstant: 200),
			roundRectView.heightAnchor.constraint(equalToConstant: 100),

			gradientView.leadingAnchor.constraint(equalTo: roundRectView.leadingAnchor),
			gradientView.trailingAnchor.constraint(equalTo: roundRectView.trailingAnchor),
			gradientView.topAnchor.constraint(equalTo: roundRectView.topAnchor),
			gradientView.bottomAnchor.constraint(equalTo: roundRectView.bottomAnchor),

			circleView.centerYAnchor.constraint(equalTo: roundRectView.centerYAnchor),
			circleView.centerXAnchor.constraint(equalTo: roundRectView.centerXAnchor),

			fixedSizeView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
			fixedSizeView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
		])

	}
}

