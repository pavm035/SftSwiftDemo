//
//  ViewController.swift
//  MyTableView
//
//  Created by Pavanm OP on 10/06/14.
//  Copyright (c) 2014 Openpeak. All rights reserved.
//

import UIKit


class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
                            
    @IBOutlet   var mTableView : UITableView = nil
                var mTableData = NSArray()
                var mImageCache = NSMutableDictionary()
                var api: APIController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Swift"
        self.api = APIController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api?.searchInItunesStore("Mobile CRM+ for MS Dynamics")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section:    Int) -> Int {
        return self.mTableData.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let kCellIdentifier: String = "SearchResultCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        var rowData = self.mTableData[indexPath.row] as NSDictionary
        
        cell.textLabel.text = rowData["trackName"] as String
        // Get the formatted price string for display in the subtitle
        cell.detailTextLabel.text = rowData["formattedPrice"] as String
        
        //set default image
        cell.image = UIImage(named: "placeholder")
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            var urlString = rowData["artworkUrl60"] as NSString
            var image: UIImage? = self.mImageCache.valueForKey(urlString) as? UIImage
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if(!image)
            {
                var imgURL = NSURL(string: urlString)
                var request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if !error? {
                        //var imgData: NSData = NSData(contentsOfURL: imgURL)
                        image = UIImage(data: data)
                        // Store the image in to our cache
                        self.mImageCache.setValue(image, forKey: urlString)
                        cell.image = image
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                    else
                    {
                        println("Error: \(error.localizedDescription)")
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                    })
            }
            else
            {
                cell.image = image
            }
            })
        
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //APIControllerProtocol
       func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count>0 {
            self.mTableData = results["results"] as NSArray
            self.mTableView.reloadData()
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject)
    {
        var detailsViewController: DetailViewController = segue.destinationViewController as DetailViewController
        var selectedIndex = self.mTableView.indexPathForSelectedRow().row
        var selectedItem = self.mTableData[selectedIndex] as NSDictionary
        detailsViewController.selectedItem = selectedItem as NSDictionary!
    }
    
    
}

