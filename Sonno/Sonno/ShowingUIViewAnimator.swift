//
//  ShowingUIViewAnimator.swift
//  Showing
//
//  Created by Lucas Maris on 12/13/15.
//  Copyright © 2015 Lucas Maris. All rights reserved.
//

import UIKit
import Spring

public class ShowingUIViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration: NSTimeInterval = 0.33
    public var spriteWidth: CGFloat = 10
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        

        toView.transform = CGAffineTransformMakeScale(0.935, 0.935)
        
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn,  animations: {
            
            fromView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenHeight, height: kScreenHeight)
            
            }) { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        
        UIView.animateWithDuration(0.7,
            delay: 0.15,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }) { (finished) -> Void in
        }
    }
}
