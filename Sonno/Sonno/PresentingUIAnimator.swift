//
//  PresentingUIAnimator.swift
//  Showing
//
//  Created by Lucas Maris on 12/13/15.
//  Copyright © 2015 Lucas Maris. All rights reserved.
//

import UIKit
import Spring

public class PresentingUIAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration: NSTimeInterval = 0.33
    public var spriteWidth: CGFloat = 10
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        toView.frame = CGRect(x: 0.0, y: kScreenHeight, width: toView.frame.size.width, height: toView.frame.size.height)
        
        containerView.addSubview(toView)
//        containerView.sendSubviewToBack(toView)
        
        UIView.animateWithDuration(0.7,
            delay: 0.0,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                fromView.transform = CGAffineTransformMakeScale(0.935, 0.935)
            }) { (finished) -> Void in
        }
        
        UIView.animateWithDuration(0.5,
            delay: 0.15,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                toView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            }) { (finished) -> Void in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}