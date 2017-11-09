//
//  SettingsTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 12/1/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import SafariServices

class SettingsTableViewController: GenericTableViewController {

    //MARK: Properties
    let headers = ["ABOUT", "WEBSITES", "SOCIAL NETWORKS"]
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.bounces = false
        createFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 2 : 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("textViewCell") as? TextViewTableViewCell
            if cell == nil {
                cell = TextViewTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textViewCell", text: kAboutText)
            }
            
            cell?.layoutIfNeeded()
            
            return cell!
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("websiteCell") as? ContactTableViewCell
            if cell == nil {
                cell = ContactTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "websiteCell")
            }
            
            cell?.delegate = self
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("socialCell") as? CenterTextTableViewCell
            if cell == nil {
                cell = CenterTextTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "socialCell")
                cell?.socialStyle()
            }
            
            cell?.cellLabel.text = indexPath.row == 0 ? "Follow us on Facebook" : "Follow us on Twitter"
            
            return cell!
        }
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return CustomTableHeaderView(title: headers[section])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            self.openWebsiteWithString(indexPath.row == 0 ? "www.facebook.com/sonnoapp" : "www.twitter.com/sonnoapp")
        }
    }
    
    func createFooter() {
        let footerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 200.0))
        
        let clearCacheButton = UIButton()
        clearCacheButton.setTitle("Clear Cache", forState: UIControlState.Normal)
        clearCacheButton.backgroundColor = kSonnoBlueColor
        clearCacheButton.layer.cornerRadius = 5.0
        clearCacheButton.addTarget(self, action: "clearCachePressed", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(clearCacheButton)
        clearCacheButton.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(footerView)
            make.top.equalTo(footerView).offset(10.0)
            make.height.equalTo(50.0)
        }
        
        let button = UIButton()
        button.setTitle("Go Premium", forState: UIControlState.Normal)
        button.backgroundColor = kSonnoBlueColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: "buttonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(footerView)
            make.top.equalTo(clearCacheButton.snp_bottom).offset(10.0)
            make.height.equalTo(clearCacheButton)
        }
        
        let tutorialButton = UIButton()
        tutorialButton.setTitle("Tutorial", forState: UIControlState.Normal)
        tutorialButton.backgroundColor = kSonnoBlueColor
        tutorialButton.layer.cornerRadius = 5.0
        tutorialButton.addTarget(self, action: "tutorialPressed", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(tutorialButton)
        tutorialButton.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(footerView)
            make.top.equalTo(button.snp_bottom).offset(10.0)
            make.height.equalTo(clearCacheButton)
        }
        
        self.tableView.tableFooterView = footerView
    }
    
    func buttonPressed() {
        let navigationController = UINavigationController(rootViewController: PremiumAdTableViewController(plistName: "PremiumAd"))
        navigationController.addNavigationBarTitle(title: "sonno")
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func tutorialPressed() {
        let tutorialViewController = WalkthroughViewController()
        self.presentViewController(tutorialViewController, animated: true, completion: nil)
    }
    
    func clearCachePressed() {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "Clearing cache will delete all your playlists (this can't be undone)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Clear Cache", style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
            PlaylistManager.sharedInstance.clearPlaylistsCache()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func openWebsiteWithString(stringURL: String) {
        
        if #available(iOS 9.0, *) {
            let safariViewController = SFSafariViewController(URL: NSURL(string: "http://\(stringURL)")!)
            safariViewController.delegate = self
            safariViewController.transitioningDelegate = self
            self.presentViewController(safariViewController, animated: true, completion: nil)
        } else {
            let webViewController = WebViewController()
            if let url = NSURL(string: stringURL) {
                webViewController.request = NSURLRequest(URL: url)
                self.presentViewController(webViewController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: ContactTableViewCellDelegate 
extension SettingsTableViewController: ContactTableViewCellDelegate {
    
    func openWebsiteWithURL(websiteString: String) {
        self.openWebsiteWithString(websiteString)
    }
}

//MARK: SFSafariViewControllerDelegate
extension SettingsTableViewController: SFSafariViewControllerDelegate {
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: UIViewControllerTransitioningDelegate
extension SettingsTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowingUIViewAnimator()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingUIAnimator()
    }
}
