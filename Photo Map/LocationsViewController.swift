//
//  LocationsViewController.swift
//  Photo Map
//
//  Created by Timothy Lee on 10/20/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, LocationsViewControllerDelegate {

    // TODO: Fill in actual CLIENT_ID and CLIENT_SECRET
    let CLIENT_ID = "QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL"
    let CLIENT_SECRET = "W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    weak var delegate: LocationsViewControllerDelegate!
    var results: NSArray = []
    var annot: [MKAnnotation] = []
    var ima: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        
        
        cell.location = results[(indexPath as NSIndexPath).row] as! NSDictionary
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This is the selected venue
        let venue = results[(indexPath as NSIndexPath).row] as! NSDictionary

        let lat = venue.value(forKeyPath: "location.lat") as! Double
        let lng = venue.value(forKeyPath: "location.lng") as! Double
        
        

        let latString = "\(lat)"
        let lngString = "\(lng)"

        print(latString + " gg " + lngString)
        LocationsPickedLocation(controller:self
            , latitude: lat, longitude: lng)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        fetchLocations(newText)
        print("search bar func 1")
        return true
    }
    
    func LocationsPickedLocation(controller: LocationsViewController, latitude: Double, longitude: Double){
       
        var local = CLLocationCoordinate2D (latitude: latitude,longitude: longitude)
        
        let PhotoMapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoMapViewController") as! PhotoMapViewController
        PhotoMapViewController.g = "sue no problem"
        let annotation = MKPointAnnotation()
        annotation.coordinate = local
       annotation.title = "Picture!"
      //  PhotoMapViewController.MapKitView.addAnnotation(annotation)
        annot.append(annotation)
        PhotoMapViewController.anno = annot
        PhotoMapViewController.imag = ima
        self.navigationController?.pushViewController(PhotoMapViewController, animated: true)
        
        
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchLocations(searchBar.text!)
        print("search bar func 2")

    }
    
    func fetchLocations(_ query: String, near: String = "San Francisco") {
        let baseUrlString = "https://api.foursquare.com/v2/venues/search?"
        let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&near=\(near),CA&query=\(query)"

        let url = URL(string: baseUrlString + queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let request = URLRequest(url: url)

        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.results = responseDictionary.value(forKeyPath: "response.venues") as! NSArray
                            self.tableView.reloadData()

                    }
                }
        });
        task.resume()
    }

}

protocol LocationsViewControllerDelegate : class {
    func LocationsPickedLocation(controller: LocationsViewController, latitude: Double, longitude: Double)
}


