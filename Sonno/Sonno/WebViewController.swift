//
//  WebViewController.swift
//
//  Created by Lucas Maris on 4/24/15.
//  Copyright (c) 2015 JeniusLogic. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var activityIndicator: UIActivityIndicatorView!
    var loadingLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1.0
        self.addSubview(activityIndicator)
        
        activityIndicator.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp_center)
        }
        
        loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.customFont(.DisplayLight, size: 15.0)
        loadingLabel.textColor = UIColor.lightGrayColor()
        self.addSubview(loadingLabel)
        
        loadingLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(activityIndicator.snp_bottom).offset(10.0)
        }
    }
}

class WebViewController: UIViewController {
    
    let webView = UIWebView()
    var request: NSURLRequest!
    
    //Loading view
    let loadingView = LoadingView()

    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Add loader and webView
    func setUpWebView() {

        self.view.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(40.0)
        }
            
        //Web view
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.scalesPageToFit = true
        webView.alpha = 0.0
        webView.loadRequest(self.request)
        self.view.addSubview(webView)
        webView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
}

//MARK:- UIWebView Delegate
extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.webView.alpha = 1.0
            self.loadingView.hidden = true
            }) { (finished) -> Void in
        }
    }
}
