//
//  DetailViewController.swift
//  MyTableView
//
//  Created by Pavanm OP on 10/06/14.
//  Copyright (c) 2014 Openpeak. All rights reserved.
//

import UIKit

class DetailViewController:UIViewController
{
    
    @IBOutlet var imageView : UIImageView = nil
    @IBOutlet var appNameLabel : UILabel = nil
    @IBOutlet var sellerNameLabel : UILabel = nil
    @IBOutlet var versionLabel : UILabel = nil
    @IBOutlet var priceLabel : UILabel = nil
    @IBOutlet var textView : UITextView = nil
    
    var selectedItem = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        var urlString = self.selectedItem["artworkUrl100"] as NSString
        var imgURL = NSURL(string: urlString)
        var request: NSURLRequest = NSURLRequest(URL: imgURL)
        self.imageView.image = UIImage(named: "placeholder")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if !error? {
                self.imageView.image = UIImage(data: data)
                 UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            else
            {
                println("Error: \(error.localizedDescription)")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            })

        self.title = "Detail";
        self.appNameLabel.text = self.selectedItem["trackName"] as NSString
        self.versionLabel.text = self.selectedItem["version"] as NSString
        self.priceLabel.text = self.selectedItem["formattedPrice"] as String
        self.sellerNameLabel.text = self.selectedItem["sellerName"] as String
        
        self.textView.text = self.selectedItem["description"] as String
    }
    
}