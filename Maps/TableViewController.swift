//
//  TableViewController.swift
//  Maps
//
//  Created by NanYar on 21.11.14.
//  Copyright (c) 2014 NanYar. All rights reserved.
//

import UIKit

// Global Variables
var places: [Dictionary<String, String>] = [] // = an array of dictionaries (with name + latitude + longitude for each place)
var activePlace = 0

class TableViewController: UITableViewController
{
    // Properties
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // self.navigationController?.navigationBarHidden = true
        
        if places.count == 0 // = Um doppelten Starteintrag zu vermeiden
        {
            places.append(["name" : "Taj Mahal", "lat" : "27.175277", "lon" : "78.042128"])
        }
        println("Places: \(places.count)")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // Example: For an own NavigationBar
//    override func viewWillDisappear(animated: Bool)
//    {
//        self.navigationController?.navigationBarHidden = true
//    }
    
    
    
    
    // Helper Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "addPlace"
        {
            activePlace = -1 // = anhand der -1 weiss danna der VC, dass "+" gedrueckt wurde
        }
    }
    

    // UITableViewController
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return places.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = places[indexPath.row]["name"]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        activePlace = indexPath.row
        println("indexPath.row: \(indexPath.row)")
        
        self.performSegueWithIdentifier("findPlace", sender: indexPath) // TODO: .row ?
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
