//
//  CustomNavigationTransition.swift
//  Recipes
//
//  Created by Marcell Magyar on 2020. 11. 21..
//  Copyright © 2020. Marcell Magyar. All rights reserved.
//

import Foundation
import UIKit

final class CustomNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let operation: UINavigationController.Operation
    let duration: Double

    init(operation: UINavigationController.Operation, duration: Double) {
        self.operation = operation
        self.duration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
            performPushTransition(transitionContext)
        } else if operation == .pop {
            performPopTransition(transitionContext)
        }
    }

    func performPushTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toViewController = transitionContext.viewController(forKey: .to) as? DetailViewController
        else {
            return
        }

        let container = transitionContext.containerView
        container.addSubview(toView)

        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? CollectionViewTransitionable,
            let fromCollectionView = fromViewController.collectionView,
            let fromCell = fromViewController.sourceCell as? RecipeCollectionViewCell
        else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        // screenshot about the toView in the screen's coord system
        let toViewScreenshot = UIImageView(image: toView.screenshot)
        toViewScreenshot.frame = fromCell.frame
        let containerCoord = fromCollectionView.convert(toViewScreenshot.frame.origin, to: container)
        toViewScreenshot.frame.origin = containerCoord

        // screenshot about the cell
        let fromViewScreenshot = UIImageView(image: fromCell.image.screenshot)
        fromViewScreenshot.frame = toViewController.image.frame

        container.addSubview(toViewScreenshot)
        container.addSubview(fromViewScreenshot)

        // we hide the toView until animation is done
        toView.isHidden = true
        fromViewScreenshot.alpha = 0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                toViewScreenshot.frame = UIScreen.main.bounds
                toViewScreenshot.frame.origin = CGPoint(x: 0, y: 0)
                fromViewScreenshot.frame = toViewScreenshot.frame
            },
            completion: { _ in
                toViewScreenshot.removeFromSuperview()
                fromViewScreenshot.removeFromSuperview()
                toView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

    func performPopTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let container = transitionContext.containerView
        container.addSubview(toView)

        guard
            let fromView = transitionContext.view(forKey: .from),
            let fromViewController = transitionContext.viewController(forKey: .from) as? DetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? CollectionViewTransitionable,
            let toCollectionView = toViewController.collectionView,
            let toCell = toViewController.sourceCell as? RecipeCollectionViewCell
        else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        let fromViewScreenshot = UIImageView(image: fromViewController.image.screenshot)
        fromViewScreenshot.frame = fromViewController.image.frame

        let toViewScreenshot = UIImageView(image: toCell.image.screenshot)
        toViewScreenshot.frame = fromViewScreenshot.frame

        container.addSubview(toViewScreenshot)
        container.addSubview(fromViewScreenshot)

        toViewScreenshot.alpha = 0
        fromView.isHidden = true
        toCell.image.isHidden = true

        // 15 is a magic constans for a hacky solution of only the first cell frame animation..
        let containerCoord = toCollectionView.convert(CGPoint(x: toCell.frame.origin.x, y: toCell.frame.origin.y + 15), to: container)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                fromViewScreenshot.alpha = 0
                toViewScreenshot.alpha = 1
                toViewScreenshot.frame = CGRect(origin: containerCoord, size: toCell.image.frame.size)
            },
            completion: { _ in
                fromViewScreenshot.removeFromSuperview()
                toViewScreenshot.removeFromSuperview()
                toCell.image.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
