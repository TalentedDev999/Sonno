//
//  PremiumAdTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 12/1/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import StoreKit

class PremiumAdTableViewController: AudioTableViewController {
    
    //MARK: Init and Dealloc
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(plistName: String) {
        super.init(nibName: nil, bundle: nil)
        plistString = plistName
    }

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < 5 {
            var cell = tableView.dequeueReusableCellWithIdentifier("premiumCell") as? CenterTextTableViewCell
            if cell == nil {
                cell = CenterTextTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "premiumCell")
            }
            
            cell?.backgroundColor = UIColor(hex: items[indexPath.row].hexColor)
            cell?.cellLabel.text = items[indexPath.row].title
            
            if indexPath.row == 0 {
                cell?.cellLabel.customFont(.DisplayRegular, size: 24.0)
            }
            
            return cell!
            
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("goPremiumCell") as? PremiumTableViewCell
            if cell == nil {
                cell = PremiumTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "goPremiumCell")
            }
            
            return cell!
        }
    }

    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 5 ? 104.0 : 82.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == items.count - 1 {
            if IAPHelper.canMakePayments() {
                //Handle payment
                print("Purchase premium version")
                if PurchaseManager.sharedInstance.products.count > 0 {
                    buyProduct(PurchaseManager.sharedInstance.products[0])
                }
                
            } else {
                //Not allowed to make payments (parental control, disabled, country doesnt support)
                self.createAlertController("Purchase error", message: "You are not allowed to continue with the purchase, make sure you have the corresponding permisions")
            }
        }
    }
    
    func createFooter() {
        let footerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 74.0))
        
        let button = UIButton()
        button.setTitle("maybe later >", forState: UIControlState.Normal)
        button.titleLabel?.customFont(.DisplayLight, size: 18.0)
        button.addTarget(self, action: "dismissController", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(footerView.snp_center)
        }
        
        self.tableView.tableFooterView = footerView
    }
    
    func dismissController() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: InApp Purchase
    func buyProduct(product: SKProduct) {
        if PurchaseManager.sharedInstance.products.count > 0 {
            RageProducts.store.purchaseProduct(PurchaseManager.sharedInstance.products[0])
        }
    }
    
    // When a product is purchased, this notification fires, dismiss ad
    func productPurchased(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        for product in PurchaseManager.sharedInstance.products {
            if product.productIdentifier == productIdentifier {
                self.dismissViewControllerAnimated(true, completion: nil)
                break
            }
        }
    }
}
