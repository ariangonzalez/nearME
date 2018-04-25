//
//  TableViewController.swift
//  NearMe
//
//  Created by Arian Gonzalez on 3/20/18.
//  Copyright © 2018 AGlez. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
import CDYelpFusionKit



class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    var businesses = [[String:String]] ()
    var bizLocation = [[Double]] ()
    var yelpData = [CDYelpBusiness] ()
    var locationManager = CLLocationManager()
    
    // MARK: Outlets
    
    @IBOutlet var locationsTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //Function is calleed when device's location changes.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations[0];
        
        //Search for business in a 3000 meters range using YelpAPI
        YelpAPIManager.shared.apiClient.cancelAllPendingAPIRequests()
        YelpAPIManager.shared.apiClient.searchBusinesses(byTerm: nil,
                                                         location: nil,
                                                         latitude: location.coordinate.latitude,
                                                         longitude: location.coordinate.longitude,
                                                         radius: 3000,
                                                         categories: [],
                                                         locale: .english_unitedStates,
                                                         limit: 8,
                                                         offset: 0,
                                                         sortBy: .distance,
                                                         priceTiers: nil,
                                                         openNow: true,
                                                         openAt: nil,
                                                         attributes: nil) { (response) in
                                                            //save result for further analysis.
                                                            if let response = response,
                                                                let businesses = response.businesses,
                                                                businesses.count > 0 {
                                                                self.yelpData = businesses
                                                            }
        }
        self.locationsTableView.reloadData()
        
        
        let groupData = UserDefaults(suiteName: "group.com.Aglez.NearMe")
        if yelpData.count > 0
        {
     
            for business in yelpData{

               let bus : [String:String] = ["name" : business.name!,
                                            "distance" : String(business.distance!),
                                            "rating" : String(business.rating!),
                                            "latitude": String(describing: business.coordinates?.latitude!),
                                            "longitude": String(describing: business.coordinates?.longitude!)]
               businesses.append(bus)
                let locations : [Double] = [(business.coordinates?.latitude)!, (business.coordinates?.longitude)!]
                bizLocation.append(locations)
            }
                groupData?.set(businesses, forKey: "business")
                groupData?.set(bizLocation, forKey: "locations")
        
        }
    
        
    }
    
    
}
extension TableViewController {

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell =  locationsTableView.dequeueReusableCell(withIdentifier: "LocationCell") as! BusinessCell
        
        cell.business = yelpData[indexPath.row]
        
       
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yelpData.count
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let latitude:CLLocationDegrees = (yelpData[indexPath.row].coordinates?.latitude)!
        let longitude:CLLocationDegrees = (yelpData[indexPath.row].coordinates?.longitude)!
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeHolder = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark:placeHolder)
        mapItem.name = yelpData[indexPath.row].name
        mapItem.openInMaps(launchOptions: options)
        
    }

    
    
}

