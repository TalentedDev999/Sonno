//
//  AnimationViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/30/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class AnimationViewController: GenericViewController {
    
    override func loadView() {
        super.loadView()
        let animationView = AnimationView()
        animationView.delegate = self
        self.view = animationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        (self.view as! AnimationView).showLogo()
        
//        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func restoreAnimationView() {
        (self.view as! AnimationView).restoreViews()
    }
}

extension AnimationViewController: AnimationViewDelegate {
    
    func sendToHome() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        
        transition.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        
        self.navigationController?.view.layer.addAnimation(transition, forKey: "kCATransition")
        self.navigationController?.pushViewController(HomeViewController(), animated: false)
    }
    
    func sendToTutorial() {
        let walkViewController = WalkthroughViewController()
        walkViewController.delegate = self
        self.presentViewController(walkViewController, animated: false, completion: nil)
    }
}

//MARK: WalkthroughtViewContoller Delegate
extension AnimationViewController: WalkthroughViewControllerDelegate {
    func didDisapperar() {
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "restoreAnimationView", userInfo: nil, repeats: false)
    }
}
