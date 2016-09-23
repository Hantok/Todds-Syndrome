//
//  UsersTableViewController.swift
//  Todds Syndrome
//
//  Created by Roman on 9/23/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit

var selectedUser: User?

class UsersTableViewController: UITableViewController {
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        selectedUser = nil
        users = CoreService.fetchUsers()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userIdentifier", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.users[indexPath.row].valueForKey("name") as? String
        cell.detailTextLabel?.text = "Todd's syndrome probability is \(self.users[indexPath.row].getPercent())%"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedUser = users[indexPath.row]
        performSegueWithIdentifier("toTest", sender: self)
    }
}
