//
//  TodayViewController.swift
//  Places NearMe
//
//  Created by Arian Gonzalez on 3/19/18.
//  Copyright © 2018 AGlez. All rights reserved.
//

import UIKit
import NotificationCenter
import MapKit



class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var businessView: UITableView!
    var businesses = [[String : String]] ()
    var bizLocations = [[Double]] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        businessView.delegate = self
        businessView.dataSource = self
        // Do any additional setup after loading the view from its nib.
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        let groupData = UserDefaults(suiteName: "group.com.Aglez.NearMe")
       
        if let biz = groupData?.value(forKey: "business") as? [[String : String]]
        {
           businesses = biz
        }
        if let loc = groupData?.value(forKey: "locations") as? [[Double]]{
            bizLocations = loc
        }
        businessView.reloadData()
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize)
    {
     
        let size = CGSize(width: 398, height: 345)
        
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            preferredContentSize = size
        
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell",
                                                 for: indexPath) as! TodayViewTableViewCell
        cell.name.text = businesses[indexPath.row]["name"]
        
        let dist:String = businesses[indexPath.row]["distance"]!
        let distance:Double = Double(dist)!/1609.34
        cell.distance.text = String(format: "%.2f", distance) + " miles"
        cell.rating.text = "Rating: " + businesses[indexPath.row]["rating"]!
        

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lat = bizLocations[indexPath.row][0]
        let lon = bizLocations[indexPath.row][1]
        
       
            let latitude:CLLocationDegrees = lat
            let longitude:CLLocationDegrees = lon
            
            let regionDistance:CLLocationDistance = 1000;
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
            
            let placeHolder = MKPlacemark(coordinate: coordinates)
            let mapItem = MKMapItem(placemark:placeHolder)
            mapItem.name = businesses[indexPath.row]["name"]
            mapItem.openInMaps(launchOptions: options)
            
        
        
    }

}
