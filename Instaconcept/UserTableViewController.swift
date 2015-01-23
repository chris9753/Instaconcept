//
//  UserTableViewController.swift
//  Instaconcept
//
//  Created by Chris Da silva on 2015-01-21.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var users = [String]()
    var refresher : UIRefreshControl!
    
    @IBAction func viewFeed(sender: AnyObject) {
        self.performSegueWithIdentifier("viewFeed", sender: self)
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        updateUser()

       
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refresher, atIndex: 0)
    }
    
    func updateUser(){
        var query = PFUser.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!,error: NSError!) -> Void in
            self.users.removeAll(keepCapacity: true)
            
            for object in objects {
                if object.username != PFUser.currentUser().username {
                    
                    self.users.append(object.username)
                    self.tableView.reloadData()
                    
                    
                }
            }
         self.refresher.endRefreshing()
        }
    }
    
    func refresh(){
        updateUser()
        println("refreshed")
        self.tableView.reloadData()
    }
    
    func checkCell(cell: UITableViewCell) {
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.orderByAscending("username")
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.whereKey("following", equalTo:cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock ({
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    
                    for object in objects {
                        object.deleteEventually()
                    }
                } else {
                    // Log details of the failure
                    println(error)
                }
            })
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            following.saveEventually()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
         println(users.count)
        return users.count
       
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

       var queryo = PFQuery(className: "followers")
        queryo.whereKey("follower", equalTo:PFUser.currentUser().username)
        queryo.whereKey("following", equalTo:users[indexPath.row])
        queryo.findObjectsInBackgroundWithBlock ({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects.count > 0 {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            })
                
       
      
       cell.textLabel?.text = users[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
      checkCell(cell)
    }
}