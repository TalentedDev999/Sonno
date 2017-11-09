//
//  MGSafariViewController.swift
//
//  Created by Lucas Maris on 11/18/15.
//  Copyright © 2015 Lucas Maris. All rights reserved.
//

import UIKit
import SafariServices

@available(iOS 9.0, *)
class MGSafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.barStyle = UIBarStyle.Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
