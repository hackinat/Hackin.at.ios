//
//  DashboardViewController.swift
//  Hackin.at
//
//  Created by Prateek on 12/17/14.
//  Copyright (c) 2014 Prateek Dayal. All rights reserved.
//

//
//  DashboardViewController.swift
//  Github Auth
//
//  Created by Prateek on 11/6/14.
//  Copyright (c) 2014 Prateek. All rights reserved.
//

import UIKit
import PureLayout

class TableRefreshControl {
    var refreshControl = UIRefreshControl()
    let tableView: UITableView
    
    class func setupForTableViewWithAction(#tableView: UITableView, target: AnyObject, action: String) -> TableRefreshControl{
        return TableRefreshControl(tableView: tableView, target: target, action: action)
    }
    
    init(tableView: UITableView, target: AnyObject, action: String){
        self.tableView = tableView
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(target, action: Selector(action), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(self.refreshControl)
    }
    
    func endRefreshing(){
        self.refreshControl.endRefreshing()
    }
}

class BroadcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var broadcastsTableView: UITableView!
    
    var broadcasts: Array<Broadcast> = []
    var tableRefreshControl:TableRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewStyle()
        setupTableViewWiring()
        setupAutoRefresh()
        fetchBroadcasts()
    }
    
    func setupTableViewWiring(){
        self.broadcastsTableView.delegate = self
        self.broadcastsTableView.dataSource = self
        self.broadcastsTableView.registerNib(
            UINib(nibName:"BroadcastTableViewCell", bundle:nil), forCellReuseIdentifier: "BroadcastCell")
    }
    
    func setupAutoRefresh(){
        tableRefreshControl = TableRefreshControl.setupForTableViewWithAction(
            tableView: self.broadcastsTableView,
            target: self,
            action: "refreshBroadcasts"
        )
    }
    
    func setupTableViewStyle(){
        self.broadcastsTableView.estimatedRowHeight = 100
        self.broadcastsTableView.rowHeight = UITableViewAutomaticDimension
        self.broadcastsTableView.separatorInset = UIEdgeInsetsZero
    }
    
    override func updateViewConstraints() {
        self.broadcastsTableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        self.broadcastsTableView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0)
        self.broadcastsTableView.autoPinEdgeToSuperviewEdge(ALEdge.Right)
        self.broadcastsTableView.autoPinEdgeToSuperviewEdge(ALEdge.Left)
        super.updateViewConstraints()
    }
    
    func refreshBroadcasts(){
        func onFetch(broadcasts:[Broadcast]){
            renderBroadcasts(broadcasts)
            self.tableRefreshControl.endRefreshing()
        }
        Broadcast.fetchBroadcasts(success: onFetch)
    }
    
    func fetchBroadcasts(){
        Broadcast.fetchBroadcasts(success: renderBroadcasts)
    }
    
    func renderBroadcasts(broadcasts:[Broadcast]){
        self.broadcasts = broadcasts
        self.broadcastsTableView.reloadData()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func broadcastButtonPressed(sender: AnyObject) {
        var newBroadcastStoryBoard = UIStoryboard(name: "NewBroadcast", bundle: nil)
        let vc = newBroadcastStoryBoard.instantiateViewControllerWithIdentifier("newBroadcastViewController") as UINavigationController;
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.broadcasts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "BroadcastCell", forIndexPath:indexPath) as BroadcastTableViewCell
        let broadcast = broadcasts[indexPath.row]
        cell.setupViewData(broadcast)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var newBroadcastStoryBoard = UIStoryboard(name: "Broadcasts", bundle: nil)
        let vc = newBroadcastStoryBoard.instantiateViewControllerWithIdentifier("broadcastViewController") as BroadcastViewController;
        vc.broadcast = broadcasts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}