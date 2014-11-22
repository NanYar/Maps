//
//  ViewController.swift
//  Maps
//
//  Created by NanYar on 21.11.14.
//  Copyright (c) 2014 NanYar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate //, MKMapViewDelegate
{
    // @IBOutlet Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nearestAddressLabel: UILabel!
    
    // Properties
    var locationManager: CLLocationManager!
    var nearestAddress: String = ""
    
    
    // Default Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        println("activePlace VC: \(activePlace)")
        let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
        let lon = NSString(string: places[activePlace]["lon"]!).doubleValue
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lon
        
        
        
        // Creating a longPressRecognizer
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "action:")
        longPressGestureRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // @IBActions
    @IBAction func findMeBarButtonItemPressed(sender: UIBarButtonItem)
    {
        // Core Location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // Helper Functions
    
    // UILongPressGestureRecognizer
    func action(gestureRecognizer: UIGestureRecognizer)
    {
        // Creating an annotation
        let touchPoint: CGPoint = gestureRecognizer.locationInView(mapView)
        let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let newAnnotation: MKPointAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = newCoordinate
        mapView.addAnnotation(newAnnotation)
    }
    
    // CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        // Defining actual coordinates
        let userLocation: CLLocation = locations[0] as CLLocation
        let latitude: CLLocationDegrees = userLocation.coordinate.latitude
        let longitude: CLLocationDegrees = userLocation.coordinate.longitude
        
        // Adjusting zoom level
        let latitudeDelta: CLLocationDegrees = 0.005
        let longitudeDelta: CLLocationDegrees = 0.005
        
        // Creating a range
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        // Creating a location
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // Creation a region
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Setting up the mapView
        self.mapView.setRegion(region, animated: true)
        
        
        // Creating an annotation
        let newAnnotation: MKPointAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = location
        self.mapView.addAnnotation(newAnnotation)
        
        // Creating a geocoder
        self.nearestAddressLabel.hidden = false
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:
        { (placemarks, error) -> Void in
            if error == nil
            {
                let myPlacemark: CLPlacemark = CLPlacemark(placemark: placemarks[0] as CLPlacemark)
                
                // nil - Werte ausblenden
                var subThoroughfare: String
                if myPlacemark.subThoroughfare != nil
                {
                    subThoroughfare = myPlacemark.subThoroughfare
                }
                else
                {
                    subThoroughfare = ""
                }
                
                var thoroughfare: String
                if myPlacemark.thoroughfare != nil
                {
                    thoroughfare = myPlacemark.thoroughfare
                }
                else
                {
                    thoroughfare = ""
                }
                
                self.nearestAddressLabel.text =
                    "\"\(myPlacemark.name)\"\n\n" +
                    "\(thoroughfare) \(subThoroughfare)\n" +
                    "\(myPlacemark.ISOcountryCode)-\(myPlacemark.postalCode) \(myPlacemark.locality)\n" +
                    "\(myPlacemark.administrativeArea)\n" +
                    "\(myPlacemark.country)"
            }
            else
            {
                self.nearestAddressLabel.text = "Error: \(error)"
            }
        } )
        
        
        //println("Länge: \(userLocation.coordinate.longitude) / Breite: \(userLocation.coordinate.latitude)")
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println(error) // TODO: UIAlert
    }

}



















