//
//  LocationsViewController.swift
//  Photo Map
//
//  Created by Timothy Lee on 10/20/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

protocol LocationsViewControllerDelegate : class{
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber)
}

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var results: NSArray = []
    
    weak var delegate : LocationsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchLocations("Ho Chi Minh City", near: "Vung Tau")

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell
        
        cell.location = results[indexPath.row] as! NSDictionary
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).stringByReplacingCharactersInRange(range, withString: text)
        fetchLocations(newText)
        
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fetchLocations(searchBar.text!)
    }
    
    func fetchLocations(query: String, near: String = "Sunnyvale") {
        let url = "https://api.foursquare.com/v2/venues/search?client_id=QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL&client_secret=W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU&v=20141020&near=\(near),CA&query=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
        let request = NSURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if (data != nil) {
                
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
              
                self.results = responseDictionary.valueForKeyPath("response.venues") as! NSArray
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // This is the selected venue
        let venue = results[indexPath.row] as! NSDictionary
        
        let lat = venue.valueForKeyPath("location.lat") as! NSNumber
        let lng = venue.valueForKeyPath("location.lng") as! NSNumber
        
        let latString = "\(lat)"
        let lngString = "\(lng)"
        
        print(latString + " " + lngString)
        
        delegate?.locationsPickedLocation(self, latitude: lat, longitude: lng)
        print("dismiss")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        var cell = sender as! UITableViewCell
//        var indexPath = tableView.indexPathForCell(cell)!
//        
//        // This is the selected venue
//        var venue = results[indexPath.row] as! NSDictionary
//        
//        var lat = venue.valueForKeyPath("location.lat") as! NSNumber
//        var lng = venue.valueForKeyPath("location.lng") as! NSNumber
//        
//        var latString = "\(lat)"
//        var lngString = "\(lng)"
//        
//        print(latString + " " + lngString)
//        
//        delegate?.locationsPickedLocation(self, latitude: lat, longitude: lng)
//        print("dismiss")
//        dismissViewControllerAnimated(true, completion: nil)
//    }

}
