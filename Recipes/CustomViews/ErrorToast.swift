//
//  ErrorToast.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 10. 06..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import UIKit

class ErrorToast: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private var completion: () -> Void
    private var errorMessage: String
    private var topWindow: UIWindow

    private let toastHeight = CGFloat(80.0)

    init(errorMessage: String, topWindow: UIWindow, completion: @escaping () -> Void) {
        self.errorMessage = errorMessage
        self.topWindow = topWindow
        self.completion = completion
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 100)))
    }

    func show() {
        topWindow.addSubview(self)

        backgroundColor = .red

        let label = UILabel()
        label.textColor = .white
        label.text = errorMessage
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85

        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        leadingAnchor.constraint(equalTo: topWindow.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: topWindow.trailingAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: toastHeight).isActive = true
        topAnchor.constraint(equalTo: topWindow.bottomAnchor).isActive = true

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tapGesture)

        let presentingTransform = CGAffineTransform(translationX: 0, y: -toastHeight)
        UIView.animate(withDuration: 0.7, animations: {
            self.transform = presentingTransform
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.dismiss()
            })
        })
    }

    @objc
    private func dismiss() {
        let dismissingTransform = CGAffineTransform(translationX: 0, y: toastHeight)
        UIView.animate(withDuration: 0.7, animations: {
            self.transform = dismissingTransform
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
            self?.completion()
        })
    }
}
