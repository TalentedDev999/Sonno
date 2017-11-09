//
//  GenericTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class GenericTableViewController: UIViewController {

    var tableView: UITableView!
    let backgroundImageView = UIImageView(image: UIImage(assetIdentifier: .StarsBackground))

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).offset(UIEdgeInsets(top: -64.0, left: -10, bottom: 10, right: 10))
        }
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).offset(UIEdgeInsets(top: -10, left: -10, bottom: 10, right: 10))
        }
        
        addInterpolationMovement()
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK: Interpolation Movement
    func addInterpolationMovement() {
        
        backgroundImageView.addBackgroundInterpolationMovement()
        
        tableView.addForegroundInterpolationMovement()
    }
}

// MARK: - Table view data source
extension GenericTableViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tableCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tableCell")
        }
        
        return cell!
    }
}

//MARK: UITableView Delegate
extension GenericTableViewController: UITableViewDelegate {

}
