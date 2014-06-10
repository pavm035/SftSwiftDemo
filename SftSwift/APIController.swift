//
//  APIController.swift
//  MyTableView
//
//  Created by Pavanm OP on 10/06/14.
//  Copyright (c) 2014 Openpeak. All rights reserved.
//


import UIKit

protocol APIControllerProtocol
{
    func didRecieveAPIResults(results: NSDictionary)
}

class APIController
{
    var delegate: APIControllerProtocol? = nil
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func searchInItunesStore(searchTerm: String)
    {
        //replace " " by "+"
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        //escape
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var itunesUrlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        var requestUrl = NSURL(string: itunesUrlPath)
        var request = NSURLRequest(URL: requestUrl)
        println("Search url \(requestUrl)")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error? {
                println("ERROR: (error.localizedDescription)")
            }
            else {
                var error: NSError?
                let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                // Now send the JSON result to our delegate object
                if error? {
                    println("HTTP Error: (error?.localizedDescription)")
                }
                else {
                    println("Results recieved")
                    self.delegate?.didRecieveAPIResults(jsonResult)
                }
            }
            })
    }
}
