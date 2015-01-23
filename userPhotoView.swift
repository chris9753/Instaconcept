//
//  userPhotoView.swift
//  Instaconcept
//
//  Created by Chris Da silva on 2015-01-22.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit
import Parse

class userPhotoView: UITableViewController {
    var authors = [String]()
    var imageFiles = [PFFile]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        var getFollowedUsersQuery = PFQuery(className: "followers")
        
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        
        var query = PFQuery(className:"Post")
        
        //query.whereKey("username", equalTo: "Patrik2")
        
        query.whereKey("username", matchesKey: "following", inQuery: getFollowedUsersQuery)
        
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                
                // Do something with the found objects
                
                println(objects)
                
                for object in objects {
                    
                    if let username = object["username"] as? String { self.authors.append(username) }
                    
                    
                    if let imageFiles = object["imageFile"] as? PFFile { self.imageFiles.append(imageFiles)}
                    
                    self.tableView.reloadData()
                    
                }
                
                self.tableView.reloadData()
                
            } else {
                
                // Log details of the failure
                
                println(error)
                
            }
            
        
        
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
        return authors.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var mycell : photoCell = self.tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as photoCell

        // Configure the cell...
        mycell.author.text = authors[indexPath.row]
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{(imageData : NSData!, error: NSError!) -> Void in
            if error == nil {
            let image = UIImage(data: imageData)
                mycell.postedImage.image = image
            }
        }
        
        mycell.sizeToFit()
        return mycell
    }

  }
