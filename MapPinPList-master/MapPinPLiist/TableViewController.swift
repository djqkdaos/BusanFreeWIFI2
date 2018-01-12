//
//  TableViewController.swift
//  MapPinPLiist
//
//  Created by L703 on 2017. 12. 2..
//  Copyright © 2017년 김종현. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var installation_place: UITableViewCell!
    @IBOutlet weak var detail_installation_place: UITableViewCell!
    @IBOutlet weak var wifi_SSID: UITableViewCell!
    @IBOutlet weak var tel: UITableViewCell!
    
    
    
    var tItems:[[String:String]] = []
    var annoTitle:String = ""
    var indexName : [String] = []
    var indexNum : Int = 0
    var annoLat: Double?
    var annoLong: Double?
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        print(annoTitle)
        installation_place.textLabel?.text = "설치장소명"
        installation_place.detailTextLabel?.text = annoTitle
        print("---------------------------")
        //print(tItems)
        for i in tItems{
            let title = (i as AnyObject).value(forKey: "설치장소명")
            indexName.append(title as! String)
            
            
            let indexOfA = indexName.index(of: annoTitle)
            if indexOfA != nil {
                indexNum = indexOfA!
            }
            
            
            
        }
        print(indexNum)
        //let indexNum = indexOfA as! Int
        
        let content = tItems[indexNum]
        print(content)
        let detailTitle = (content as AnyObject).value(forKey: "설치장소상세")
        let wifiSSID = (content as AnyObject).value(forKey: "와이파이SSID")
        let telNum = (content as AnyObject).value(forKey: "관리기관전화번호")
        let lat = (content as AnyObject).value(forKey: "위도")
        let long = (content as AnyObject).value(forKey: "경도")
        annoLat = (lat as! NSString).doubleValue
        annoLong = (long as! NSString).doubleValue
        detail_installation_place.textLabel?.text = "설치장소상세"
        detail_installation_place.detailTextLabel?.text = detailTitle as? String
        wifi_SSID.textLabel?.text = "WIFI SSID"
        wifi_SSID.detailTextLabel?.text = wifiSSID as? String
        tel.textLabel?.text = "관리기관 전화번호"
        tel.detailTextLabel?.text = telNum as? String
        
        
        //print(indexName)
        // 현재 위치 트랙킹
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        detailMapView.showsUserLocation = true
        
        zoomToRegion()
        
        let anno = MKPointAnnotation()
        anno.coordinate.latitude = annoLat!
        anno.coordinate.longitude = annoLong!
        anno.title = annoTitle
        anno.subtitle = detailTitle as? String
        
        detailMapView.addAnnotation(anno)
        detailMapView.selectAnnotation(anno, animated: true)
        
        self.title = "부산 공공 와이파이"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func zoomToRegion() {
        // 35.162685, 129.064238
        let center = CLLocationCoordinate2DMake(annoLat!, annoLong!)
        let span = MKCoordinateSpanMake(0.4, 0.4)
        let region = MKCoordinateRegionMake(center, span)
        detailMapView.setRegion(region, animated: true)
    }
    @IBAction func showMeWhere(_ sender: Any) {
        let latitude:CLLocationDegrees = annoLat!
        let longitude:CLLocationDegrees = annoLong!
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = annoTitle
        mapItem.openInMaps(launchOptions: options)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 4
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
